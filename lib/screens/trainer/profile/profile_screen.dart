import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  final bool isTrainer;

  ProfileScreen({required this.isTrainer});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  bool _isEditing = false;
  String? _profileImageUrl;
  bool _isLoading = false;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() => _isLoading = true);

    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String collection = widget.isTrainer ? 'trainers' : 'trainees';

      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection(collection).doc(uid).get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        _nameController.text = data['name'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _bioController.text = data['bio'] ?? '';

        // Debugging: Check if Firestore has the image URL
        print("Firestore Profile Image URL: ${data['profileImage']}");

        setState(() {
          _profileImageUrl = data['profileImage'] ?? ''; // Ensure URL is set
        });
      } else {
        print("No document found for user: $uid");
      }
    } catch (e) {
      print("Firestore Load Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }


  Future<void> _updateProfile() async {
    setState(() => _isLoading = true);

    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String collection = widget.isTrainer ? 'trainers' : 'trainees';

      Map<String, dynamic> updateData = {
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'bio': _bioController.text.trim(),
      };

      // Only update profileImage if it's not null
      if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
        updateData['profileImage'] = _profileImageUrl;
      }

      await FirebaseFirestore.instance.collection(collection).doc(uid).update(updateData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );

      setState(() {
        _isEditing = false; // Exit edit mode after successful save
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }


  Future<void> _pickImage({bool fromCamera = false}) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery);
    if (pickedImage != null) {
      setState(() => _isLoading = true);
      try {
        String uid = FirebaseAuth.instance.currentUser!.uid;
        final ref =
        FirebaseStorage.instance.ref().child('profileImages/$uid.jpg');
        await ref.putFile(File(pickedImage.path));
        final url = await ref.getDownloadURL();

        setState(() => _profileImageUrl = url);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: ${e.toString()}')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Color(0xFF121212) : Color(0xFFF4F4F4),
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: _isDarkMode ? Color(0xFF212121) : Color(0xFF0066CC),
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Switch(
            value: _isDarkMode,
            onChanged: (value) {
              setState(() => _isDarkMode = value);
            },
            activeColor: Colors.orangeAccent,
          ),
          IconButton(
            icon: Icon(_isEditing ? Icons.done : Icons.edit, color: Colors.white),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: 20),
            _buildProfileImage(),
            SizedBox(height: 20),
            _buildProfileField('Name', _nameController, Icons.person, _isEditing),
            _buildProfileField('Phone', _phoneController, Icons.phone, _isEditing,
                keyboardType: TextInputType.phone),
            _buildProfileField('Bio', _bioController, Icons.description, _isEditing,
                maxLines: 3),
            SizedBox(height: 20),
            if (_isEditing) _buildSaveChangesButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 70,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: _profileImageUrl != null
                ? NetworkImage(_profileImageUrl!)
                : AssetImage('assets/images/profile_placeholder.png')
            as ImageProvider,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'camera') {
                  _pickImage(fromCamera: true);
                } else {
                  _pickImage(fromCamera: false);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'camera',
                  child: Row(
                    children: [
                      Icon(Icons.camera, color: Colors.blueAccent),
                      SizedBox(width: 8),
                      Text('Take Picture'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'gallery',
                  child: Row(
                    children: [
                      Icon(Icons.image, color: Colors.blueAccent),
                      SizedBox(width: 8),
                      Text('Choose from Gallery'),
                    ],
                  ),
                ),
              ],
              child: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                radius: 20,
                child: Icon(Icons.camera_alt, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileField(String label, TextEditingController controller,
      IconData icon, bool isEditable,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Card(
      color: _isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: TextField(
          controller: controller,
          enabled: isEditable,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveChangesButton() {
    return ElevatedButton(
      onPressed: _updateProfile,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      ),
      child: Text('Save Changes',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }
}

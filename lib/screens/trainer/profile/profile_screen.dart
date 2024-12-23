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
  bool _isEditing = false; // Tracks whether editing is enabled
  String? _profileImageUrl;
  bool _isLoading = false;
  bool _isDarkMode = true; // Default to dark mode

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _updateProfile() async {
    setState(() => _isLoading = true);

    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String collection = widget.isTrainer ? 'trainers' : 'trainees';

      await FirebaseFirestore.instance.collection(collection).doc(uid).update({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'bio': _bioController.text.trim(),
        'profileImage': _profileImageUrl,
      });

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
        _profileImageUrl = data['profileImage'];
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
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
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: _isDarkMode ? Colors.white : Colors.black),
          onPressed: () {
            Navigator.pop(context); // Return to Dashboard
          },
        ),
        actions: [
          // Dark Mode Toggle
          Switch(
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
              });
            },
            activeColor: Colors.blueAccent,
          ),
          IconButton(
            icon: Icon(
              _isEditing ? Icons.done : Icons.edit,
              color: _isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                _buildAnimatedProfileImage(),
                SizedBox(height: 20),
                if (widget.isTrainer) _buildTrainerExperience(),
                _buildSectionTitle('Personal Information'),
                _buildProfileField('Name', _nameController, Icons.person, _isEditing),
                _buildProfileField('Phone', _phoneController, Icons.phone, _isEditing,
                    keyboardType: TextInputType.phone),
                _buildProfileField('Bio', _bioController, Icons.description, _isEditing,
                    maxLines: 3),
                SizedBox(height: 20),
                _buildSectionTitle('Recent Activities'),
                _buildRecentActivity('Full Body Workout', '45 mins • 300 kcal', Icons.fitness_center),
                _buildRecentActivity('Yoga Session', '30 mins • Relaxed', Icons.spa),
                if (_isEditing)
                  ElevatedButton(
                    onPressed: () => _updateProfile(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: Text('Save Changes',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedProfileImage() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 70,
            backgroundColor: Colors.grey[900],
            backgroundImage: _profileImageUrl != null
                ? NetworkImage(_profileImageUrl!)
                : AssetImage('assets/profile_placeholder.png') as ImageProvider,
          ),
          if (_isEditing)
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _pickImage,
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

  Widget _buildTrainerExperience() {
    return Card(
      color: _isDarkMode ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.workspace_premium, color: Colors.orangeAccent),
        title: Text(
          'Trainer Experience',
          style: TextStyle(
              color: _isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '5+ Years of Training Experience\nCertified Personal Trainer',
          style: TextStyle(
              color: _isDarkMode ? Colors.white70 : Colors.black87),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _isDarkMode ? Colors.white70 : Colors.black87),
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, TextEditingController controller,
      IconData icon, bool isEditable,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Card(
      color: _isDarkMode ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.symmetric(vertical: 10),
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
            labelStyle: TextStyle(
                color: _isDarkMode ? Colors.white54 : Colors.black54),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity(String title, String subtitle, IconData icon) {
    return Card(
      color: _isDarkMode ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(
          title,
          style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: _isDarkMode ? Colors.white70 : Colors.black87),
        ),
      ),
    );
  }
}

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

  bool _isDarkMode = false; // For theme toggling
  bool _isTrainerExperienceVisible = true; // For showcasing trainer experience

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : Color(0xFF1E1E2E),
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
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
                // Optionally implement theme switching logic
              });
            },
            activeColor: Colors.blueAccent,
          ),
          IconButton(
            icon: Icon(_isEditing ? Icons.done : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: _isDarkMode ? Colors.black : Colors.white, // Black for dark mode, white for light mode
            ),
          ),

          // Foreground Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),

                    // Profile Image with Shadow
                    _buildAnimatedProfileImage(),

                    SizedBox(height: 20),

                    // Trainer Experience Section
                    if (widget.isTrainer && _isTrainerExperienceVisible)
                      _buildTrainerExperience(),

                    // Personal Information
                    _buildSectionTitle('Personal Information'),
                    _buildProfileField('Name', _nameController,
                        Icons.person, _isEditing),
                    _buildProfileField('Phone', _phoneController,
                        Icons.phone, _isEditing,
                        keyboardType: TextInputType.phone),
                    _buildProfileField('Bio', _bioController,
                        Icons.description, _isEditing,
                        maxLines: 3),

                    SizedBox(height: 20),

                    // Recent Activities
                    _buildSectionTitle('Recent Activities'),
                    _buildRecentActivity('Full Body Workout',
                        '45 mins • 300 kcal', Icons.fitness_center),
                    _buildRecentActivity('Yoga Session',
                        '30 mins • Relaxed', Icons.spa),

                    SizedBox(height: 20),

                    // Save Button
                    if (_isEditing)
                      ElevatedButton(
                        onPressed: () => _updateProfile(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                        ),
                        child: Text('Save Changes',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// Animated Profile Image
  Widget _buildAnimatedProfileImage() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 5,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 70,
              backgroundColor: Colors.white10,
              backgroundImage: _profileImageUrl != null
                  ? NetworkImage(_profileImageUrl!)
                  : AssetImage('assets/profile_placeholder.png')
              as ImageProvider,
            ),
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

// Trainer Experience Section
  Widget _buildTrainerExperience() {
    return Card(
      color: Colors.white10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(Icons.workspace_premium, color: Colors.orangeAccent),
        title: Text(
          'Trainer Experience',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          '5+ Years of Training Experience\nCertified Personal Trainer',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ),
    );
  }

// Recent Activity
  Widget _buildRecentActivity(String title, String subtitle, IconData icon) {
    return Card(
      color: Colors.white10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }



// Profile Image Widget
  Widget _buildProfileImage() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 70,
          backgroundColor: Colors.white10,
          backgroundImage: _profileImageUrl != null
              ? NetworkImage(_profileImageUrl!)
              : AssetImage('assets/images/profile_placeholder.png')
          as ImageProvider,
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
    );
  }

  Widget _buildProfileThemeFrame() {
    return Container(
      padding: EdgeInsets.all(4), // Padding around the frame
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blueAccent, // Frame border color
          width: 4, // Frame thickness
        ),
        borderRadius: BorderRadius.circular(20), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 10,
            offset: Offset(4, 4), // Shadow effect
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16), // Rounded image corners
        child: Image.asset(
          'assets/images/profile_theme.webp',
          fit: BoxFit.cover, // Ensures the image fills the space properly
          height: 200, // Set the height for consistency
          width: double.infinity, // Stretches the width to match parent
        ),
      ),
    );
  }

// Section Title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70),
        ),
      ),
    );
  }

// Profile Input Field
  Widget _buildProfileField(String label, TextEditingController controller,
      IconData icon, bool isEditable,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Card(
      color: Colors.white10,
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
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

// Save Changes Button
  Widget _buildSaveChangesButton() {
    return ElevatedButton(
      onPressed: _updateProfile,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      ),
      child: Text('Save Changes',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}

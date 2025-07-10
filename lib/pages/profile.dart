import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController photoController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    photoController.dispose();
    super.dispose();
  }

  Future<void> _changeUsername() async {
    final user = FirebaseAuth.instance.currentUser;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Username"),
        content: TextField(
          decoration: const InputDecoration(
            hintText: "Enter your new username",
            hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          controller: usernameController,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final newUsername = usernameController.text.trim();
              if (newUsername.isNotEmpty && user != null) {
                try {
                  await user.updateDisplayName(newUsername);
                  await user.reload();
                  Navigator.of(context).pop();
                  setState(() {});
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Error: $e")));
                }
              }
            },
            child: const Text("Change"),
          ),
        ],
      ),
    );
  }

  Future<void> _changePhoto() async {
    final user = FirebaseAuth.instance.currentUser;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Photo"),
        content: TextField(
          decoration: const InputDecoration(
            hintText: "Enter the url to your new photo",
            hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          controller: photoController,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final newPhoto = photoController.text.trim();
              if (newPhoto.isNotEmpty) {
                try {
                  await user?.updatePhotoURL(newPhoto);
                  Navigator.of(context).pop();
                  setState(() {});
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Error: $e")));
                }
              }
            },
            child: const Text("Change"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: user == null
          ? const Center(child: Text("No user is currently signed in."))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user.photoURL != null
                        ? NetworkImage(user.photoURL!)
                        : const AssetImage("assets/images/user.jpg")
                              as ImageProvider,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Name: ${user.displayName ?? "Not set"}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Email: ${user.email ?? "Not available"}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: user.providerData.length,
                    itemBuilder: (context, index) {
                      final providerProfile = user.providerData[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: providerProfile.photoURL != null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    providerProfile.photoURL!,
                                  ),
                                )
                              : const CircleAvatar(child: Icon(Icons.person)),
                          title: Text(providerProfile.displayName ?? "No name"),
                          subtitle: Text(
                            "${providerProfile.email ?? "No email"}\n"
                            "Provider: ${providerProfile.providerId}\n"
                            "UID: ${providerProfile.uid}",
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _changeUsername,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                        ),
                        child: Text(
                          "Change the username",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _changePhoto,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                        ),
                        child: Text(
                          "Change the photo",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

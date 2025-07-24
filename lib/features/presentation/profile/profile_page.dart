import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/core/routes/navigation_helper.dart';
import 'package:movieapp/core/routes/routes.dart';
import 'package:movieapp/features/data/cubit/auth_cubit.dart';
import 'package:movieapp/features/data/cubit/auth_state.dart';
import 'package:movieapp/core/widgets/custom_button.dart';
import 'package:movieapp/core/widgets/loading_widget.dart';
import 'package:movieapp/features/presentation/photo_upload/view/photo_upload_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop();
                Navigation.pushReplacementNamed(root: Routes.login);
                context.read<AuthCubit>().logout();
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Profile', style: TextStyle(color: Colors.black87)),
        actions: [
          Builder(
            builder: (context) {
              final state = context.watch<AuthCubit>().state;
              if (state.user == null) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.add_a_photo, color: Colors.blue),
                tooltip: 'Upload Photo',
                onPressed: () async {
                  // await Navigation.pushNamed(
                  //   root: Routes.photoUpload,
                  //   arg: {'user': state.user!, 'showBackButton': true},
                  // );
                  Navigation.push(page: PhotoUploadPage(user: state.user!, showBackButton: true));

                  // Refresh profile when returning from photo upload
                  if (context.mounted) {
                    context.read<AuthCubit>().getProfile();
                  }
                },
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (!state.isAuthenticated && !state.isLoading) {
            Navigation.pushReplacementNamed(root: Routes.login);
          }

          if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red));
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const LoadingWidget(message: 'Loading profile...');
          }

          if (state.user == null) {
            return const Center(child: Text('No user data available'));
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Avatar
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child:
                              state.user!.photoUrl != null && state.user!.photoUrl!.isNotEmpty
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      state.user!.photoUrl!,
                                      fit: BoxFit.cover,
                                      width: 100,
                                      height: 100,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Icon(Icons.person, size: 50, color: Colors.blue.shade600),
                                    ),
                                  )
                                  : Icon(Icons.person, size: 50, color: Colors.blue.shade600),
                        ),
                        const SizedBox(height: 16),

                        // User Name
                        Text(
                          state.user!.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),

                        // User Email
                        Text(state.user!.email, style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // User Info Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Account Information',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 20),

                        // User ID
                        _buildInfoRow('User ID', state.user!.id),
                        const SizedBox(height: 16),

                        // Email
                        _buildInfoRow('Email', state.user!.email),
                        const SizedBox(height: 16),

                        // Name
                        _buildInfoRow('Full Name', state.user!.name),
                        const SizedBox(height: 16),

                        // Token Status
                        _buildInfoRow('Token Status', state.user!.token != null ? 'Active ✅' : 'No Token ❌'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // App Features Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'App Features',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 20),

                        _buildFeatureRow(Icons.movie, 'Browse Movies', 'Coming Soon'),
                        _buildFeatureRow(Icons.favorite, 'Favorites', 'Coming Soon'),
                        _buildFeatureRow(Icons.history, 'Watch History', 'Coming Soon'),
                        _buildFeatureRow(Icons.settings, 'Settings', 'Coming Soon'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Logout Button
                  CustomButton(
                    text: 'Logout',
                    onPressed: () => _logout(context),
                    backgroundColor: Colors.red,
                    isLoading: state.isLoading,
                  ),

                  const SizedBox(height: 24),

                  // App Version
                  Text('Movie App v1.0.0', style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade600)),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 14, color: Colors.black87))),
      ],
    );
  }

  Widget _buildFeatureRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}

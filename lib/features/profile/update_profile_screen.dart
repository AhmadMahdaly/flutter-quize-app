import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/shared_widgets/custom_primary_button.dart';
import 'package:smle/core/shared_widgets/custom_primary_textfield.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  late MainLayoutCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<MainLayoutCubit>();

    nameController.text = cubit.profileModel?.data?.name ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Update Profile'),
      body: BlocConsumer<MainLayoutCubit, MainLayoutState>(
        listener: (context, state) {
          if (state is GetProfileSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is GetProfileFailedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to update profile'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final String? previousImageUrl = cubit.profileModel?.data?.photo;

          return SingleChildScrollView(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                20.verticalSpace,

                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60.r,
                        backgroundColor: Colors.grey[200],

                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : (previousImageUrl != null &&
                                  previousImageUrl.isNotEmpty)
                            ? NetworkImage(previousImageUrl) as ImageProvider
                            : null,

                        child:
                            _selectedImage == null &&
                                (previousImageUrl == null ||
                                    previousImageUrl.isEmpty)
                            ? Icon(Icons.person, size: 60.r, color: Colors.grey)
                            : null,
                      ),
                      CircleAvatar(
                        radius: 18.r,
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.camera_alt,
                          size: 18.r,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                40.verticalSpace,

                CustomPrimaryTextfield(
                  controller: nameController,
                  text: 'Full Name',
                ),

                40.verticalSpace,

                CustomPrimaryButton(
                  width: double.infinity,
                  onPressed: () {
                    if (nameController.text.trim().isNotEmpty) {
                      cubit.updateProfile(
                        name: nameController.text.trim(),
                        photo: _selectedImage,
                      );
                    }
                  },
                  text: 'Save Changes',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

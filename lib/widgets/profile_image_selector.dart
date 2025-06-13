import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Widget for selecting a profile image from camera or preset grid
class ProfileImageSelector extends StatefulWidget {
  // Initial image path to display
  final String? initialImagePath;

  // Callback function to pass the selected image path back to the parent
  final void Function(String imagePath) onImageSelected;

  const ProfileImageSelector({
    super.key,
    this.initialImagePath,
    required this.onImageSelected,
  });

  @override
  State<ProfileImageSelector> createState() => _ProfileImageSelectorState();
}

class _ProfileImageSelectorState extends State<ProfileImageSelector> {
  // Currently selected image path
  String? _selectedImagePath;

  // List of preset images
  // Dymamically generate a list of image paths for preset images
  final List<String> _presetImages = List.generate(
    // Number of avatars you have, change this to the number of your preset images
    8, 
    // Generate asset paths for preset images using for loop
    (i) => 'assets/images/profile_images/avatar${i + 1}.png',
);



  @override
  void initState() {
    super.initState();
    // Use the initial image path if provided, otherwise use a default image
    _selectedImagePath = widget.initialImagePath ?? 'assets/images/default_profile.png';
  }

  // Update the selected image path if the initial image path changes, for existing captains
  @override
  void didUpdateWidget(covariant ProfileImageSelector oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialImagePath != oldWidget.initialImagePath &&
        widget.initialImagePath != null) {
      setState(() {
        _selectedImagePath = widget.initialImagePath!;
      });
    }
  }

  /// Opens the camera to take a new photo and saves it to the app directory
  /// If a photo is taken, it updates the selected image path and calls the callback function
  Future<void> _pickFromCamera() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);

    if (picked != null) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = path.basename(picked.path);
      final savedImage = await File(picked.path).copy('${directory.path}/$fileName');

      // Update image path and notify parent widget
      setState(() => _selectedImagePath = savedImage.path);
      widget.onImageSelected(savedImage.path);
    }
  }

  /// Opens a dialog to select a preset image
  void _selectPreset(String assetPath) {
    setState(() => _selectedImagePath = assetPath);
    widget.onImageSelected(assetPath);
    Navigator.pop(context); // Close dialog after selection
  }

  /// Shows options for selecting an image: camera or preset image grid
  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Wrap(
          children: [
            // Camera option
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.white),
              title: const Text('Take a Photo', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _pickFromCamera();
              },
            ),
            // Preset image option
            ListTile(
              leading: const Icon(Icons.image, color: Colors.white),
              title: const Text('Choose Preset', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Future.microtask(() => _showPresetGrid());
              },
            ),
          ],
        );
      },
    );
  }

  /// Shows a grid of preset images for selection
  void _showPresetGrid() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: _presetImages.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final asset = _presetImages[index];
              return GestureDetector(
                onTap: () => _selectPreset(asset),
                child: ClipRRect(
                  borderRadius: BorderRadius.zero,
                  child: Image(
                    image: asset.startsWith('assets/')
                        ? AssetImage(asset)
                        : FileImage(File(asset)) as ImageProvider,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if the selected image path is an asset or a file
    final isAsset = _selectedImagePath?.startsWith('assets/') ?? true;
    final imageProvider = isAsset
        ? AssetImage(_selectedImagePath!)
        : FileImage(File(_selectedImagePath!)) as ImageProvider;

    return GestureDetector(
      onTap: _showImageSourceOptions,
      child: ClipRRect(
        borderRadius: BorderRadius.zero,
        child: Image(
          image: imageProvider,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.none,
        ),
      ),
    );
  }
}

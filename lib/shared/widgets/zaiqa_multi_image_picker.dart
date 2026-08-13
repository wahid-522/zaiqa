import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';

class ZaiqaMultiImagePicker extends StatefulWidget {
  final String label;
  final String sublabel;
  final int minImages;
  final int maxImages;
  final List<String> initialImageUrls;
  final ValueChanged<List<String>> onChanged;

  const ZaiqaMultiImagePicker({
    super.key,
    required this.label,
    required this.sublabel,
    this.minImages = 1,
    this.maxImages = 5,
    this.initialImageUrls = const [],
    required this.onChanged,
  });

  @override
  State<ZaiqaMultiImagePicker> createState() => _ZaiqaMultiImagePickerState();
}

class _ZaiqaMultiImagePickerState extends State<ZaiqaMultiImagePicker> {
  final List<String> _imagePaths = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _imagePaths.addAll(widget.initialImageUrls);
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_imagePaths.length >= widget.maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Maximum ${widget.maxImages} photos allowed')),
      );
      return;
    }

    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1200,
      );
      if (file != null) {
        setState(() {
          _imagePaths.add(file.path);
        });
        widget.onChanged(List.from(_imagePaths));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not access image: $e')),
        );
      }
    }
  }

  void _showUrlDialog() {
    final urlController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add Image URL'),
          content: TextField(
            controller: urlController,
            decoration: const InputDecoration(
              hintText: 'https://images.unsplash.com/...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () {
                final url = urlController.text.trim();
                if (url.isNotEmpty) {
                  setState(() {
                    _imagePaths.add(url);
                  });
                  widget.onChanged(List.from(_imagePaths));
                }
                Navigator.pop(context);
              },
              child: const Text('Add Photo', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showPickerModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.label,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2C221E)),
                ),
                const SizedBox(height: 4),
                Text(widget.sublabel, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                const SizedBox(height: 16),

                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: Color(0xFFFFF0EC), shape: BoxShape.circle),
                    child: const Icon(Icons.camera_alt_rounded, color: AppColors.primary),
                  ),
                  title: const Text('Take Photo (Camera)', style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                const Divider(height: 1),

                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: Color(0xFFFFF0EC), shape: BoxShape.circle),
                    child: const Icon(Icons.photo_library_rounded, color: AppColors.primary),
                  ),
                  title: const Text('Choose from Gallery / PC', style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                const Divider(height: 1),

                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                    child: Icon(Icons.link_rounded, color: Colors.grey.shade700),
                  ),
                  title: const Text('Enter Web Image URL', style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.pop(context);
                    _showUrlDialog();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _removeImage(int index) {
    setState(() {
      _imagePaths.removeAt(index);
    });
    widget.onChanged(List.from(_imagePaths));
  }

  Widget _buildImageTile(String path, int index) {
    final isWeb = kIsWeb;
    final isUrl = path.startsWith('http://') || path.startsWith('https://');

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: isUrl || isWeb
              ? Image.network(
                  path,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 90,
                    height: 90,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                )
              : Image.file(
                  File(path),
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 90,
                    height: 90,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2C221E)),
            ),
            Text(
              '${_imagePaths.length}/${widget.maxImages} (Min ${widget.minImages})',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _imagePaths.length >= widget.minImages ? Colors.green.shade700 : AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(widget.sublabel, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 10),

        SizedBox(
          height: 95,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _imagePaths.length + (_imagePaths.length < widget.maxImages ? 1 : 0),
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              if (index < _imagePaths.length) {
                return _buildImageTile(_imagePaths[index], index);
              }

              return GestureDetector(
                onTap: _showPickerModal,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0EC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.5), width: 1.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add_a_photo_outlined, size: 24, color: AppColors.primary),
                      SizedBox(height: 4),
                      Text('Add Photo', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

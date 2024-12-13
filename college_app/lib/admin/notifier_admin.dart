import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class notifier_admin extends ChangeNotifier {
  XFile? selectedImage;
  String? imageUrl;

  final picker = ImagePicker();

  void open_gallery() async {
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      selectedImage = pickedImage;
      notifyListeners();
      upload_image_middleware();
    }
  }

  void upload_image_middleware() async {
    await upload_image(selectedImage!);
  }

  Future<String?> upload_image(XFile image) async {
    try {
      final cloudinary = CloudinaryPublic('dgf5mlrnz', 'images_of_cars');

      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          await image.readAsBytes(),
          identifier: 'picked_image',
          folder: 'categoryimages',
        ),
      );

      imageUrl = imageResponse.secureUrl;

      print(imageUrl);

      return imageResponse.secureUrl;
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }
}

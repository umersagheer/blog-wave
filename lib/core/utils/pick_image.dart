import "package:image_picker/image_picker.dart";

Future<XFile?> pickImage() async {
  try {
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      return xFile;
    }
    return null;
  } catch (e) {
    return null;
  }
}

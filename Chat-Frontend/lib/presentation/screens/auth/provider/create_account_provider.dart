import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/ui.dart';
import '../../../../logic/cubits/user/user_cubit.dart';
import '../../../../logic/cubits/user/user_state.dart';
import '../../../../logic/services/formatter.dart';

class CreateAccProvider extends ChangeNotifier {
  final BuildContext context;
  CreateAccProvider(this.context) {
    _listenToUser();
  }
  final nameCon = TextEditingController();
  final userName = TextEditingController();
  final emailCon = TextEditingController();
  final passwordCon = TextEditingController();
  final againPasswordCon = TextEditingController();
  final key = GlobalKey<FormState>();
  bool isCreateAccount = false;
  String message = "";
  bool isShowPass = true;
  StreamSubscription? _subscription;
  _listenToUser() {
    _subscription = BlocProvider.of<UserCubit>(context).stream.listen((state) {
      if (state is UserLoadingState) {
        isCreateAccount = true;
        message = "";
        notifyListeners();
      } else if (state is UserErrorState) {
        isCreateAccount = false;
        message = state.message.toString();
        notifyListeners();
      } else {
        isCreateAccount = false;
        message = "";
        notifyListeners();
      }
    });
  }

  //hide and show password
  void onShowPass() {
    if (isShowPass) {
      isShowPass = false;
    } else {
      isShowPass = true;
    }
    notifyListeners();
  }

  // pick image
  XFile? image;
  //pic web image
  Uint8List? webImage; // For web
  Future pickImage({required ImageSource imageSource}) async {
    if (await checkPhotoPermission()) {
      try {
        // Step 1: Pick the image using ImagePicker
        final pickedFile = await ImagePicker().pickImage(
          source: imageSource,
          maxHeight: 400, // Set max height
          maxWidth: 400, // Set max width
        );

        if (pickedFile == null) return;
        if (kIsWeb) {
          // Handle Web Image
          webImage = await pickedFile.readAsBytes();
          image = pickedFile;
        } else {
          // Handle Mobile Image
          final compressedImage = await compressImage(File(pickedFile.path));
          if (compressedImage == null) {
            toast(message: "Failed to compress the image");
            return;
          }
          image = XFile(compressedImage.path);
        }
      } on PlatformException catch (e) {
        toast(
          message: "Failed to pick image: ${e.message}",
        );
      }
      notifyListeners();
    }
  }

  // compress picked image
  Future<XFile?> compressImage(File file) async {
    try {
      final filePath = file.absolute.path;

      // Step 1: Get the output path
      final lastIndex = filePath.lastIndexOf('.');
      final splitPath = filePath.substring(0, lastIndex);
      final outputPath = '${splitPath}_compressed.jpg';

      // Step 2: Compress the image
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        filePath,
        outputPath,
        quality: 85,
        minWidth: 400,
        minHeight: 400,
      );

      // Step 3: Check the file size
      if (compressedFile != null &&
          await compressedFile.length() > 1024 * 1024) {
        // Retry with lower quality if file exceeds 1 MB
        return await FlutterImageCompress.compressAndGetFile(
          filePath,
          outputPath,
          quality: 70, // Lower quality to reduce size further
        );
      }
      return compressedFile;
    } catch (e) {
      toast(message: "Error compressing image: $e");
      return null;
    }
  }

  //Create Account user
  void signUp() {
    if (!key.currentState!.validate()) return;
    Formatter.hideKeyboard();
    final name = nameCon.text.trim();
    final userNam = userName.text.trim();
    final email = emailCon.text.trim();
    final password = passwordCon.text.trim();
    BlocProvider.of<UserCubit>(context).register(
      username: userNam,
      email: email,
      image: image != null ? File(image!.path) : null,
      password: password,
      name: name,
    );
  }

  //
  Future<bool> checkPhotoPermission() async {
    // Check current camera permission status
    if (kIsWeb) return true;
    PermissionStatus status = await Permission.photos.status;
    if (status.isGranted) {
      // Permission is already granted
      return true;
    } else if (status.isDenied || status.isRestricted) {
      // Request permission if not granted
      PermissionStatus requestStatus = await Permission.photos.request();
      return requestStatus.isGranted;
    } else if (status.isPermanentlyDenied) {
      // If permission is permanently denied, open app settings
      await openAppSettings();
      return false;
    }
    return false;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

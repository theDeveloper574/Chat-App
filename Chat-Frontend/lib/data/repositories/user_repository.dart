import 'dart:convert';
import 'dart:io';

import 'package:chatapp/core/api.dart';
import 'package:chatapp/data/models/user_model.dart';
import 'package:chatapp/data/models/users_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class UserRepository {
  final api = Api();

  Future<CuUserModel> loginUser({
    required String user,
    required String password,
  }) async {
    try {
      final response = await api.sendRequest.post(
        "$BASE_URL/user/login",
        data: jsonEncode(
          {
            "user": user,
            "password": password,
          },
        ),
      );
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }
      return CuUserModel.fromJson(apiResponse.data);
    } on DioException catch (dioError) {
      throw ApiResponse.dioError(dioError);
    } catch (ex) {
      rethrow;
    }
  }

  Future<CuUserModel> register({
    String? name,
    File? avatar,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      Map<String, dynamic> mapData = {
        "userName": username,
        "email": email,
        "password": password,
      };
      if (name != null && name.isNotEmpty) {
        mapData["name"] = name;
      }
      if (avatar != null && avatar.path.isNotEmpty) {
        mapData['avatar'] = await MultipartFile.fromFile(avatar.path);
      }
      FormData data = FormData.fromMap(mapData);
      final apiRes = await api.sendRequest.post(
        "$BASE_URL/user/register",
        data: data,
      );
      ApiResponse apiResponse = ApiResponse.fromResponse(apiRes);
      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }
      return CuUserModel.fromJson(apiResponse.data);
    } on DioException catch (dioError) {
      throw ApiResponse.dioError(dioError);
    } catch (ex) {
      rethrow;
    }
  }

  //fetch all users
  Future<List<UsersModel>> fetchUsers() async {
    try {
      final response = await api.sendRequest.get("/user");
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }
      return (apiResponse.data as List<dynamic>)
          .map((e) => UsersModel.fromJson(e))
          .toList();
    } catch (ex) {
      rethrow;
    }
  }

  //update profile
  Future<CuUserModel> updateUserInfo(
    CuUserModel user, {
    XFile? newAvatar,
  }) async {
    try {
      // Prepare form data map from UserModel
      final Map<String, dynamic> formDataMap = user.toJson();

      // Check if the user selected a new avatar (Local File)
      if (newAvatar != null && newAvatar.path.isNotEmpty) {
        formDataMap["avatar"] = await MultipartFile.fromFile(newAvatar.path);
      }

      // Convert map to FormData
      FormData data = FormData.fromMap(formDataMap);

      // Send the PUT request to update user information
      final response = await api.sendRequest.put(
        "$BASE_URL/user/${user.sId}",
        data: data,
      );

      // Handle API response
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }

      // Return the updated UserModel from the API response
      return CuUserModel.fromJson(apiResponse.data);
    } on DioException catch (dioError) {
      if (dioError.type == DioExceptionType.connectionError) {
        throw "Connection error: Unable to connect to the server. Please check your internet connection.";
      } else {
        throw "An error occurred: ${dioError.message}";
      }
    } catch (ex) {
      rethrow;
    }
  }
}

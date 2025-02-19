import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const String ImgBaseUrl = "http://192.168.100.6:5002/";
const String serverURL = "http://192.168.100.6:5002";
const String BASE_URL = "http://192.168.100.6:5002/api";
const String resourceId = "zego_call";
const Map<String, dynamic> headers = {"Content-Type": "application/json"};
const int zogoAppId = 1875588248;
const String zogoAppSign =
    "d6b69c60c5161f66274687e779971d57ed692433d92449ea00a503e207c29819";

class Api {
  final Dio _dio;
  Api()
      : _dio = Dio(
          BaseOptions(
            baseUrl: BASE_URL,
            headers: headers,
            connectTimeout: const Duration(seconds: 10),
            sendTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        ) {
    _dio.interceptors.add(
      PrettyDioLogger(
        responseBody: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        request: true,
      ),
    );
  }
  Dio get sendRequest => _dio;
}

class ApiResponse {
  bool success;
  dynamic data;
  String? message;
  ApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory ApiResponse.fromResponse(Response response) {
    final data = response.data as Map<String, dynamic>;
    return ApiResponse(
      success: data["success"],
      data: data["data"],
      message: data["message"] ?? "an error occurred",
    );
  }
  factory ApiResponse.dioError(DioException dioError) {
    String errorMessage;

    if (dioError.type == DioExceptionType.connectionError) {
      errorMessage =
          "Connection error: Unable to connect to the server. Please check your internet connection.";
    } else if (dioError.type == DioExceptionType.connectionTimeout) {
      errorMessage = "Please check your internet connection.";
    } else {
      errorMessage = "An error occurred: ${dioError.message}";
    }
    return ApiResponse(success: false, message: errorMessage);
  }
}

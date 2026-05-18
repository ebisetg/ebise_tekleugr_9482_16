import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/exceptions/api_exception.dart';
import '../../models/volunteer.dart';

class VolunteerApiService {
  late Dio _dio;

  VolunteerApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: ApiConstants.connectionTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
      headers: {'Content-Type': 'application/json'},
    ));
  }

  Future<List<Volunteer>> getVolunteers() async {
    try {
      final response = await _dio.get(ApiConstants.volunteersEndpoint);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Volunteer.fromJson(json)).toList();
      }
      throw ApiException('Failed to load volunteers', statusCode: response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Volunteer> getVolunteerById(String id) async {
    try {
      final response = await _dio.get('${ApiConstants.volunteersEndpoint}/$id');
      if (response.statusCode == 200) {
        return Volunteer.fromJson(response.data);
      }
      throw ApiException('Failed to load volunteer', statusCode: response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Volunteer> createVolunteer(Volunteer volunteer) async {
    try {
      final response = await _dio.post(
        ApiConstants.volunteersEndpoint,
        data: volunteer.toJson(),
      );
      if (response.statusCode == 201) {
        return Volunteer.fromJson(response.data);
      }
      throw ApiException('Failed to create volunteer', statusCode: response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Volunteer> updateVolunteer(String id, Volunteer volunteer) async {
    try {
      final response = await _dio.put(
        '${ApiConstants.volunteersEndpoint}/$id',
        data: volunteer.toJson(),
      );
      if (response.statusCode == 200) {
        return Volunteer.fromJson(response.data);
      }
      throw ApiException('Failed to update volunteer', statusCode: response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> deleteVolunteer(String id) async {
    try {
      final response = await _dio.delete('${ApiConstants.volunteersEndpoint}/$id');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException('Failed to delete volunteer', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return ApiException('Connection timeout. Please check your internet.');
    } else if (e.type == DioExceptionType.connectionError) {
      return ApiException('No internet connection.');
    } else if (e.response != null) {
      return ApiException(
        'Server error: ${e.response?.statusCode}',
        statusCode: e.response?.statusCode,
      );
    }
    return ApiException('An unexpected error occurred');
  }
}
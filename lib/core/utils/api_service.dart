import 'package:dio/dio.dart';
class ApiService {
  final Dio dio = Dio();
  Future<Response> POST({
    required String url,
    required body,
    String? token,
    Map<String, String>? headers,
    String? contentType,
  }) async {
    var response = await dio.post(
      url,
      data: body,
      options: Options(
        headers: headers ??
            {
              'Authorization': 'Bearer $token',
            },
      ),
    );
    return response;
  }
}

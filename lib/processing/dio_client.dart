import 'package:dio/dio.dart';
import 'package:graduation_project/processing/helper.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.225.155.23:8000/api/",

      /// http://khedma.test/api
      /// http://10.44.122.133:80/api
      /// http://10.44.122.133:8000/api/
      /// http://127.0.0.1:8000/api/ الجديد
      headers: {
        "Accept":
            "application/json", // شو صيغة البيانات يلي بدها ترجع من السيرفر (JSON)
        // "Content-Type":
        //     "application/json", // شو الصيغة يلي بدي ابعتلك البيانات فيها (JSON)
      },
    ),
  );
  DioClient() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await PrefHelper.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }
  Dio get dio => _dio;
}

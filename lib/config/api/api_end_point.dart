/*
 * @Author: Km Muzahid
 * @Date: 2026-01-07 12:29:06
 * @Email: km.muzahid@gmail.com
 */

// “Which course are you more excited to play?”
String _domain = 'http://34.206.78.7:5000';
// String _domain = 'http://10.10.26.185:5004';
// String _domain = 'https://humayon5004.binarybards.online';

class ApiEndPoint {
  ApiEndPoint._();
  static final ApiEndPoint instance = ApiEndPoint._();
  static final String domain = _domain;
  static final String baseUrl = '$_domain/api/v1';
}

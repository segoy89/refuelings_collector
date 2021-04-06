class Constants {
  static String baseUrl = 'https://refueling.herokuapp.com'; // remote
  // static String baseUrl = 'http://localhost:5000'; // iOS local
  // static String baseUrl = 'http://10.0.2.2:5000'; // Android local

  static String signInUrl = '$baseUrl/api/v1/sign_in';
  static String validateUrl = '$baseUrl/api/v1/validate_token';
  static String signOutUrl = '$baseUrl/api/v1/sign_out';
  static String refuelingsUrl = '$baseUrl/api/v1/refuelings';

  static Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Access-Control-Expose-Headers':
        'access-token, expiry, token-type, uid, client',
  };
}

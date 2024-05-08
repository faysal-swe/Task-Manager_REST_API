class Urls {
  Urls._();

  static const String _baseUrl = 'https://task.teamrabbil.com/api/v1';
  static const String registration = '$_baseUrl/registration';
  static const String login = '$_baseUrl/login';
  static const String createTask = '$_baseUrl/createTask';
  static const String taskStatusCount = '$_baseUrl/taskStatusCount';
  static String listTaskByStatus(String status) => '$_baseUrl/listTaskByStatus/$status';
  static String deleteTask(String id) => '$_baseUrl/deleteTask/$id';
  static String updateTaskStatus(String id, String taskStatus) => '$_baseUrl/updateTaskStatus/$id/$taskStatus';
  static String profileUpdate = '$_baseUrl/profileUpdate';
  static String emailVerification(String email)=> '$_baseUrl/RecoverVerifyEmail/$email';
  static String otpVerification(String email, String otp)=> '$_baseUrl/RecoverVerifyOTP/$email/$otp';
  static String resetPassword= '$_baseUrl/RecoverResetPass';
}
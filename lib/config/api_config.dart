class ApiConfig {
  // static const String baseUrl = 'http://10.0.2.2:8000'; // Change this to your actual API URL
  static const String baseUrl = 'https://ed0b-2001-ee0-555b-d7a0-694a-cd02-34ed-fd50.ngrok-free.app'; // Production URL

  // Auth APIs
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';
  static const String changePassword = '/auth/change-password';
  static const String adminChangePassword = '/auth/admin-change-password';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // User APIs
  static const String users = '/users/';
  static const String lecturers = '/users/lecturers';
  static const String userFullProfile = '/users/full-profile/';

  // Thesis APIs
  static const String theses = '/theses/';
  static const String thesesByBatch = '/theses/by-batch/';
  static const String majors = '/theses/getall/major';
  static const String departments = '/theses/getall/department/g';
  static const String batches = '/theses/getall/batches';

  // Group APIs
  static const String group = '/group';
  static const String myGroups = '/group/my-groups';

  // Invite APIs
  static const String sendInvite = '/invite/send';
  static const String acceptInvite = '/invite/accept/';
  static const String rejectInvite = '/invite/reject/';
  static const String revokeInvite = '/invite/revoke/';
  static const String myInvites = '/invite/my-invites';

  // Profile APIs
  static const String information = '/information/';
  static const String studentProfile = '/student-profile/';
  static const String lecturerProfile = '/lecturer-profile/';
    // Academy APIs
  static const String academyYears = '/academy/years';
  static const String semestersByYear = '/academy/years/';  // + {academy_year_id}/semesters
  static const String batchesBySemester = '/academy/semesters/'; // + {semester_id}/batches
    // Progress APIs
  static const String missions = '/progress/missions';
  static const String thesisTasksEndpoint = '/progress/theses/'; // + {thesis_id}/tasks
  static const String tasksEndpoint = '/progress/tasks'; // + /{task_id}
  static const String taskStatusEndpoint = '/progress/tasks/'; // + {task_id}/status
}

import 'mock_data_service.dart';

class UserState {
  static Map<String, dynamic>? currentUser;
  static String? authToken;

  static bool get isLoggedIn => currentUser != null;

  static void login(Map<String, dynamic> user, String token) {
    currentUser = user;
    authToken = token;
    updateUserStats();
  }

  static void logout() {
    currentUser = null;
    authToken = null;
  }

  static void updateUserStats() {
    if (currentUser != null) {
      final userId = currentUser!['id'];
      final userRecipes = MockDataService.getUserRecipes(userId).length;
      currentUser!['recipe_count'] = userRecipes;
      
      // Cập nhật lại trong users list
      final userIndex = MockDataService.users.indexWhere((u) => u['id'] == userId);
      if (userIndex != -1) {
        MockDataService.users[userIndex]['recipe_count'] = userRecipes;
      }
    }
  }

  static void updateProfile(Map<String, dynamic> updates) {
    if (currentUser != null) {
      currentUser = {...currentUser!, ...updates};
      
      // Cập nhật trong users list
      final userIndex = MockDataService.users.indexWhere(
        (u) => u['id'] == currentUser!['id']
      );
      if (userIndex != -1) {
        MockDataService.users[userIndex] = currentUser!;
      }
    }
  }

  static String getFirstName() {
    if (currentUser == null) return 'Bạn';
    return currentUser!['name'].toString().split(' ').last;
  }
}
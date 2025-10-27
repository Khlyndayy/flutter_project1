import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/user_state.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserState.currentUser!;
    UserState.updateUserStats();
    final joinDate = DateTime.parse(user['created_at']);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.getBackgroundGradient(),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: AppColors.getPrimaryGradient(),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [AppColors.getCardShadow()],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: AppColors.textWhite),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'Trang cá nhân',
                        style: TextStyle(
                          fontSize: 22,
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildProfileHeader(user, joinDate),
                      SizedBox(height: 20),
                      _buildStatsContainer(user),
                      SizedBox(height: 20),
                      _buildSettingsMenu(context),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> user, DateTime joinDate) {
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: AppColors.getPrimaryGradient(),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [AppColors.getCardShadow()],
      ),
      child: Column(
        children: [
          // Avatar với logo
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.textWhite,
              boxShadow: [
                BoxShadow(
                  color: AppColors.textWhite.withOpacity(0.3),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                AppAssets.logo,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback: hiển thị chữ cái đầu
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.accent, AppColors.primaryDark],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        user['name'][0].toUpperCase(),
                        style: TextStyle(
                          color: AppColors.textWhite,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 15),
          Text(
            user['name'],
            style: TextStyle(
              fontSize: 22,
              color: AppColors.textWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            '📧 ${user['email']}',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textWhite.withOpacity(0.9),
            ),
          ),
          SizedBox(height: 5),
          Text(
            '📅 Tham gia: ${joinDate.day}/${joinDate.month}/${joinDate.year}',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textWhite.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsContainer(Map<String, dynamic> user) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 2),
        boxShadow: [AppColors.getCardShadow()],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('${user['recipe_count']}', 'Công thức', Icons.restaurant_menu),
          _buildStatItem('${user['like_count']}', 'Lượt thích', Icons.favorite),
          _buildStatItem('${user['streak_count']}', 'Ngày streak', Icons.local_fire_department),
        ],
      ),
    );
  }

  Widget _buildStatItem(String number, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: AppColors.getPrimaryGradient(),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.textWhite, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          number,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsMenu(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 2),
        boxShadow: [AppColors.getCardShadow()],
      ),
      child: Column(
        children: [
          _buildSettingsItem(
            Icons.edit,
            'Chỉnh sửa thông tin',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tính năng đang phát triển'),
                  backgroundColor: AppColors.warning,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          _buildSettingsItem(
            Icons.notifications,
            'Thông báo',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tính năng đang phát triển'),
                  backgroundColor: AppColors.warning,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          _buildSettingsItem(
            Icons.dark_mode,
            'Chế độ tối',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tính năng đang phát triển'),
                  backgroundColor: AppColors.warning,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          _buildSettingsItem(
            Icons.logout,
            'Đăng xuất',
            () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: AppColors.cardBackground,
                  title: Row(
                    children: [
                      Icon(Icons.logout, color: AppColors.error),
                      SizedBox(width: 10),
                      Text(
                        'Đăng xuất',
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  content: Text(
                    'Bạn có chắc muốn đăng xuất không?',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Hủy',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        UserState.logout();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Đăng xuất',
                        style: TextStyle(color: AppColors.textWhite),
                      ),
                    ),
                  ],
                ),
              );
            },
            isDanger: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    IconData icon,
    String text,
    VoidCallback onTap, {
    bool isDanger = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isDanger 
              ? AppColors.error.withOpacity(0.1) 
              : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isDanger ? AppColors.error.withOpacity(0.3) : AppColors.cardBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isDanger
                    ? LinearGradient(colors: [AppColors.error, AppColors.error.withOpacity(0.7)])
                    : AppColors.getPrimaryGradient(),
              ),
              child: Center(
                child: Icon(icon, color: AppColors.textWhite, size: 20),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: isDanger ? AppColors.error : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDanger ? AppColors.error : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
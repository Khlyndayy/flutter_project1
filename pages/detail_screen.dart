import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const DetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
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
                        'Chi tiết công thức',
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
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildDetailHeader(),
                    SizedBox(height: 20),
                    _buildSection(
                      '🥕 Nguyên liệu',
                      (recipe['ingredients'] as List)
                          .map((ing) => '${ing['name']}: ${ing['quantity']} ${ing['unit']}')
                          .toList(),
                    ),
                    SizedBox(height: 15),
                    _buildStepsSection(
                      '👩‍🍳 Cách làm',
                      List<String>.from(recipe['steps']),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailHeader() {
    return Column(
      children: [
        // Emoji icon
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            gradient: AppColors.getPrimaryGradient(),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 25,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(recipe['emoji'], style: TextStyle(fontSize: 60)),
          ),
        ),
        SizedBox(height: 15),
        // Title
        Text(
          recipe['title'],
          style: TextStyle(
            fontSize: 24,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        // Description
        Text(
          recipe['description'] ?? '',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 15),
        // Time badges
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.tagBackground,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.tagBorder, width: 2),
              ),
              child: Text(
                '⏱️ Chuẩn bị: ${recipe['prep_time']}p',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ),
            SizedBox(width: 15),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.tagBackground,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.tagBorder, width: 2),
              ),
              child: Text(
                '🔥 Nấu: ${recipe['cook_time']}p',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        // Author
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.tagBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.tagBorder, width: 2),
          ),
          child: Text(
            '👤 Được tạo bởi ${recipe['author_name']}',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<String> items) {
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
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          ...items.map((item) => Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(15),
                  border: Border(
                    left: BorderSide(color: AppColors.primary, width: 4),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: AppColors.accentGreen, size: 18),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildStepsSection(String title, List<String> steps) {
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
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          ...steps.asMap().entries.map((entry) {
            int index = entry.key;
            String step = entry.value;
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(15),
                border: Border(
                  left: BorderSide(color: AppColors.primary, width: 4),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: AppColors.getPrimaryGradient(),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: AppColors.textWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      step,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
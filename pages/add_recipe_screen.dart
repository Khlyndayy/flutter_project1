import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/mock_data_service.dart';
import '../services/user_state.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController prepTimeController = TextEditingController();
  final TextEditingController cookTimeController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController stepsController = TextEditingController();
  
  String selectedEmoji = '🍽️';
  String selectedCategory = 'main';
  
  final List<String> emojiList = ['🍜', '🍱', '🍲', '🍛', '🍝', '🍕', '🍔', '🌮', '🧁', '🍰', '🎂', '🍪', '🍩', '🥗', '🍣'];
  final List<Map<String, String>> categories = [
    {'id': 'main', 'name': 'Món chính'},
    {'id': 'dessert', 'name': 'Tráng miệng'},
  ];

  void _saveRecipe() {
    if (titleController.text.isEmpty ||
        prepTimeController.text.isEmpty ||
        cookTimeController.text.isEmpty ||
        ingredientsController.text.isEmpty ||
        stepsController.text.isEmpty) {
      _showSnackBar('Vui lòng điền đầy đủ thông tin!', isError: true);
      return;
    }

    // Parse ingredients (mỗi dòng là 1 ingredient: "Tên: Số lượng Đơn vị")
    List<Map<String, String>> ingredients = [];
    final ingredientLines = ingredientsController.text.split('\n');
    for (var line in ingredientLines) {
      if (line.trim().isNotEmpty) {
        final parts = line.split(':');
        if (parts.length >= 2) {
          final quantityParts = parts[1].trim().split(' ');
          ingredients.add({
            'name': parts[0].trim(),
            'quantity': quantityParts.isNotEmpty ? quantityParts[0] : '',
            'unit': quantityParts.length > 1 ? quantityParts.sublist(1).join(' ') : '',
          });
        }
      }
    }

    // Parse steps (mỗi dòng là 1 bước)
    List<String> steps = stepsController.text
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .map((line) => line.trim())
        .toList();

    final newRecipe = {
      'emoji': selectedEmoji,
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'prep_time': int.parse(prepTimeController.text),
      'cook_time': int.parse(cookTimeController.text),
      'created_by': UserState.currentUser!['id'],
      'author_name': UserState.currentUser!['name'],
      'ingredients': ingredients,
      'steps': steps,
      'category': selectedCategory,
    };

    MockDataService.addRecipe(newRecipe);
    UserState.updateUserStats();
    
    _showSnackBar('Đã lưu công thức thành công!');
    
    Future.delayed(Duration(milliseconds: 1000), () {
      Navigator.pop(context, true);
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

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
                        'Thêm công thức mới',
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
                      // Emoji picker
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.cardBorder, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '🎨 Chọn icon món ăn',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 10),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: emojiList.map((emoji) {
                                return GestureDetector(
                                  onTap: () => setState(() => selectedEmoji = emoji),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      gradient: selectedEmoji == emoji 
                                          ? AppColors.getPrimaryGradient() 
                                          : null,
                                      color: selectedEmoji == emoji 
                                          ? null 
                                          : AppColors.tagBackground,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: selectedEmoji == emoji 
                                            ? AppColors.primary 
                                            : AppColors.tagBorder,
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(emoji, style: TextStyle(fontSize: 24)),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildFormField(
                        '🍽️ Tên món ăn',
                        'Ví dụ: Phở Bò Truyền Thống',
                        titleController,
                      ),
                      _buildFormField(
                        '📝 Mô tả',
                        'Mô tả về món ăn của bạn...',
                        descriptionController,
                        maxLines: 3,
                      ),
                      // Category picker
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.cardBorder, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '📂 Danh mục',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: categories.map((category) {
                                final isSelected = selectedCategory == category['id'];
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => selectedCategory = category['id']!),
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                        gradient: isSelected ? AppColors.getPrimaryGradient() : null,
                                        color: isSelected ? null : AppColors.tagBackground,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected ? AppColors.primary : AppColors.tagBorder,
                                          width: 2,
                                        ),
                                      ),
                                      child: Text(
                                        category['name']!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildFormField(
                              '⏱️ Chuẩn bị (phút)',
                              '30',
                              prepTimeController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: _buildFormField(
                              '🔥 Nấu (phút)',
                              '180',
                              cookTimeController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      _buildFormField(
                        '🥕 Nguyên liệu',
                        'Mỗi dòng 1 nguyên liệu\nVí dụ: Xương bò: 1 kg',
                        ingredientsController,
                        maxLines: 5,
                      ),
                      _buildFormField(
                        '👩‍🍳 Các bước làm',
                        'Mỗi dòng 1 bước\nBước 1: Chuẩn bị nguyên liệu...\nBước 2: Ninh xương...',
                        stepsController,
                        maxLines: 6,
                      ),
                      SizedBox(height: 20),
                      // Save button
                      ElevatedButton(
                        onPressed: _saveRecipe,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textWhite,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: Size(double.infinity, 50),
                          elevation: 5,
                          shadowColor: AppColors.primary.withOpacity(0.5),
                        ),
                        child: Text(
                          'Lưu công thức 🌟',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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

  Widget _buildFormField(
    String label,
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: AppColors.cardBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.cardBorder, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.cardBorder, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
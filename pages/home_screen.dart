import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/mock_data_service.dart';
import '../services/user_state.dart';
import 'profile_screen.dart';
import 'detail_screen.dart';
import 'add_recipe_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;
  int bottomTab = 0;
  List<Map<String, dynamic>> recipes = [];
  bool isLoading = false;

  final List<Map<String, String>> categories = [
    {'id': 'all', 'name': 'Tất cả'},
    {'id': 'main', 'name': 'Món chính'},
    {'id': 'dessert', 'name': 'Tráng miệng'},
  ];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  void _loadRecipes() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        if (bottomTab == 0) {
          // Tab "Trang chủ" - hiển thị theo category
          final categoryId = categories[selectedTab]['id']!;
          recipes = MockDataService.getRecipesByCategory(categoryId);
        } else if (bottomTab == 1) {
          // Tab "Của tôi"
          final userId = UserState.currentUser?['id'];
          if (userId != null) {
            recipes = MockDataService.getUserRecipes(userId);
          } else {
            recipes = [];
          }
        }
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = UserState.currentUser;
    final firstName = UserState.getFirstName();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.getBackgroundGradient(),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(user, firstName, context),
              if (bottomTab == 0) _buildNavTabs(),
              SizedBox(height: 20),
              Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : recipes.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            color: AppColors.primary,
                            onRefresh: () async {
                              _loadRecipes();
                            },
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              itemCount: recipes.length,
                              itemBuilder: (context, index) {
                                return _buildRecipeCard(context, recipes[index]);
                              },
                            ),
                          ),
              ),
              _buildBottomTabs(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (UserState.isLoggedIn) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddRecipeScreen()),
            ).then((_) {
              UserState.updateUserStats();
              _loadRecipes();
            });
          } else {
            _showLoginRequiredDialog(context);
          }
        },
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add, size: 30, color: AppColors.textWhite),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo thay vì emoji
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.getPrimaryGradient(),
              boxShadow: [AppColors.getCardShadow()],
            ),
            child: ClipOval(
              child: Image.network(
                AppAssets.logo,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.restaurant_menu,
                    size: 60,
                    color: AppColors.textWhite,
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Chưa có công thức nào',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            bottomTab == 1
                ? 'Hãy thêm công thức đầu tiên của bạn!'
                : 'Chưa có công thức trong danh mục này',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: AppColors.cardBackground,
          title: Row(
            children: [
              Icon(Icons.lock_outline, color: AppColors.primary, size: 28),
              SizedBox(width: 10),
              Text(
                'Yêu cầu đăng nhập',
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          content: Text(
            'Bạn cần đăng nhập để xem chi tiết công thức và thêm công thức mới!',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
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
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                ).then((_) {
                  if (UserState.isLoggedIn) {
                    setState(() => _loadRecipes());
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                'Đăng nhập',
                style: TextStyle(color: AppColors.textWhite),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(Map<String, dynamic>? user, String firstName, BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: AppColors.getPrimaryGradient(),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [AppColors.getCardShadow()],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (user != null)
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.textWhite.withOpacity(0.3),
                    border: Border.all(color: AppColors.textWhite, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      user['name'][0].toUpperCase(),
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              else
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  child: Center(
                    child: Icon(Icons.person, color: AppColors.textWhite),
                  ),
                ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user != null ? 'Chào $firstName!' : 'Chào bạn!',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user != null ? 'Đầu bếp tại nhà' : 'Khách',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textWhite.withOpacity(0.9),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              if (user != null)
                IconButton(
                  icon: Icon(Icons.person, color: AppColors.textWhite),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    ).then((_) => setState(() => _loadRecipes()));
                  },
                )
              else
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        ).then((_) {
                          if (UserState.isLoggedIn) {
                            setState(() => _loadRecipes());
                          }
                        });
                      },
                      child: Text(
                        'Đăng nhập',
                        style: TextStyle(
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.textWhite,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterScreen()),
                          ).then((_) {
                            if (UserState.isLoggedIn) {
                              setState(() => _loadRecipes());
                            }
                          });
                        },
                        child: Text(
                          'Đăng ký',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavTabs() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: List.generate(
          categories.length,
          (index) => _buildNavTab(categories[index]['name']!, index),
        ),
      ),
    );
  }

  Widget _buildNavTab(String text, int index) {
    bool isActive = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
            _loadRecipes();
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isActive ? AppColors.getPrimaryGradient() : null,
            borderRadius: BorderRadius.circular(15),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? AppColors.textWhite : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, Map<String, dynamic> recipe) {
    return GestureDetector(
      onTap: () {
        if (UserState.isLoggedIn) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(recipe: recipe),
            ),
          );
        } else {
          _showLoginRequiredDialog(context);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.cardBorder, width: 2),
          boxShadow: [AppColors.getCardShadow()],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: AppColors.getPrimaryGradient(),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 15,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      recipe['emoji'] ?? '🍽️',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.tagBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.tagBorder),
                  ),
                  child: Text(
                    '👤 ${recipe['author_name'] ?? 'Unknown'}',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              recipe['title'] ?? 'Công thức',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimeBadge('⏱️ ${recipe['prep_time'] ?? 0}p'),
                SizedBox(width: 12),
                _buildTimeBadge('🔥 ${recipe['cook_time'] ?? 0}p'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBadge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.tagBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.tagBorder),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildBottomTabs() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Row(
          children: [
            _buildBottomTab(Icons.home, 'Trang chủ', 0),
            _buildBottomTab(Icons.book, 'Của tôi', 1),
            _buildBottomTab(Icons.person, 'Cá nhân', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomTab(IconData icon, String text, int index) {
    bool isActive = bottomTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (index == 2) {
            if (UserState.isLoggedIn) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              ).then((_) => setState(() => _loadRecipes()));
            } else {
              _showLoginRequiredDialog(context);
            }
          } else if (index == 1) {
            if (UserState.isLoggedIn) {
              setState(() {
                bottomTab = index;
                selectedTab = 0;
                _loadRecipes();
              });
            } else {
              _showLoginRequiredDialog(context);
            }
          } else {
            setState(() {
              bottomTab = index;
              selectedTab = 0;
              _loadRecipes();
            });
          }
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: isActive ? AppColors.getPrimaryGradient() : null,
            borderRadius: BorderRadius.circular(15),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: isActive ? AppColors.textWhite : AppColors.textSecondary,
              ),
              SizedBox(height: 2),
              Text(
                text,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isActive ? AppColors.textWhite : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
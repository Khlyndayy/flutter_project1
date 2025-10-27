class MockDataService {
  static List<Map<String, dynamic>> users = [
    {
      'id': 1,
      'email': 'nguyenvana@example.com',
      'password': '123456',
      'name': 'Nguyễn Văn An',
      'avatar_url': null,
      'created_at': '2024-01-15T10:30:00Z',
      'recipe_count': 2,
      'like_count': 48,
      'streak_count': 7,
    }
  ];

  static List<Map<String, dynamic>> recipes = [
    {
      'id': 1,
      'emoji': '🍜',
      'title': 'Phở Bò Truyền Thống',
      'description': 'Món phở truyền thống với nước dùng được ninh từ xương bò',
      'prep_time': 30,
      'cook_time': 180,
      'created_by': 1,
      'author_name': 'Nguyễn Văn An',
      'created_at': '2024-01-20T14:30:00Z',
      'ingredients': [
        {'name': 'Xương bò', 'quantity': '1', 'unit': 'kg'},
        {'name': 'Thịt bò', 'quantity': '300', 'unit': 'gram'},
        {'name': 'Bánh phở', 'quantity': '500', 'unit': 'gram'},
        {'name': 'Hành tây', 'quantity': '2', 'unit': 'củ'},
        {'name': 'Rau thơm', 'quantity': '1', 'unit': 'bó'},
      ],
      'steps': [
        'Ninh xương bò với hành tây, gừng trong 3 tiếng để có nước dùng trong',
        'Luộc bánh phở trong nước sôi 2-3 phút, vớt ra để ráo',
        'Thái thịt bò mỏng, chuẩn bị rau thơm',
        'Trình bày bánh phở, thịt bò, chan nước dùng nóng và thưởng thức',
      ],
      'category': 'main',
    },
    {
      'id': 2,
      'emoji': '🍱',
      'title': 'Cơm Tấm Sườn Nướng',
      'description': 'Cơm tấm sườn nướng thơm ngon',
      'prep_time': 15,
      'cook_time': 45,
      'created_by': 1,
      'author_name': 'Nguyễn Văn An',
      'created_at': '2024-01-18T09:15:00Z',
      'ingredients': [
        {'name': 'Cơm tấm', 'quantity': '500', 'unit': 'gram'},
        {'name': 'Sườn non', 'quantity': '300', 'unit': 'gram'},
        {'name': 'Nước mắm', 'quantity': '3', 'unit': 'thìa'},
      ],
      'steps': [
        'Ướp sườn với nước mắm, tỏi, đường trong 30 phút',
        'Nướng sườn trên than hoa đến khi vàng đều',
        'Trình bày cơm tấm với sườn nướng và đồ chua',
      ],
      'category': 'main',
    },
    {
      'id': 3,
      'emoji': '🧁',
      'title': 'Bánh Cupcake Hoa',
      'description': 'Bánh cupcake dễ thương cho tiệc trà',
      'prep_time': 20,
      'cook_time': 25,
      'created_by': 2,
      'author_name': 'Trần Thị Mai',
      'created_at': '2024-01-22T16:45:00Z',
      'ingredients': [
        {'name': 'Bột mì', 'quantity': '200', 'unit': 'gram'},
        {'name': 'Đường', 'quantity': '150', 'unit': 'gram'},
        {'name': 'Trứng gà', 'quantity': '3', 'unit': 'quả'},
        {'name': 'Bơ', 'quantity': '100', 'unit': 'gram'},
      ],
      'steps': [
        'Đánh bông bơ với đường',
        'Thêm trứng từng quả một và đánh đều',
        'Cho bột mì vào trộn nhẹ',
        'Nướng ở 180 độ trong 25 phút',
      ],
      'category': 'dessert',
    },
  ];

  // ===== USER MANAGEMENT =====
  static Map<String, dynamic>? register(String email, String password, String name) {
    if (users.any((user) => user['email'] == email)) {
      return null;
    }

    final newUser = {
      'id': users.length + 1,
      'email': email,
      'password': password,
      'name': name,
      'avatar_url': null,
      'created_at': DateTime.now().toIso8601String(),
      'recipe_count': 0,
      'like_count': 0,
      'streak_count': 0,
    };

    users.add(newUser);
    return newUser;
  }

  static Map<String, dynamic>? login(String email, String password) {
    try {
      return users.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
      );
    } catch (e) {
      return null;
    }
  }

  // ===== RECIPE MANAGEMENT =====
  static List<Map<String, dynamic>> getAllRecipes() {
    return recipes;
  }

  static List<Map<String, dynamic>> getUserRecipes(int userId) {
    return recipes.where((recipe) => recipe['created_by'] == userId).toList();
  }

  static List<Map<String, dynamic>> getRecipesByCategory(String category) {
    if (category == 'all') return recipes;
    return recipes.where((recipe) => recipe['category'] == category).toList();
  }

  static void addRecipe(Map<String, dynamic> recipe) {
    final newRecipe = {
      'id': recipes.length + 1,
      'created_at': DateTime.now().toIso8601String(),
      ...recipe,
    };
    recipes.add(newRecipe);
  }

  static void updateRecipe(int id, Map<String, dynamic> updates) {
    final index = recipes.indexWhere((recipe) => recipe['id'] == id);
    if (index != -1) {
      recipes[index] = {...recipes[index], ...updates};
    }
  }

  static void deleteRecipe(int id) {
    recipes.removeWhere((recipe) => recipe['id'] == id);
  }

  static Map<String, dynamic>? getRecipeById(int id) {
    try {
      return recipes.firstWhere((recipe) => recipe['id'] == id);
    } catch (e) {
      return null;
    }
  }
}
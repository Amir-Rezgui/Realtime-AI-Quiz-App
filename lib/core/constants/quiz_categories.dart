class QuizCategory {
  final String id;
  final String name;
  final String imagePath;

  const QuizCategory({
    required this.id,
    required this.name,
    required this.imagePath,
  });
}

class QuizCategories {
  QuizCategories._();

  static const List<QuizCategory> all = [
    QuizCategory(
      id: 'science',
      name: 'Science',
      imagePath: 'assets/images/categories/science.png',
    ),
    QuizCategory(
      id: 'technology',
      name: 'Technology',
      imagePath: 'assets/images/categories/technology.png',
    ),
    QuizCategory(
      id: 'culture',
      name: 'Culture',
      imagePath: 'assets/images/categories/culture.png',
    ),
    QuizCategory(
      id: 'history',
      name: 'History',
      imagePath: 'assets/images/categories/history.png',
    ),
    QuizCategory(
      id: 'sports',
      name: 'Sports',
      imagePath: 'assets/images/categories/sports.png',
    ),
    QuizCategory(
      id: 'geography',
      name: 'Geography',
      imagePath: 'assets/images/categories/geography.png',
    ),
    QuizCategory(
      id: 'entertainment',
      name: 'Entertainment',
      imagePath: 'assets/images/categories/entertainment.png',
    ),
    QuizCategory(
      id: 'general',
      name: 'General Knowledge',
      imagePath: 'assets/images/categories/general.png',
    ),
  ];

  static QuizCategory? getById(String? id) {
    if (id == null) return null;
    try {
      return all.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  static QuizCategory get defaultCategory => all.last; // General Knowledge
}

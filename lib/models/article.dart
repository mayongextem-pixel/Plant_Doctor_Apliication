/// Model for plant care articles
class Article {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String? content;
  final String category; // care, disease, watering, fertilizing, etc.
  final DateTime publishedDate;
  final String? author;
  final List<String> tags;
  final bool isFavorite;

  Article({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.content,
    required this.category,
    required this.publishedDate,
    this.author,
    this.tags = const [],
    this.isFavorite = false,
  });

  // Factory constructor to create from JSON
  factory Article.fromJson(Map<String, dynamic> json) {
    final tagsData = json['tags'] as List<dynamic>? ?? [];
    final tags = tagsData.map((e) => e.toString()).toList();

    return Article(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      content: json['content'] as String?,
      category: json['category'] as String? ?? 'general',
      publishedDate: json['publishedDate'] != null
          ? DateTime.parse(json['publishedDate'] as String)
          : DateTime.now(),
      author: json['author'] as String?,
      tags: tags,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'content': content,
      'category': category,
      'publishedDate': publishedDate.toIso8601String(),
      'author': author,
      'tags': tags,
      'isFavorite': isFavorite,
    };
  }

  // Factory constructor to create from simple map (like sample articles)
  factory Article.fromMap(Map<String, String> map, String id) {
    return Article(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['image'],
      content: map['content'],
      category: map['category'] ?? 'general',
      publishedDate: DateTime.now(),
      author: 'Plant Doctor Team',
      tags: [],
      isFavorite: false,
    );
  }

  // Get category emoji
  String get categoryEmoji {
    switch (category.toLowerCase()) {
      case 'care':
      case 'perawatan':
        return '🌱';
      case 'disease':
      case 'penyakit':
        return '🦠';
      case 'watering':
      case 'penyiraman':
        return '💧';
      case 'fertilizing':
      case 'pemupukan':
        return '🌿';
      case 'pest':
      case 'hama':
        return '🐛';
      case 'indoor':
        return '🏠';
      case 'outdoor':
        return '☀️';
      default:
        return '📰';
    }
  }

  // Get category name in Indonesian
  String get categoryName {
    switch (category.toLowerCase()) {
      case 'care':
        return 'Perawatan';
      case 'disease':
        return 'Penyakit';
      case 'watering':
        return 'Penyiraman';
      case 'fertilizing':
        return 'Pemupukan';
      case 'pest':
        return 'Hama';
      case 'indoor':
        return 'Tanaman Indoor';
      case 'outdoor':
        return 'Tanaman Outdoor';
      default:
        return 'Umum';
    }
  }

  // Get formatted date
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(publishedDate);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} menit yang lalu';
      }
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks minggu yang lalu';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months bulan yang lalu';
    }
  }

  // Create a copy with modified fields
  Article copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? content,
    String? category,
    DateTime? publishedDate,
    String? author,
    List<String>? tags,
    bool? isFavorite,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      content: content ?? this.content,
      category: category ?? this.category,
      publishedDate: publishedDate ?? this.publishedDate,
      author: author ?? this.author,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  /// Static mock data — 5 articles covering different categories
  static List<Article> get mockData => [
    Article(
      id: '1',
      title: 'Tips Merawat Tanaman Indoor',
      description: 'Panduan lengkap merawat tanaman hias di dalam ruangan agar tumbuh subur dan sehat.',
      category: 'care',
      publishedDate: DateTime.now().subtract(const Duration(days: 1)),
      author: 'Plant Doctor Team',
      tags: ['indoor', 'perawatan'],
    ),
    Article(
      id: '2',
      title: 'Mengenal Penyakit Bercak Daun',
      description: 'Bercak daun adalah salah satu penyakit umum pada tanaman. Pelajari cara mendeteksi dan mengatasinya.',
      category: 'disease',
      publishedDate: DateTime.now().subtract(const Duration(days: 3)),
      author: 'Plant Doctor Team',
      tags: ['penyakit', 'bercak daun'],
    ),
    Article(
      id: '3',
      title: 'Panduan Penyiraman yang Tepat',
      description: 'Frekuensi dan cara penyiraman yang benar sangat mempengaruhi kesehatan tanaman Anda.',
      category: 'watering',
      publishedDate: DateTime.now().subtract(const Duration(days: 5)),
      author: 'Plant Doctor Team',
      tags: ['penyiraman', 'perawatan'],
    ),
    Article(
      id: '4',
      title: 'Pemupukan Organik untuk Tanaman Hias',
      description: 'Gunakan pupuk organik untuk menjaga kesuburan tanah dan pertumbuhan tanaman secara alami.',
      category: 'fertilizing',
      publishedDate: DateTime.now().subtract(const Duration(days: 8)),
      author: 'Plant Doctor Team',
      tags: ['pemupukan', 'organik'],
    ),
    Article(
      id: '5',
      title: 'Cara Mengatasi Hama Tanaman',
      description: 'Hama seperti kutu daun dan tungau bisa merusak tanaman. Temukan solusi alami untuk mengatasinya.',
      category: 'pest',
      publishedDate: DateTime.now().subtract(const Duration(days: 12)),
      author: 'Plant Doctor Team',
      tags: ['hama', 'perawatan'],
    ),
  ];

  @override
  String toString() {
    return 'Article(id: $id, title: $title, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Article && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

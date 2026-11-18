/// Typed product model preserving all exact fields from the A-Xion Digital
/// product JSON schema, while keeping missing/unconfirmed fields optional.
class Product {
  const Product({
    required this.id,
    required this.category,
    this.storeCategory,
    required this.nameAr,
    required this.nameTr,
    required this.descriptionAr,
    required this.descriptionTr,
    required this.modelSearchKeyword,
    required this.material,
    required this.estimatedPrintTime,
    required this.weightGrams,
    this.estimatedPriceTry,
    this.estimatedPriceUsd,
    this.price,
    this.currency,
    this.imagePaths = const [],
    this.colorVariants = const [],
    this.isAvailable,
  });

  final String id;
  final String category;

  /// Mapped storefront category slug (figures-anime, geometric-office,
  /// home-decor-kitchen, gifts, keychains), or null if unassigned.
  final String? storeCategory;

  final String nameAr;
  final String nameTr;
  final String descriptionAr;
  final String descriptionTr;

  /// Search keyword only — never treated as an image URL.
  final String modelSearchKeyword;
  final String material;
  final String estimatedPrintTime;
  final num weightGrams;

  /// Source estimate fields — NOT confirmed selling prices.
  final double? estimatedPriceTry;
  final double? estimatedPriceUsd;

  // Optional confirmed selling fields (null until confirmed)
  final double? price;
  final String? currency;
  final List<String> imagePaths;
  final List<String> colorVariants;
  final bool? isAvailable;

  String localizedName({required bool isArabic}) => isArabic ? nameAr : nameTr;

  String localizedDescription({required bool isArabic}) =>
      isArabic ? descriptionAr : descriptionTr;

  bool matchesQuery(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return id.toLowerCase().contains(q) ||
        nameAr.toLowerCase().contains(q) ||
        nameTr.toLowerCase().contains(q) ||
        descriptionAr.toLowerCase().contains(q) ||
        descriptionTr.toLowerCase().contains(q) ||
        modelSearchKeyword.toLowerCase().contains(q) ||
        material.toLowerCase().contains(q);
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      storeCategory: json['store_category']?.toString(),
      nameAr: (json['name_ar'] ?? '').toString(),
      nameTr: (json['name_tr'] ?? '').toString(),
      descriptionAr: (json['description_ar'] ?? '').toString(),
      descriptionTr: (json['description_tr'] ?? '').toString(),
      modelSearchKeyword: (json['model_search_keyword'] ?? '').toString(),
      material: (json['material'] ?? '').toString(),
      estimatedPrintTime: (json['estimated_print_time'] ?? '').toString(),
      weightGrams: (json['weight_grams'] is num)
          ? json['weight_grams'] as num
          : num.tryParse((json['weight_grams'] ?? '0').toString()) ?? 0,
      estimatedPriceTry: (json['estimated_price_try'] is num)
          ? (json['estimated_price_try'] as num).toDouble()
          : double.tryParse((json['estimated_price_try'] ?? '').toString()),
      estimatedPriceUsd: (json['estimated_price_usd'] is num)
          ? (json['estimated_price_usd'] as num).toDouble()
          : double.tryParse((json['estimated_price_usd'] ?? '').toString()),
      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse((json['price'] ?? '').toString()),
      currency: json['currency']?.toString(),
      imagePaths: (json['image_paths'] is List)
          ? (json['image_paths'] as List).map((e) => e.toString()).toList()
          : const [],
      colorVariants: (json['color_variants'] is List)
          ? (json['color_variants'] as List).map((e) => e.toString()).toList()
          : const [],
      isAvailable:
          json['is_available'] is bool ? json['is_available'] as bool : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        if (storeCategory != null) 'store_category': storeCategory,
        'name_ar': nameAr,
        'name_tr': nameTr,
        'description_ar': descriptionAr,
        'description_tr': descriptionTr,
        'model_search_keyword': modelSearchKeyword,
        'material': material,
        'estimated_print_time': estimatedPrintTime,
        'weight_grams': weightGrams,
        if (estimatedPriceTry != null)
          'estimated_price_try': estimatedPriceTry,
        if (estimatedPriceUsd != null)
          'estimated_price_usd': estimatedPriceUsd,
        if (price != null) 'price': price,
        if (currency != null) 'currency': currency,
        if (imagePaths.isNotEmpty) 'image_paths': imagePaths,
        if (colorVariants.isNotEmpty) 'color_variants': colorVariants,
        if (isAvailable != null) 'is_available': isAvailable,
      };
}

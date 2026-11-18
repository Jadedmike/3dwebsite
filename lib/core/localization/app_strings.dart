/// Storefront category slugs matching the 5 approved Stitch categories.
enum StoreCategory {
  figuresAnime('figures-anime'),
  geometricOffice('geometric-office'),
  homeDecorKitchen('home-decor-kitchen'),
  gifts('gifts'),
  keychains('keychains');

  const StoreCategory(this.slug);
  final String slug;

  static StoreCategory? fromSlug(String? slug) {
    if (slug == null) return null;
    for (final cat in values) {
      if (cat.slug == slug) return cat;
    }
    return null;
  }
}

/// Bilingual UI strings (Arabic RTL & Turkish LTR) aligned with the approved
/// Stitch screens. No fictional product copy is included here.
class AppStrings {
  const AppStrings({required this.isArabic});

  final bool isArabic;

  String get announcementText => isArabic
      ? '✨ شحن سريع ومجاني للطلبات المميزة عبر واتساب'
      : '✨ Öne çıkan siparişlerde hızlı teslimat & WhatsApp ile anında sipariş';

  String get searchPlaceholder =>
      isArabic ? 'ابحث في الكتالوج...' : 'Katalogda ara...';

  String get orderWaHeader => isArabic ? 'واتساب' : 'WhatsApp';

  String get whatsappDirectPrefix =>
      isArabic ? 'واتساب مباشر:' : 'WhatsApp Direkt:';

  String get homeTitle => isArabic ? 'الرئيسية' : 'Ana Sayfa';
  String get allProductsTitle => isArabic ? 'جميع المنتجات' : 'Tüm Ürünler';
  String get favoritesTitle => isArabic ? 'المفضلة' : 'Favoriler';
  String get cartTitle => isArabic ? 'سلة التسوق' : 'Sepetim';
  String get productDetailsTitle =>
      isArabic ? 'تفاصيل المنتج' : 'Ürün Detayları';

  // Hero & Homepage Editorial Strings (from Stitch c5f4ae8c)
  String get heroBadge => 'Bespoke 3D Additive Atelier';
  String get heroTitle => isArabic
      ? 'دقة التصنيع تلتقي بالفن الراقي'
      : 'Üretim Hassasiyeti Seçkin Sanatla Buluşuyor';
  String get heroSubtitle => isArabic
      ? 'مجسمات وقطع فنية ثلاثية الأبعاد بلمسات استثنائية تُطلب مباشرة عبر واتساب دون تعقيد.'
      : 'WhatsApp üzerinden zahmetsizce sipariş verebileceğiniz, olağanüstü dokunuşlara sahip 3D baskı figür ve tasarım objeleri.';
  String get browseCollections =>
      isArabic ? 'تصفح المجموعات' : 'Koleksiyonları Keşfet';
  String get viewAllProducts =>
      isArabic ? 'عرض جميع المنتجات' : 'Tüm Ürünleri Gör';

  String get collectionsTitle => isArabic ? 'المجموعات' : 'Koleksiyonlar';
  String get collectionsBadge =>
      isArabic ? '5 فئات مميزة' : '5 Özel Kategori';
  String get bestSellersTitle =>
      isArabic ? 'الأكثر مبيعاً' : 'Çok Satanlar';
  String get bestSellersSubtitle => isArabic
      ? 'مختارات حصرية من أرقى أعمال الأتيليه المطبوعة ثلاثياً'
      : 'Atölyemizin en seçkin 3D baskı tasarımlarından özel seçki';

  // 3-Step WhatsApp Section (from Stitch c5f4ae8c)
  String get waStepsBadge =>
      isArabic ? 'تجربة تسوق سهلة' : 'Kolay Sipariş Deneyimi';
  String get waStepsTitle => isArabic
      ? 'كيف تطلب عبر واتساب في 3 خطوات؟'
      : 'WhatsApp ile 3 Adımda Nasıl Sipariş Verilir?';
  String get waStepsSubtitle => isArabic
      ? 'لا حاجة لإنشاء حسابات أو ملء استمارات طويلة. محادثة مباشرة مع الأتيليه.'
      : 'Hesap oluşturmanıza veya uzun formlar doldurmanıza gerek yok. Atölye ile doğrudan iletişim.';

  String get waStep1Title => isArabic
      ? 'اختر التصميم أو أرسل ملفك'
      : 'Tasarımı Seçin veya Dosyanızı Gönderin';
  String get waStep1Desc => isArabic
      ? 'حدد القطعة التي أعجبتك من الكتالوج أو أضفها إلى السلة.'
      : 'Katalogdan beğendiğiniz parçayı seçin veya sepetinize ekleyin.';

  String get waStep2Title => isArabic
      ? 'خصّص اللون والخامة'
      : 'Renk ve Malzemeyi Özelleştirin';
  String get waStep2Desc => isArabic
      ? 'تواصل معنا عبر واتساب لتأكيد المقاس واللون والخامة المناسبة.'
      : 'Boyut, renk ve uygun malzemeyi onaylamak için WhatsApp üzerinden bize ulaşın.';

  String get waStep3Title => isArabic
      ? 'التصنيع والشحن السريع'
      : 'Üretim ve Hızlı Teslimat';
  String get waStep3Desc => isArabic
      ? 'نبدأ الطباعة بدقة عالية ونشحن طلبك مغلفاً بأمان.'
      : 'Yüksek hassasiyetle baskıya başlıyor ve siparişinizi güvenle kargoluyoruz.';

  // Catalog / Filter / Custom STL Banner (from Stitch 78ddc0a4)
  String get filterAll => isArabic ? 'الكل' : 'Tümü';
  String get sortLabel => isArabic ? 'الترتيب' : 'Sıralama';
  String get customStlTitle => isArabic
      ? 'هل تبحث عن قياس خاص أو ملف STL مخصص للطباعة؟'
      : 'Özel bir ölçü veya size özel STL baskısı mı arıyorsunuz?';
  String get customStlButton =>
      isArabic ? 'اطلب تسعيرة عبر واتساب' : 'WhatsApp ile Teklif Al';

  // Product Details Labels (from Stitch 57d1f0f5)
  String get specMaterial => isArabic ? 'الخامة' : 'Malzeme';
  String get specPrintTime => isArabic ? 'وقت الطباعة المقدر' : 'Tahmini Baskı Süresi';
  String get specWeight => isArabic ? 'الوزن (غرام)' : 'Ağırlık (gram)';
  String get addToCart => isArabic ? 'أضف إلى السلة' : 'Sepete Ekle';
  String get addToFavorites => isArabic ? 'أضف للمفضلة' : 'Favorilere Ekle';
  String get orderViaWhatsApp =>
      isArabic ? 'اطلب عبر واتساب' : 'WhatsApp ile Sipariş Ver';

  // Cart & Favorites (from Stitch 805a8d1d & bc6085a8)
  String get orderSummary => isArabic ? 'ملخص الطلب' : 'Sipariş Özeti';
  String get itemsCountLabel => isArabic ? 'عدد القطع' : 'Ürün Adedi';
  String get totalLabel => isArabic ? 'الإجمالي' : 'Toplam';
  String get noAccountNeededNote => isArabic
      ? 'لا يتطلب تسجيل دخول — يتم تأكيد الطلب مباشرة عبر واتساب.'
      : 'Üyelik gerekmez — siparişiniz doğrudan WhatsApp üzerinden onaylanır.';

  String get footerNavTitle =>
      isArabic ? 'المجموعات الرئيسية' : 'Ana Koleksiyonlar';

  String get footerBio => isArabic
      ? 'أتيليه متخصص في الطباعة ثلاثية الأبعاد الفاخرة، يجمع بين الفن المعاصر والهندسة الدقيقة لصنع مجسمات، وتحف منزلية ومكتبية استثنائية.'
      : 'Çağdaş sanatı hassas mühendislikle buluşturan, özel figürler ve sıra dışı ev/ofis tasarımları üreten lüks 3D baskı atölyesi.';

  String get footerRegionTitle =>
      isArabic ? 'المنطقة واللغة' : 'Bölge ve Dil';

  String get footerRegionDesc => isArabic
      ? 'خدمة الطلب والتوصيل السريع متاحة في تركيا والإمارات ودول مجلس التعاون الخليجي.'
      : 'Türkiye, BAE ve Körfez ülkelerine hızlı sipariş ve teslimat hizmeti sunulmaktadır.';

  String get footerPrivacy => isArabic ? 'سياسة الخصوصية' : 'Gizlilik Politikası';
  String get footerTerms => isArabic ? 'الشروط والأحكام' : 'Kullanım Koşulları';

  String get copyright =>
      '© 2026 A-Xion Digital. All rights reserved. Bespoke 3D Fabrication Atelier.';

  String get dataPendingNotice => isArabic
      ? 'بانتظار ربط ملف بيانات المنتجات (JSON) والصور المعتمدة.'
      : 'Onaylı ürün JSON veri dosyası ve görsellerin yüklenmesi bekleniyor.';

  String get cartEmptyNotice =>
      isArabic ? 'سلة التسوق فارغة حالياً.' : 'Sepetiniz şu anda boş.';

  String get favoritesEmptyNotice =>
      isArabic ? 'قائمة المفضلة فارغة حالياً.' : 'Favori listeniz şu anda boş.';

  String get checkoutWhatsApp =>
      isArabic ? 'إتمام الطلب عبر واتساب' : 'WhatsApp ile Siparişi Tamamla';

  String categoryLabel(StoreCategory category) {
    return switch (category) {
      StoreCategory.figuresAnime =>
        isArabic ? 'مجسمات وأنمي' : 'Figürler & Anime',
      StoreCategory.geometricOffice =>
        isArabic ? 'تصاميم هندسية ومكتبية' : 'Geometrik & Ofis',
      StoreCategory.homeDecorKitchen =>
        isArabic ? 'ديكور المنزل والمطبخ' : 'Ev Dekoru & Mutfak',
      StoreCategory.gifts => isArabic ? 'هدايا' : 'Hediyeler',
      StoreCategory.keychains => isArabic ? 'ميداليات مفاتيح' : 'Anahtarlıklar',
    };
  }

  String categorySubtitle(StoreCategory category) {
    return switch (category) {
      StoreCategory.figuresAnime =>
        isArabic ? 'مجسمات فنية وميكا' : 'Koleksiyon figürleri ve mecha',
      StoreCategory.geometricOffice =>
        isArabic ? 'تنظيم مكتبي بارامتري' : 'Parametrik masa düzenleyiciler',
      StoreCategory.homeDecorKitchen =>
        isArabic ? 'مزهريات وأوانٍ معمارية' : 'Mimari vazolar ve ev dekoru',
      StoreCategory.gifts =>
        isArabic ? 'تحف ميكانيكية تفاعلية' : 'Kinetik ve özel tasarım hediyeler',
      StoreCategory.keychains =>
        isArabic ? 'إكسسوارات يومية متينة' : 'Dayanıklı EDC anahtarlıklar',
    };
  }
}

class AppConstants {
  static const String appName = 'Film Uygulaması';
  static const String tokenKey = 'auth_token';
  static const String userDataKey = 'user_data';

  // App Names & Titles
  static const String sinflix = 'SINFLIX';

  // Error Messages
  static const String networkError = 'Ağ hatası oluştu';
  static const String serverError = 'Sunucu hatası oluştu';
  static const String invalidEmailFormat = 'Geçerli bir e-posta adresi girin';
  static const String passwordTooShort = 'Şifre en az 6 karakter olmalıdır';
  static const String fieldsRequired = 'Tüm alanlar zorunludur';
  static const String loginFailed = 'Giriş başarısız. Bilgilerinizi kontrol edin.';
  static const String registrationFailed = 'Kayıt başarısız. Lütfen tekrar deneyin.';
  static const String profileFetchFailed = 'Profil verileri alınamadı.';

  // Validation Messages
  static const String emailRequired = 'E-posta gereklidir';
  static const String passwordRequired = 'Şifre gereklidir';
  static const String nameRequired = 'Ad gereklidir';
  static const String confirmPasswordRequired = 'Şifre tekrarı gereklidir';
  static const String enterValidEmail = 'Geçerli bir e-posta girin';
  static const String passwordMinLength = 'Şifre en az 6 karakter olmalıdır';
  static const String passwordsDoNotMatch = 'Şifreler eşleşmiyor'; // Auth UI Texts
  static const String welcome = 'Merhabalar';
  static const String welcomeSubtitle = 'Tempus varius a vitae interdum id tortor elementum tristique eleifend at.';
  static const String email = 'E-Posta';
  static const String password = 'Şifre';
  static const String confirmPassword = 'Şifre Tekrar';
  static const String fullName = 'Ad Soyad';
  static const String login = 'Giriş Yap';
  static const String register = 'Şimdi Kaydol';
  static const String forgotPassword = 'Şifremi unuttum';
  static const String noAccount = 'Bir hesabın yok mu? ';
  static const String alreadyHaveAccount = 'Zaten bir hesabın var mı? ';
  static const String registerLink = 'Kayıt Ol!';
  static const String loginLink = 'Giriş Yap!';

  // Terms & Conditions
  static const String termsText1 = 'Kullanıcı sözleşmesini ';
  static const String termsText2 = 'okudum ve kabul ediyorum.';
  static const String termsText3 = 'Bu sözleşmeyi okuyarak devam ediniz lütfen.';

  // Navigation
  static const String home = 'Anasayfa';
  static const String profile = 'Profil';

  // Paywall
  static const String limitedOffer = 'Sınırlı Teklif';
  static const String unlockDescription = 'Kilidi açmak için bir jeton paketi seçin';
  static const String seeAllTokens = 'Tüm Jetonları Gör';
  static const String bonusFeatures = 'Alacağınız Bonuslar';
  static const String premiumAccount = 'Premium\nHesap';
  static const String moreMatches = 'Daha\nFazla Eşleşme';
  static const String boost = 'Öne\nÇıkarma';
  static const String moreLikes = 'Daha\nFazla Beğeni';
  static const String tokens = 'Jeton';
  static const String weekly = 'Başına haftalık';

  // Profile
  static const String addPhoto = 'Fotoğraf Ekle';
  static const String userId = 'ID: ';

  // General
  static const String loading = 'Yükleniyor...';
  static const String readMore = ' ...Daha Fazlası';

  // Password Strength
  static const String weak = 'Zayıf';
  static const String medium = 'Orta';
  static const String strong = 'Güçlü';
  static const String veryStrong = 'Çok Güçlü'; // Validation
  static const int minPasswordLength = 6;
}

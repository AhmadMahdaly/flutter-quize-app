class EndPoints {
  static const String baseUrl = 'https://smlegate.com/api/';

  // ? auth
  static const String googleLogin = 'gmail/login';
  static const String appleLogin = 'apple/login';
  static const String deleteAccount = 'user/delete';
  static const String profile = 'profile';
  static const String updateProfile = 'user/update';
  static const String gifts = 'gifts';
  static const String fcmToken = 'fcm-token';

  // ? subscription
  static const String getPackages = 'offers';
  static const String getYourCheckout = 'GetYour/Checkout';
  static const String makeSubscription = 'make/subscription';
  static const String addCard = 'user/card';
  static const String getCards = 'user/cards';
  static const String deleteCard = 'user/card/delete/';
  static const String getPlaylistQuestions = 'playlist/questions/';
  static const String removeQuestionFromPlaylist = 'remove/playlist/question';

  // ? revision
  static const String getCategories = 'categories';
  static const String getSubCategories = 'categories/';

  // ? Support
  static const String support = 'support';
  static const String privacyPolicy = 'privacy';

  // ? Calculator
  static const String calculatorInfo = 'schfs/info';
  static const String calculate = 'schfs/calculate';

  // ? Question Bank
  static const String startQBank = 'start/q_bank';
  static const String getQBankCount = 'qbank/filter';
  // static const String createQBank = 'create/q_bank';

  static const String getPlayList = 'all/playlist';
  static const String getPlayListDetails = 'playlist/questions';
  static const String createPlayList = 'create/playlist';
  static const String deletePlayList = 'remove/playlist';
  static const String editPlayList = 'update/playlist';
  static const String addToPlayList = 'add/question/to/playlist';
  static const String getFreeTrial = 'start/free/trial';
  static const String markAsAnswered = 'qbank/mark-as-answered';

  ///
  static const String startFreeQBank = 'free-trial/start';
  static const String getFreeQBankCount = 'free-trial/filter';
  static const String createFreeQBank = 'free-trial/create';
  static const String freeTrialYears = 'free-trial/years';
  static const String freeTrialMonths = 'free-trial/months';

  /// ? Real Exam
  static const String startRealExam = 'start/real/exam';
  static const String getQuestion = 'get-question/';
  static const String getRealExamQuestions = 'get/real/exam';
  static const String answerQuestion = 'answer/question';
  static const String makeQuestionFlag = 'question/flag';
  static const String addQuestionNote = 'question/note';
  static const String finishAnalysisExam = 'exam/analysis';
  static const String getExamHistory = 'exam/history';
  static const String getExamsHistory = 'exams/history';
  static const String verifyPurchase = 'verifyPurchase';
  static const String checkSubscribe = 'check/subscribed';
  static const String addQBankNote = 'add/q/bank/note';
  static const String paymentProcess = 'payment/process';
  // static const String paymentCallback = 'payment/callback';
  // static const String paymentCallbackGift = 'gift/payment/callback';

  static const String paymentProcessGift = 'gifts/payment/process';
  static const String giftCheckout = 'gifts/checkout';
  static const String years = 'exam-dates/qbank';
}

class EndPoints {
  static const String baseUrl = 'https://smlegate.com/api/';

  // ? auth
  static const String googleLogin = 'gmail/login';
  static const String appleLogin = 'apple/login';
  static const String deleteAccount = 'user/delete';
  static const String profile = 'profile';
  static const String gifts = 'gifts';

  // ? subscription
  static const String getPackages = 'offers';
  static const String getYourCheckout = 'GetYour/Checkout';
  static const String makeSubscription = 'make/subscription';
  static const String addCard = 'user/card';
  static const String getCards = 'user/cards';
  static const String deleteCard = 'user/card/delete/';
  static const String getPlaylistQuestions = 'playlist/questions/';
  static const String removeQuestionFromPlaylist= 'remove/playlist/question';

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
  // FIXED: Renamed for clarity. This endpoint returns the list of questions.
  static const String startQBank = 'start/q_bank';
  // FIXED: Renamed for clarity. This endpoint returns the count of questions.
  static const String getQBankCount = 'qbank/filter';

  static const String getPlayList = 'all/playlist';
  static const String getPlayListDetails = 'playlist/questions';
  static const String createPlayList = 'create/playlist';
  static const String deletePlayList = 'remove/playlist';
  static const String editPlayList = 'update/playlist';
  static const String addToPlayList = 'add/question/to/playlist';
  static const String getFreeTrial = 'start/free/trial';
  static const String markAsAnswered = 'qbank/mark-as-answered';
  static const String createQBank = 'create/q_bank';

  /// ? Real Exam
  static const String startRealExam = 'start/real/exam';
  static const String getQuestion = 'get-question/';
  static const String getRealExamQuestions = 'get/real/exam';
  static const String answerQuestion = 'answer/question';
  static const String makeQuestionFlag = 'question/flag';
  static const String addQuestionNote = 'question/note';
  static const String finishAnalysisExam = 'exam/analysis';
  static const String getExamHistory = 'exam/history';
  static const String verifyPurchase='verifyPurchase';
  static const String checkSubscribe='check/subscribed';
  static const String addQBankNote='add/q/bank/note';

}

class EndPoints {
  static const String baseUrl = 'https://smle.alsaif.online/api/';

  // ? auth
  static const String googleLogin = 'gmail/login';
  static const String appleLogin = 'apple/login';
  static const String deleteAccount = 'user/delete';
  static const String profile = 'profile';
  // static const String login = 'auth/google';

  // ? subscriptionH
  static const String getPackages = 'offers';
  static const String getYourCheckout = 'GetYour/Checkout';
  static const String makeSubscription = 'make/subscription';
  static const String addCard = 'user/card';
  static const String getCards = 'user/cards';
  static const String deleteCard = 'user/card/delete/';

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
  static const String getQBank = 'start/q_bank';
  static const String getPlayList = 'all/playlist';
  static const String getPlayListDetails = 'playlist/questions';
  static const String createPlayList = 'create/playlist';
  static const String deletePlayList = 'remove/playlist';
  static const String editPlayList = 'update/playlist';
  static const String getFreeTrial = 'start/free/trial';

  /// ? Real Exam
  static const String startRealExam = 'start/real/exam';
  static const String getQuestion = 'get-question/';
  static const String getRealExamQuestions = 'get/real/exam';
  static const String answerQuestion = 'answer/question';
  static const String makeQuestionFlag = 'question/flag';
  static const String addQuestionNote = 'question/note';
  static const String finishAnalysisExam = 'exam/analysis';
  static const String getExamHistory = 'exam/history';
}

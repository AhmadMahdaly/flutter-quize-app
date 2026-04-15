import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smle/core/di.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/features/SCFHS_score_calculator/scfhs_score_calculator_screen.dart';
import 'package:smle/features/analysis/presentation/cubit/analysis_cubit.dart';
import 'package:smle/features/analysis/presentation/views/analysis_dashboard_screen.dart';
import 'package:smle/features/analysis/presentation/views/analysis_screen.dart';
import 'package:smle/features/auth/cubit/login_cubit.dart';
import 'package:smle/features/auth/login_screen.dart';
import 'package:smle/features/chat_message/presentation/controllers/cubit/chat_cubit.dart';
import 'package:smle/features/chat_message/presentation/views/chat_screen.dart';
import 'package:smle/features/check_subscription/check_subscription_cubit.dart';
import 'package:smle/features/exams_history/cubit/exams_history_cubit.dart';
import 'package:smle/features/exams_history/data/models/exams_history_model.dart';
import 'package:smle/features/exams_history/exams_history_screen.dart';
import 'package:smle/features/free_q_bank/cubit/free_q_bank_cubit.dart';
import 'package:smle/features/free_q_bank/free_create_quiz_screen.dart';
import 'package:smle/features/free_q_bank/free_q_bank_screen.dart';
// import 'package:smle/features/free_trial/views/trial_exam_screen.dart';
import 'package:smle/features/gifts/gifts_screen.dart';
import 'package:smle/features/gifts/send_gift_screen.dart';
import 'package:smle/features/home/home_screen.dart';
import 'package:smle/features/leader_board/presentation/controllers/cubit/leaderboard_cubit.dart';
import 'package:smle/features/leader_board/presentation/views/leaderboard_screen.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';
import 'package:smle/features/main%20layout/main_layout.dart';
import 'package:smle/features/notification/cubit/notification_cubit.dart';
import 'package:smle/features/notification/notification_screen.dart';
import 'package:smle/features/play_list/play_list_screen.dart';
import 'package:smle/features/play_list/playlist_questions_screen.dart';
import 'package:smle/features/profile/profile_screen.dart';
import 'package:smle/features/profile/update_profile_screen.dart';
import 'package:smle/features/q_bank/create_quiz_screen.dart';
import 'package:smle/features/q_bank/cubit/q_bank_cubit.dart';
import 'package:smle/features/q_bank/data/model/start_quiz_model.dart';
import 'package:smle/features/q_bank/q_bank_screen.dart';
import 'package:smle/features/real_exam/cubit/real_exam_cubit.dart';
import 'package:smle/features/real_exam/views/exam_page.dart';
import 'package:smle/features/real_exam/views/widgets/confirm_access_page.dart';
import 'package:smle/features/revision/categories_screen.dart';
import 'package:smle/features/revision/cubit/revision_cubit.dart';
import 'package:smle/features/revision/revision_screen.dart';
import 'package:smle/features/revision/subCategories_screen.dart';
import 'package:smle/features/scfhs_score_calculator/cubit/scfhs_score_calculator_cubit_cubit.dart';
import 'package:smle/features/splash/screens/splash_screen.dart';
import 'package:smle/features/subscription/checkout_screen.dart';
import 'package:smle/features/subscription/cubit/subscription_cubit.dart';
import 'package:smle/features/subscription/data/model/packages_model.dart';
import 'package:smle/features/subscription/subscription_screen.dart';
import 'package:smle/features/support_privacy_policy/cubit/privacy_policy_cubit.dart';
import 'package:smle/features/support_privacy_policy/privacy_policy_screen.dart';
import 'package:smle/features/support_privacy_policy/support_screen.dart';
// import 'package:smle/features/view_media_in_app/pdf_viewer_from_url_screen.dart';
// import 'package:smle/features/view_media_in_app/video_player_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    PageTransition transition<T extends Cubit<Object>>({
      required Widget screen,
      T? cubit,
      Object? arguments,
    }) {
      final child = cubit != null
          ? BlocProvider<T>.value(value: cubit, child: screen)
          : screen;

      return PageTransition(
        child: child,
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        settings: settings,
      );
    }

    switch (settings.name) {
      case AppRoutes.splashScreen:
        return transition(screen: const SplashScreen());
      // case Routes.onBoardingScreen:
      //   return transition(screen: OnBoardingScreen(), cubit: GlobalCubit());
      case AppRoutes.loginScreen:
        return transition(
          screen: const LoginScreen(),
          cubit: getIt<LoginCubit>(),
        );
      case AppRoutes.analysisDashboardScreen:
        return transition(
          screen: BlocProvider.value(
            value: getIt<ExamsHistoryCubit>()..fetchExamsHistory(),
            child: const AnalysisDashboardScreen(),
          ),
          cubit: getIt<AnalysisCubit>()..getAnalysis(),
        );
      case AppRoutes.examAnalysisScreen:
        final exam = settings.arguments as Exam;
        return transition(
          screen: ExamAnalysisScreen(exam: exam),
          cubit: getIt<AnalysisCubit>(),
        );
      case AppRoutes.profileScreen:
        return transition(screen: const ProfileScreen());
      case AppRoutes.giftsScreen:
        return transition(
          screen: const GiftsScreen(),
          cubit: getIt<MainLayoutCubit>()..getGifts(),
        );

      case AppRoutes.notificationScreen:
        return transition(
          screen: const NotificationScreen(),
          cubit: getIt<NotificationCubit>(),
        );
      case AppRoutes.privacyPolicyScreen:
        return transition(
          screen: const PrivacyPolicyScreen(),
          cubit: getIt<PrivacyPolicySupportCubit>()..getPrivacyPolicy(),
        );
      case AppRoutes.supportScreen:
        return transition(
          screen: const SupportScreen(),
          cubit: getIt<PrivacyPolicySupportCubit>()..getSupport(),
        );
      case AppRoutes.sCFHSScoreCalculatorScreen:
        return transition(
          screen: const ScfhsScoreCalculatorScreen(),
          cubit: getIt<ScfhsScoreCalculatorCubit>()..getCalculatorInfo(),
        );
      case AppRoutes.subscriptionScreen:
        final offerId = settings.arguments as int;
        return transition(
          screen: SubscriptionScreen(offerId: offerId),
          cubit: getIt<SubscriptionCubit>()..getPackages(),
        );
      // case Routes.paymentScreen:
      //   // final packageId = settings.arguments as String;
      //   return transition(
      //     screen: const PaymentScreen(),
      //     cubit: SubscriptionCubit(getIt()),
      //   );

      case AppRoutes.updateProfileScreen:
        return transition(
          screen: const UpdateProfileScreen(),
          // cubit: SubscriptionCubit(getIt(), getIt()),
        );
      case AppRoutes.analysisScreen:
        final isExam = settings.arguments as bool;
        return transition(
          screen: AnalysisScreen(isExam: isExam),
          cubit: getIt<AnalysisCubit>()..getAnalysis(),
        );
      // case AppRoutes.analysisHistoryScreen:
      //   final exam = settings.arguments as Exam;
      //   return transition(
      //     screen: ExamAnalysisHistoryScreen(exam: exam),
      //     cubit: getIt<AnalysisCubit>()..getAnalysis(),
      //   );
      case AppRoutes.createQuizScreen:
        final istrial = settings.arguments as bool?;
        return transition(
          screen: CreateQuizScreen(istrial: istrial),
          cubit: getIt<QBankCubit>()..getCategories(),
        );
      case AppRoutes.qBankScreen:
        final startQuizModel = settings.arguments as StartQuizModel;
        return transition(
          screen: BlocProvider.value(
            value: getIt<QBankCubit>(),
            child: QBankScreen(startQuizModel: startQuizModel),
          ),
        );
      case AppRoutes.freeqBankScreen:
        final startQuizModel = settings.arguments as StartQuizModel;
        return transition(
          screen: BlocProvider.value(
            value: getIt<FreeQBankCubit>(),
            child: FreeQBankScreen(startQuizModel: startQuizModel),
          ),
        );
      case AppRoutes.examsHistoryScreen:
        return transition(
          screen: const ExamsHistoryScreen(),
          cubit: getIt<ExamsHistoryCubit>()..fetchExamsHistory(),
        );
      case AppRoutes.revisionScreen:
        final categoryId = settings.arguments as String;
        return transition(
          screen: const RevisionScreen(),
          cubit: getIt<RevisionCubit>()..getSubCategories(categoryId),
        );
      case AppRoutes.categoriesScreen:
        return transition(
          screen: const CategoriesScreen(),
          cubit: getIt<RevisionCubit>()..getCategories(),
        );
      case AppRoutes.subcategoriesScreen:
        final categoryId = settings.arguments as String;
        return transition(
          screen: const SubcategoriesScreen(),
          cubit: getIt<RevisionCubit>()..getSubCategories(categoryId),
        );
      case AppRoutes.playListScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final questionId = args['questionId'] as int?;
        final isAdd = args['asAdd'] as bool?;
        return transition(
          screen: PlayListScreen(questionId: questionId, isAdd: isAdd),
        );

      case AppRoutes.playlistQuestionsScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final playlistId = args['playlistId'] as int;
        final totalQuestions = args['totalQuestions'] as int;
        final isAdd = args['asAdd'] as bool;
        return transition(
          screen: PlaylistQuestionsScreen(
            playlistId: playlistId,
            totalQuestions: totalQuestions,
            isAdd: isAdd,
          ),
        );
      case AppRoutes.mainLayoutScreen:
        return PageTransition(
          child: BlocProvider.value(
            value: getIt<MainLayoutCubit>()..getProfile(),
            child: const MainLayoutScreen(),
          ),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          settings: settings,
        );

      case AppRoutes.realExamScreen:
        return transition(
          screen: const RealExamPage(),
          cubit: getIt<RealExamCubit>(),
        );

      case AppRoutes.confirmAccessToRealExam:
        return transition(
          screen: const ConfirmAccessToRealExam(),
          cubit: getIt<CheckSubscriptionCubit>()
            ..loadSubscription()
            ..loadAiSubscription(),
        );

      case AppRoutes.leaderboardScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<LeaderboardCubit>()..fetchLeaderboard(),
            child: const LeaderboardScreen(),
          ),
        );
      case AppRoutes.chatScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ChatCubit>(),
            child: const ChatScreen(),
          ),
        );
      // case AppRoutes.pdfViewerFromUrlScreen:
      //   final url = settings.arguments as String;
      //   return MaterialPageRoute(
      //     builder: (_) => PdfViewerFromUrlScreen(pdfUrl: url),
      //   );
      // case AppRoutes.videoPlayerScreen:
      //   final url = settings.arguments as String;
      //   return MaterialPageRoute(
      //     builder: (_) => VideoPlayerScreen(videoUrl: url),
      //   );

      case AppRoutes.checkoutScreen:
        final data = settings.arguments as Map;
        final package = data['package'] as Data;
        final cubit = data['cubit'] as SubscriptionCubit;

        return transition(
          screen: CheckoutScreen(package: package, cubit: cubit),
        );
      case AppRoutes.sendGiftScreen:
        return transition(
          screen: const SendGiftScreen(),
          cubit: getIt<SubscriptionCubit>()..getPackages(),
        );
      default:
        return null;
    }
  }

  List<Widget> screen = [
    BlocProvider(
      create: (context) => getIt<FreeQBankCubit>()..getCategories(),
      child: const FreeCreateQuizScreen(istrial: true),
    ),

    // const FreeCreateQuizScreen(),
    const HomeScreen(),
    const ProfileScreen(),
  ];
  // List<Widget> guestScreen = [const HomeScreen()];
}

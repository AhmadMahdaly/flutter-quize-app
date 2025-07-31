import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smle/core/di.dart';
import 'package:smle/core/routing/routes.dart';
import 'package:smle/features/SCFHS_score_calculator/SCFHS_score_calculator_screen.dart';
import 'package:smle/features/SCFHS_score_calculator/cubit/SCFHS_score_calculator_cubit.dart';
import 'package:smle/features/analysis/analysis_screen.dart';
import 'package:smle/features/analysis/cubit/analysis_cubit.dart';
import 'package:smle/features/exams_history/cubit/exams_history_cubit.dart';
import 'package:smle/features/exams_history/exams_history_screen.dart';
import 'package:smle/features/free_trial/views/trial_exam_screen.dart';
import 'package:smle/features/gifts/gifts_screen.dart';
import 'package:smle/features/guest/main_layout_page.dart';
import 'package:smle/features/home/home_screen.dart';
import 'package:smle/features/login/cubit/login_cubit.dart';
import 'package:smle/features/login/login_screen.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';
import 'package:smle/features/main%20layout/main_layout.dart';
import 'package:smle/features/notification/cubit/notification_cubit.dart';
import 'package:smle/features/notification/notification_screen.dart';
import 'package:smle/features/onboarding/onboarding_screen.dart';
import 'package:smle/features/play_list/cubit/play_list_cubit.dart';
import 'package:smle/features/play_list/play_list_details_screen.dart';
import 'package:smle/features/play_list/play_list_screen.dart';
import 'package:smle/features/profile/profile_screen.dart';
import 'package:smle/features/q_bank/create_quiz_screen.dart';
import 'package:smle/features/q_bank/cubit/q_bank_cubit.dart';
import 'package:smle/features/q_bank/data/model/startQuizModel.dart';
import 'package:smle/features/q_bank/q_bank_screen.dart';
import 'package:smle/features/real_exam/cubit/real_exam_cubit.dart';
import 'package:smle/features/real_exam/data/model/finish_analysis_exam.dart';
import 'package:smle/features/real_exam/views/exam_page.dart';
import 'package:smle/features/real_exam/views/exam_results_page.dart';
import 'package:smle/features/revision/categories_screen.dart';
import 'package:smle/features/revision/cubit/revision_cubit.dart';
import 'package:smle/features/revision/revision_screen.dart';
import 'package:smle/features/revision/subCategories_screen.dart';
import 'package:smle/features/splash/cubit/global_cubit/global_cubit.dart';
import 'package:smle/features/splash/screens/splash_screen.dart';
import 'package:smle/features/subscription/add_card_Screen.dart';
import 'package:smle/features/subscription/apple_pay_screen.dart';
import 'package:smle/features/subscription/cubit/Subscription_cubit.dart';
import 'package:smle/features/subscription/payment_screen.dart';
import 'package:smle/features/subscription/subscription_screen.dart';
import 'package:smle/features/support_privacy_policy/cubit/privacy_policy_cubit.dart';
import 'package:smle/features/support_privacy_policy/privacy_policy_screen.dart';
import 'package:smle/features/support_privacy_policy/support_screen.dart';
import 'package:smle/features/view_media_in_app/pdf_viewer_from_url_screen.dart';
import 'package:smle/features/view_media_in_app/video_player_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    PageTransition transition<T extends Cubit<Object>>({
      required Widget screen,
      T? cubit,
      Object? arguments,
    }) {
      final child = cubit != null
          ? BlocProvider<T>(create: (context) => cubit, child: screen)
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
      case Routes.splashScreen:
        return transition(screen: const SplashScreen());
      case Routes.onBoardingScreen:
        return transition(screen: OnBoardingScreen(), cubit: GlobalCubit());
      case Routes.loginScreen:
        return transition(
          screen: const LoginScreen(),
          cubit: LoginCubit(getIt()),
        );
      case Routes.profileScreen:
        return transition(
          screen: const ProfileScreen(),
          cubit: MainLayoutCubit(getIt())..getProfile(),
        );
        case Routes.giftsScreen:
        return transition(
          screen: const GiftsScreen(),
          cubit: MainLayoutCubit(getIt())..getGifts(),
        );

      case Routes.notificationScreen:
        return transition(
          screen: const NotificationScreen(),
          cubit: NotificationCubit(),
        );
      case Routes.privacyPolicyScreen:
        return transition(
          screen: const PrivacyPolicyScreen(),
          cubit: PrivacyPolicySupportCubit(getIt())..getPrivacyPolicy(),
        );
      case Routes.supportScreen:
        return transition(
          screen: const SupportScreen(),
          cubit: PrivacyPolicySupportCubit(getIt())..getSupport(),
        );
      case Routes.sCFHSScoreCalculatorScreen:
        return transition(
          screen: const ScfhsScoreCalculatorScreen(),
          cubit: ScfhsScoreCalculatorCubit(getIt())..getCalculatorInfo(),
        );
      case Routes.subscriptionScreen:
        final offerId = settings.arguments as int;
        return transition(
          screen: SubscriptionScreen(offerId: offerId),
          cubit: SubscriptionCubit(getIt())..getPackages(),
        );
      case Routes.paymentScreen:
        final packageId = settings.arguments as String;
        return transition(
          screen: const PaymentScreen(),
          cubit: SubscriptionCubit(getIt())..getCards()..getYourCheckout(packageId),
        );
      case Routes.addCardScreen:
        return transition(
          screen:  AddCardScreen(),
          cubit: SubscriptionCubit(getIt()),
        );
      case Routes.applePayScreen:
        final totalPayment = settings.arguments as String;
        return transition(
          screen: ApplePayScreen(total: totalPayment),
          cubit: SubscriptionCubit(getIt()),
        );
      case Routes.analysisScreen:
        final isExam = settings.arguments as bool;
        return transition(
          screen:  AnalysisScreen(isExam: isExam,),
          cubit: AnalysisCubit(getIt())..getAnalysis(),
        );
      case Routes.createQuizScreen:
        return transition(
          screen: const CreateQuizScreen(),
          cubit: QBankcubit(getIt())..getCategories(),
        );
      case Routes.qBankScreen:
        final StartQuizModel startQuizModel =
            settings.arguments as StartQuizModel;
        return transition(
          screen: QBankScreen(startQuizModel: startQuizModel),
          cubit: QBankcubit(getIt())
            ..startQuiz(
              startQuizModel.context!,
              startQuizModel.pickedDate!.month,
              startQuizModel.pickedDate!.year,
              startQuizModel.selectedSubCategoryId!,
            ),
        );
      case Routes.examsHistoryScreen:
        return transition(
          screen: const ExamsHistoryScreen(),
          cubit: ExamsHistoryCubit(getIt())..fetchExamsHistory(),
        );
      case Routes.revisionScreen:
        final categoryId = settings.arguments as String;
        return transition(
          screen: const RevisionScreen(),
          cubit: RevisionCubit(getIt())..getSubCategories(categoryId),
        );
      case Routes.categoriesScreen:
        return transition(
          screen: const CategoriesScreen(),
          cubit: RevisionCubit(getIt())..getCategories(),
        );
      case Routes.subcategoriesScreen:
        final categoryId = settings.arguments as String;
        return transition(
          screen: const SubcategoriesScreen(),
          cubit: RevisionCubit(getIt())..getSubCategories(categoryId),
        );
      case Routes.playListScreen:
        final questionId = settings.arguments as int;
        return transition(
          screen: PlayListScreen(questionId: questionId),
          cubit: PlayListCubit(getIt())..getPlayList(),
        );
      case Routes.playListDetailsScreen:
        return transition(
          screen: const PlayListDetailsScreen(),
          cubit: PlayListCubit(getIt())..getPlayList(),
        );
      case Routes.mainLayoutScreen:
        return PageTransition(
          child: BlocProvider(
            create: (context) => getIt<MainLayoutCubit>()..getProfile(),
            child: const MainLayoutScreen(),
          ),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          settings: settings,
        );

      case Routes.realExamScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<RealExamCubit>(),
            child: const RealExamPage(),
          ),
        );
      // case Routes.examResultsPage:
      //   final results = settings.arguments as FinishAnalysisExamModel;
      //   return MaterialPageRoute(
      //     builder: (_) => ExamResultsPage(results: results),
      //   );
      case Routes.guestScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<MainLayoutCubit>(),
            child: const GuestMainLayoutScreen(),
          ),
        );
      case Routes.pdfViewerFromUrlScreen:
        final url = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => PdfViewerFromUrlScreen(pdfUrl: url),
        );
      case Routes.videoPlayerScreen:
        final url = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => VideoPlayerScreen(videoUrl: url),
        );
      case Routes.trialExamScreen:
        return MaterialPageRoute(builder: (_) => const TrialExamScreen());
      default:
        return null;
    }
  }

  List<Widget> screen = [
    const TrialExamScreen(),
    const HomeScreen(isGuest: false),
    const ProfileScreen(),
  ];
  List<Widget> guestScreen = [const HomeScreen(isGuest: true)];
}

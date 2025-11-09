import 'package:get_it/get_it.dart';
import 'package:smle/core/network/dio_factory.dart';
import 'package:smle/features/SCFHS_score_calculator/data/repo/calculator_repo.dart';
import 'package:smle/features/analysis/cubit/analysis_cubit.dart';
import 'package:smle/features/analysis/data/repo/analysis_repo.dart';
import 'package:smle/features/check_subscription/data/repo/check_subscription_repo.dart';
import 'package:smle/features/exams_history/cubit/exams_history_cubit.dart';
import 'package:smle/features/exams_history/data/repo/exams_history_repository.dart';
import 'package:smle/features/free_trial/cubit/free_trial_cubit.dart';
import 'package:smle/features/free_trial/data/repo/free_trial_repo.dart';
import 'package:smle/features/login/data/repo/login_repo.dart';
import 'package:smle/features/main%20layout/cubit/main_layout_cubit.dart';
import 'package:smle/features/main%20layout/data/repo/main_layout_repo.dart';
import 'package:smle/features/notification/cubit/notification_cubit.dart';
import 'package:smle/features/play_list/cubit/play_list_cubit.dart';
import 'package:smle/features/play_list/data/repo/play_list_repo.dart';
import 'package:smle/features/q_bank/cubit/q_bank_cubit.dart';
import 'package:smle/features/q_bank/data/repo/q_bank_repo.dart';
import 'package:smle/features/real_exam/cubit/real_exam_cubit.dart';
import 'package:smle/features/real_exam/data/repo/real_exam_repo.dart';
import 'package:smle/features/revision/data/repo/revision_repo.dart';
import 'package:smle/features/subscription/data/repo/subscription_repo.dart';
import 'package:smle/features/support_privacy_policy/data/repo/privacy_support_repo.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  getIt.registerLazySingleton<DioFactory>(() => DioFactory());
  getIt.registerFactory<MainLayoutCubit>(() => MainLayoutCubit(getIt()));
  getIt.registerFactory<NotificationCubit>(() => NotificationCubit());
  getIt.registerLazySingleton<AnalysisRepository>(() => AnalysisRepository(getIt()));
  getIt.registerFactory<AnalysisCubit>(() => AnalysisCubit(getIt()));
  getIt.registerLazySingleton<ExamsHistoryRepository>(
    () => ExamsHistoryRepository(getIt()),
  );

  getIt.registerFactory<ExamsHistoryCubit>(() => ExamsHistoryCubit(getIt()));
  getIt.registerLazySingleton<MainLayoutRepository>(
    () => MainLayoutRepository(getIt()),
  );
  getIt.registerLazySingleton<LoginRepository>(() => LoginRepository(getIt()));

  getIt.registerLazySingleton<SubscriptionRepository>(
    () => SubscriptionRepository(getIt()),
  );
  getIt.registerLazySingleton<RevisionRepository>(() => RevisionRepository(getIt()));
  getIt.registerLazySingleton<PrivacySupportRepository>(
    () => PrivacySupportRepository(getIt()),
  );
  getIt.registerLazySingleton<CalculatorRepository>(
    () => CalculatorRepository(getIt()),
  );
  getIt.registerLazySingleton<QBankRepository>(() => QBankRepository(getIt()));
  getIt.registerLazySingleton<PlayListRepository>(() => PlayListRepository(getIt()));
  getIt.registerLazySingleton<RealExamRepo>(() => RealExamRepo(getIt()));
  getIt.registerLazySingleton<RealExamCubit>(()=>RealExamCubit(getIt()));
  getIt.registerLazySingleton<PlayListCubit>(()=>PlayListCubit(getIt()));

  getIt.registerFactory<TrialExamRepository>(
    () => TrialExamRepository(getIt()),
  );
  getIt.registerFactory<TrialExamCubit>(() => TrialExamCubit(getIt()));
  getIt.registerFactory<QBankCubit>(() => QBankCubit(getIt()));

  getIt.registerLazySingleton<CheckSubscriptionRepository>(() => CheckSubscriptionRepository(getIt()));

}

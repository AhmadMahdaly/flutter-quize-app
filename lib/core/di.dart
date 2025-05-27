import 'package:get_it/get_it.dart';
import 'package:smle/features/SCFHS_score_calculator/data/repo/calculator_repo.dart';
import 'package:smle/features/analysis/cubit/analysis_cubit.dart';
import 'package:smle/features/exams_history/cubit/exams_history_cubit.dart';
import 'package:smle/features/login/data/repo/login_repo.dart';
import 'package:smle/features/play_list/data/repo/play_list_repo.dart';
import 'package:smle/features/q_bank/data/repo/q_bank_repo.dart';
import 'package:smle/features/subscription/data/repo/subscription_repo.dart';
import 'package:smle/features/support_privacy_policy/data/repo/privacy_support_repo.dart';
import '../features/main layout/cubit/main_layout_cubit.dart';
import '../features/main layout/data/repo/main_layout_repo.dart';
import '../features/notification/cubit/notification_cubit.dart';
import '../features/revision/data/repo/revision_repo.dart';
import 'network/dio_factory.dart';


final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  getIt.registerLazySingleton<DioFactory>(() => DioFactory());
  getIt.registerFactory<MainLayoutCubit>(() => MainLayoutCubit(getIt()));
  getIt.registerFactory<NotificationCubit>(() => NotificationCubit());
  getIt.registerFactory<AnalysisCubit>(() => AnalysisCubit());
  getIt.registerFactory<ExamsHistoryCubit>(() => ExamsHistoryCubit());
  getIt.registerFactory<MainLayoutRepository>(() => MainLayoutRepository(getIt()));
  getIt.registerFactory<LoginRepository>(() => LoginRepository(getIt()));
  getIt.registerFactory<SubscriptionRepository>(() => SubscriptionRepository(getIt()));
  getIt.registerFactory<RevisionRepository>(() => RevisionRepository(getIt()));
  getIt.registerFactory<PrivacySupportRepository>(() => PrivacySupportRepository(getIt()));
  getIt.registerFactory<CalculatorRepository>(() => CalculatorRepository(getIt()));
  getIt.registerFactory<QBankRepository>(() => QBankRepository(getIt()));
  getIt.registerFactory<PlayListRepository>(() => PlayListRepository(getIt()));
}

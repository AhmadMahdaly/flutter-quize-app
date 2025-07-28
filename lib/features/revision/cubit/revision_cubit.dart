import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smle/core/helpers/loading.dart';
import 'package:smle/features/revision/data/model/categories_model.dart';
import 'package:smle/features/revision/data/model/subcategories_model.dart';
import 'package:smle/features/revision/data/repo/revision_repo.dart';
part 'revision_state.dart';

class RevisionCubit extends Cubit<RevisionStates> {
  RevisionCubit(this._revisionRepository)
      : super(RevisionInitialState());
  final RevisionRepository _revisionRepository;

  /// Get Categories
  CategoriesModel? categoriesModel;
  Future getCategories() async {
    showLoading();
    emit(GetCategoriesLoadingState());
    final result = await _revisionRepository.getCategories();
    result.when(success: (success) {
      categoriesModel = success;
      hideLoading();
      emit(GetCategoriesSuccessState());
    }, failure: (error) {
      hideLoading();
      emit(GetCategoriesFailedState());
    });
  }

  /// Get Sub Categories
  SubCategoriesModel? subCategoriesModel;
  Future getSubCategories(String categoryId) async {
    showLoading();
    emit(GetSubCategoriesLoadingState());
    final result = await _revisionRepository.getSubCategories(categoryId);
    result.when(success: (success) {
      subCategoriesModel = success;
      hideLoading();
      emit(GetSubCategoriesSuccessState());
    }, failure: (error) {
      hideLoading();
      emit(GetSubCategoriesFailedState());
    });
  }

  /// Open PDF
  Future<void> openPDF(String url) async {
    if (url.isEmpty) {
      throw 'URL cannot be empty';
    }

    final Uri pdfUri = Uri.parse(url);

    if (!await canLaunchUrl(pdfUri)) {
      throw 'Could not launch $url';
    }

    try {
      await launchUrl(
        pdfUri,
        mode: LaunchMode.externalApplication, // Opens in an external browser
        webViewConfiguration: const WebViewConfiguration(
          enableJavaScript: true,
          enableDomStorage: true,
        ),
      );
    } catch (e) {
      throw 'Failed to open PDF: $e';
    }
  }

  /// Open Video
  Future<void> launchVideo(String url) async {
    if (url.isEmpty) {
      throw 'URL cannot be empty';
    }

    final Uri videoUri = Uri.parse(url);

    if (!await canLaunchUrl(videoUri)) {
      throw 'Could not launch $url';
    }

    try {
      await launchUrl(
        videoUri,
        mode: LaunchMode.externalApplication, // Opens in the default video player or browser
      );
    } catch (e) {
      throw 'Failed to launch video: $e';
    }
  }
}

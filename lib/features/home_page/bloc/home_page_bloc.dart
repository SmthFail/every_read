import 'package:every_read/common/models/document_model.dart';
import 'package:every_read/features/app/repositories/app_settings_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/result_class.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  AppSettingsRepository appSettingsRepository;
  HomePageBloc(super.initialState, this.appSettingsRepository) {
    on<HomePageEvent>((event, emit) async {
      switch (event)  {
        case LoadPrevious():
          await _handleLoadPrevious(event, emit);
        case SetCurrentDoc():
          await _handleSetCurrentPath(event, emit);
        case HomePageErrorOccurred():
          await _handleHomePageErrorOccurred(event, emit);
      }
    });
  }

  _handleLoadPrevious(LoadPrevious event, Emitter<HomePageState> emit) async {
    emit(HomePageLoading());
    Result<List<DocumentModel>, Exception> result = await appSettingsRepository.getPreviousDocuments();
    switch (result) {
      case Success<List<DocumentModel>, Exception>(value: List<DocumentModel> value):
        emit(HomePageLoaded(value));
      case Failure<List<DocumentModel>?, Exception>(exception: var exc):
        emit(HomePageFailure(exc.toString()));
    }

  }

  _handleSetCurrentPath(SetCurrentDoc event, Emitter<HomePageState> emit) async {
    bool res = appSettingsRepository.setCurrentDocument(event.document);
    if (!res) {
      emit(HomePageFailure("Can't set document"));
      return;
    }
    emit(HomePageStartLoadingDoc(event.document));
  }

  _handleHomePageErrorOccurred(HomePageErrorOccurred event, Emitter<HomePageState> emit) async {
    emit(HomePageFailure(event.message));
  }
}

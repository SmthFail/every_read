import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/models/document_model.dart';
import '../../app/repositories/app_settings_repository.dart';

part 'fb2_reader_event.dart';
part 'fb2_reader_state.dart';

class Fb2ReaderBloc extends Bloc<Fb2ReaderEvent, Fb2ReaderState> {
  AppSettingsRepository appSettingsRepository;

  Fb2ReaderBloc(super.initialState, this.appSettingsRepository) {
    on<Fb2ReaderEvent>((event, emit) async {
      switch (event) {
        case Fb2ReaderLoadBook():
          await _handleFb2ReaderLoadBook(event, emit);
      }
    });
  }

  _handleFb2ReaderLoadBook(Fb2ReaderLoadBook event, Emitter<Fb2ReaderState> emit) async {
    emit(Fb2ReaderLoading());
    DocumentModel? book = appSettingsRepository.currentDocument;
    if (book == null) {
      emit(const Fb2ReaderFailure("Can't load book. Its empty?"));
      return;
    }
    emit(Fb2ReaderBookLoaded(book));
  }
}

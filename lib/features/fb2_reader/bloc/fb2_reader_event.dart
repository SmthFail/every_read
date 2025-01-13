part of 'fb2_reader_bloc.dart';

sealed class Fb2ReaderEvent extends Equatable {
  const Fb2ReaderEvent();
}

class Fb2ReaderLoadBook extends Fb2ReaderEvent {
  @override
  List<Object?> get props => [];
}

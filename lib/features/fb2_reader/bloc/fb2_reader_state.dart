part of 'fb2_reader_bloc.dart';

sealed class Fb2ReaderState extends Equatable {
  const Fb2ReaderState();
}

final class Fb2ReaderLoading extends Fb2ReaderState {
  @override
  List<Object> get props => [];
}

final class Fb2ReaderFailure extends Fb2ReaderState {
  final String message;

  const Fb2ReaderFailure(this.message);

  @override
  List<Object?> get props => [message];
}

final class Fb2ReaderBookLoaded extends Fb2ReaderState {
  final DocumentModel book;

  const Fb2ReaderBookLoaded(this.book);

  @override
  List<Object?> get props => [book];
}

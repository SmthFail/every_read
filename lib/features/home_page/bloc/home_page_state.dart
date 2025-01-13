part of 'home_page_bloc.dart';

sealed class HomePageState {}

final class HomePageInitial extends HomePageState {}

final class HomePageLoading extends HomePageState {}

final class HomePageLoaded extends HomePageState {
  final List<DocumentModel> previousDocs;

  HomePageLoaded(this.previousDocs);
}

final class HomePageFailure extends HomePageState {
 final String errorMessage;

  HomePageFailure(this.errorMessage);
}

final class HomePageStartLoadingDoc extends HomePageState {
  final DocumentModel document;
  HomePageStartLoadingDoc(this.document);
}

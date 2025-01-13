part of 'home_page_bloc.dart';

sealed class HomePageEvent {}

class LoadPrevious extends HomePageEvent {}

class SetCurrentDoc extends HomePageEvent {
  final DocumentModel document;

  SetCurrentDoc(this.document);
}

class HomePageErrorOccurred extends HomePageEvent {
  final String message;
  HomePageErrorOccurred(this.message);
}



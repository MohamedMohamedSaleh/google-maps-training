part of 'search_bloc.dart';

class SearchStates {}

final class SearchSuccessState extends SearchStates {
  final List<Results> list;

  SearchSuccessState({required this.list});
}

final class SearchLoadingState extends SearchStates {}

final class SearchFailedState extends SearchStates {}

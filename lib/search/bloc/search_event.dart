part of 'search_bloc.dart';

class SearchEvents {}

class SearchEvent extends SearchEvents {
  final String value;

  SearchEvent({required this.value});
}

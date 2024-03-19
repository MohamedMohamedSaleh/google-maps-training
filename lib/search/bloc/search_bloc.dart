import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_test/search/model/search_model.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvents, SearchStates> {
  SearchBloc() : super(SearchStates()) {
    on<SearchEvent>(_search);
  }

  List<Results> list = [];
  static String key =
      '5b3ce3597851110001cf62489f19cc96d92e42cab0301b827f94e7d5';
  Future<void> _search(SearchEvent event, Emitter<SearchStates> emit) async {
    list.clear();
    emit(SearchLoadingState());
    try {
      final response = await Dio().get(
        'https://api.openrouteservice.org/geocode/search?api_key=$key&text=${event.value}',
      );
      final model = SearchModel.fromJson(response.data);
      list = model.results;
      print(model.results[0].name);
      print(model.results.length);
      // print(model.results[1].name);
      emit(SearchSuccessState(list: model.results));
    } on DioException catch (ex) {
      print(ex.message.toString());
      emit(SearchFailedState());
    }
  }
}

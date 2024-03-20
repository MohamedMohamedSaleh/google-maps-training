import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_test/services/model.dart';

part 'get_address_event.dart';
part 'get_address_state.dart';

class GetAddressBloc extends Bloc<GetAddressEvent, GetAddressStates> {
  GetAddressBloc() : super(GetAddressStates()) {
    on<GetAddressEvent>(_getAddress);
  }
  static GetAddressBloc get(context) => BlocProvider.of(context);
  List<AddressModel> list = [];
  void showMessage() {}
  Future<void> _getAddress(
      GetAddressEvent event, Emitter<GetAddressStates> emit) async {
    try {
      final response =
          await Dio(BaseOptions(headers: {
            'Authorization' : "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvdGhpbWFyLmFtci5hYWl0LWQuY29tXC9hcGlcL2xvZ2luIiwiaWF0IjoxNzA3Mzc0MTI2LCJleHAiOjE3Mzg5MTAxMjYsIm5iZiI6MTcwNzM3NDEyNiwianRpIjoiNXhIVEJLQW9EcHdsR3NxbSIsInN1YiI6NDU1LCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.9iXO8y9fgu2Ha1FTYkdrK2PjrBGBt0ikekOgxFk8DEQ"
          })).get('https://thimar.amr.aait-d.com/api/client/addresses');
      final model = AddressData.fromJson(response.data);
      list = model.list;
      print(list[0].location);
    } on DioException catch (ex) {
      print("ex.response!.data['message']");
    }
  }
}

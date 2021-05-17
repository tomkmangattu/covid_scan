import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'userdata_state.dart';

class UserdataCubit extends Cubit<UserdataState> {
  UserdataCubit() : super(UserdataInitial());

  void uploadData() async {
    emit(UserdataLoading());
  }
}

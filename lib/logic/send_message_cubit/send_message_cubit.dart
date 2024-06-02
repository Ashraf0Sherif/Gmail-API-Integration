import 'package:bloc/bloc.dart';
import 'package:freelancing/repositories/my_repo.dart';
import 'package:meta/meta.dart';

import '../../firebase/firebase_exceptions.dart';

part 'send_message_state.dart';

class SendMessageCubit extends Cubit<SendMessageState> {
  SendMessageCubit(this.myRepo) : super(SendMessageInitial());
  final MyRepo myRepo;

  void sendMessage(
      {required String email,
      required String body,
      required String title}) async {
    var response =
        await myRepo.sendMessage(toEmail: email, body: body, title: title);
    response.when(
      success: (message) {
        emit(SendMessageSuccess());
      },
      failure: (FirebaseExceptions firebaseExceptions) {
        emit(SendMessageFailure(
            FirebaseExceptions.getErrorMessage(firebaseExceptions)));
      },
    );
  }
}

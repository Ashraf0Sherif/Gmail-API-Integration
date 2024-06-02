part of 'send_message_cubit.dart';

@immutable
abstract class SendMessageState {}

class SendMessageInitial extends SendMessageState {}

class SendMessageSuccess extends SendMessageState {}

class SendMessageFailure extends SendMessageState {
  String errorMessage;

  SendMessageFailure(this.errorMessage);
}

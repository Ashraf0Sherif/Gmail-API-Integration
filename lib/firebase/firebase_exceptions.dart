import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'firebase_exceptions.freezed.dart';

@freezed
abstract class FirebaseExceptions with _$FirebaseExceptions {
  const factory FirebaseExceptions.emailAlreadyExists() = EmailAlreadyExists;

  const factory FirebaseExceptions.invalidToHeader() = InvalidToHeader;

  const factory FirebaseExceptions.invalidCredential() = InvalidCredential;

  const factory FirebaseExceptions.formatException() = FormatException;

  const factory FirebaseExceptions.noInternetConnection() =
      NoInternetConnection;

  const factory FirebaseExceptions.unexpectedError() = UnexpectedError;

  static FirebaseExceptions getFirebaseException(error) {
    if (error is Exception) {
      try {
        FirebaseExceptions firebaseExceptions;
        if (error is FirebaseAuthException) {
          switch (error.code) {
            case "invalid-credential":
              firebaseExceptions = const FirebaseExceptions.invalidCredential();
              break;
            case "email-already-in-use":
              firebaseExceptions =
                  const FirebaseExceptions.emailAlreadyExists();
              break;
            case "No Internet Connection":
              firebaseExceptions =
                  const FirebaseExceptions.noInternetConnection();
              break;
            default:
              firebaseExceptions =
                  const FirebaseExceptions.noInternetConnection();
              break;
          }
        } else if (error is SocketException) {
          firebaseExceptions = const FirebaseExceptions.noInternetConnection();
        } else {
          firebaseExceptions = const FirebaseExceptions.unexpectedError();
        }
        return firebaseExceptions;
      } on FormatException {
        return const FirebaseExceptions.formatException();
      } catch (_) {
        return const FirebaseExceptions.unexpectedError();
      }
    } else {
      return const FirebaseExceptions.unexpectedError();
    }
  }

  static String getErrorMessage(FirebaseExceptions firebaseExceptions) {
    var errorMessage = "";
    firebaseExceptions.when(
      invalidCredential: () =>
          errorMessage = "Something wrong , check your email",
      formatException: () => errorMessage = "Unexpected error occurred",
      noInternetConnection: () => errorMessage = "No internet connection",
      unexpectedError: () => errorMessage = "Unexpected error occurred",
      emailAlreadyExists: () =>
          errorMessage = "There is already an user with this email",
      invalidToHeader: () => "Something wrong , check your email",
    );
    return errorMessage;
  }
}

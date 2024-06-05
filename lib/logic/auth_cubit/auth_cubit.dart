import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freelancing/firebase/firebase_exceptions.dart';
import 'package:meta/meta.dart';

import '../../repositories/my_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.myRepo) : super(AuthInitial());
  final MyRepo myRepo;

  void signInWithGoogle() async {
    emit(AuthLoading());
    var response = await myRepo.signInWithGoogle();
    response.when(success: (credential) {
      emit(AuthSuccess(credential));
    }, failure: (FirebaseExceptions firebaseExceptions) {
      emit(AuthFailure(FirebaseExceptions.getErrorMessage(firebaseExceptions)));
    });
  }

  void signOut() async {
    emit(AuthLoading());
    var response = await myRepo.signOut();
    response.when(success: (nothing) {
      print("555");
      emit(AuthInitial());
    }, failure: (FirebaseExceptions firebaseExceptions) {
      emit(AuthFailure(FirebaseExceptions.getErrorMessage(firebaseExceptions)));
    });
  }
}

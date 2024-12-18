import 'package:bloc/bloc.dart';
import 'package:chatapp/modes/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> register(var email,var  password, var name) async {
    String a=email.text;
    String b=password.text;
    String c=name.text; 
    emit(RegisterLoading());
    try {
     UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: a,
        password: b,
      );
       userCredential.user!.updateDisplayName(c);
      FirebaseFirestore.instance
          .collection('user')
          .add(Users(email: a, name: c).usertomap());
          email.clear();
          password.clear();
          name.clear();
      emit(RegisterSuccess()); 
    } on FirebaseAuthException catch (e) {
      
      emit(RegisterFailed(e.message ?? 'An error occurred during registration.'));
    } catch (e) {
      emit(RegisterFailed('There was an error. Please try again.'));
    }
  }
}
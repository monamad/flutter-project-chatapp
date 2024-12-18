import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
void login( var email, var password) async {
  emit(LoginLoading());
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.text,
      password: password.text,
    );
    email.clear();
    password.clear(); 
      emit(LoginSuccess());
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      emit(LoginFailed('No user found for that email.'));
    } else if (e.code == 'wrong-password') {
      emit(LoginFailed('Wrong password provided for that user.'));
    } else {
      emit(LoginFailed('An error occurred'));
    }
    emit(LoginFailed(e.message!));
  }
   catch (e) {
    emit(LoginFailed('An error occurred'));
   }
   }
   void logout() async {
     await FirebaseAuth.instance.signOut();
     emit(LoginInitial());
   }
}
// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:chatapp/cubits/login_cubit/login_cubit.dart';
import 'package:chatapp/pages/register_page.dart';
import 'package:chatapp/utils/ustils.dart';
import 'package:chatapp/widgets/botton.dart';
import 'package:chatapp/widgets/custom_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
    static String id = 'LoginPage';

  final emailController = TextEditingController();
  bool isLoding = false;
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xff2a2845),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 8, left: 8, top: 10),
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginLoading) {
                
                isLoding = true;
              }
              if (state is LoginFailed) {
                isLoding = false;
               MyUtils.showmassage(context, state.error);


              }
              if (state is LoginSuccess) {
                isLoding = false;
                Navigator.pushNamed(context, 'friendspage');
                
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Center(
                      child: Image.asset(('lib/assets/images/scholar.png')),
                    ),
                    Center(
                      child: Text(
                        "chatapp",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.purple[600],
                            fontFamily: "pacifico"),
                      ),
                    ),
                    const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    CustomFormTextField(
                      myController: emailController,
                      hint: 'Email',
                      ontap: (email) {},
                      isPassword: false,
                    ),
                    CustomFormTextField(
                      myController: passwordController,
                      isPassword: true,
                      hint: 'password',
                      ontap: (pass) {},
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: CustomButton(
                        text_size: 22,
                        isloding: isLoding,
                        text: 'login',
                        ontap: () async {
                          if (_formKey.currentState!.validate()) {  
                            BlocProvider.of<LoginCubit>(context).login(
                                emailController, passwordController);
                        }
                        }, isLoading: true,
                     )
                    ),
                    Center(
      child: Text.rich(
        TextSpan(
          children: [
            const TextSpan(
              text: "Don't have an account?  ",
              style: TextStyle(color: Colors.white),
            ),
            TextSpan(
              text: 'Sign Up',
              style: const TextStyle(color: Colors.pinkAccent),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushNamed(context, RegisterPage.id);
                },
            ),
          ],
        ),
      ),
    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: must_be_immutable,

import 'package:chatapp/cubits/register_cubit/cubit/register_cubit.dart';
import 'package:chatapp/pages/login_page.dart';
import 'package:chatapp/utils/ustils.dart';
import 'package:chatapp/widgets/botton.dart';
import 'package:chatapp/widgets/custom_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatelessWidget {
  static String id = 'RegisterPage';
  final emailController = TextEditingController();
  final namecontroller = TextEditingController();

  final passwordController = TextEditingController();

  final repasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? pass;
  String? name;


  bool isloding = false;

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff2a2845),
      body: Padding(
        padding: const EdgeInsets.only(right: 8, left: 8, top: 60, bottom: 20),
        child: BlocConsumer<RegisterCubit, RegisterState>(
         listener: (context, state) {
            if (state is RegisterLoading) {          
                isloding = true;
       
            } else if (state is RegisterSuccess) {  
                isloding = false;
                Navigator.pushNamed(context, LoginPage.id);
            } else if (state is RegisterFailed) {       
                isloding = false;         
      MyUtils.showmassage(context, state.error);        
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
                    "Register",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                  CustomFormTextField(
                    myController: namecontroller,
                    isPassword: false,
                    ontap: (name) {
                      this.name = name;
                    },
                    hint: 'your name',
                  ),
                  CustomFormTextField(
                    myController: emailController,
                    isPassword: false,
                    ontap: (email) {},
                    hint: 'Email',
                  ),
                  CustomFormTextField(
                    myController: passwordController,
                    isPassword: true,
                    ontap: (pass) {
                     
                        this.pass = pass;
                    
                    },
                    hint: 'Password',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: CustomButton(
                      text_size: 22,
                      isloding: isloding,
                      text: 'Register',
                      ontap: () async {
                        if (_formKey.currentState!.validate()) {
                             BlocProvider.of<RegisterCubit>(context).register(
                               emailController, passwordController,
                               namecontroller);
                          }
                      }, isLoading: isloding,
                    ),
                  ),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                              text: "have an account  ",
                              style: TextStyle(color: Colors.white)),
                          TextSpan(
                              text: 'Sign in',
                              style: const TextStyle(color: Colors.purple),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                 Navigator.pushNamed(context, LoginPage.id);}
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
    );
  }
}

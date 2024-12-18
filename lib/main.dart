import 'package:chatapp/cubits/login_cubit/login_cubit.dart';
import 'package:chatapp/cubits/register_cubit/cubit/register_cubit.dart';
import 'package:chatapp/pages/friends_page.dart';
import 'package:chatapp/pages/login_page.dart';
import 'package:chatapp/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) {},
      child: const Chatapp(),
    ),
  );
}

class Chatapp extends StatelessWidget {
  const Chatapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => RegisterCubit(),
        ),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          LoginPage.id: (context) => LoginPage(),
          RegisterPage.id: (context) => RegisterPage(),
          'regueter': (context) => RegisterPage(),
          //'chatpage': (context) => ChatPage(),
          'friendspage': (context) => const FriendsPage(),
          // Add more routes here
        },
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: LoginPage(),
      ),
    );
  }
}

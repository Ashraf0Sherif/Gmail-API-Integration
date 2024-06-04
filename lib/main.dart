import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelancing/firebase/custom_firebase.dart';
import 'package:freelancing/logic/send_message_cubit/send_message_cubit.dart';
import 'package:freelancing/repositories/my_repo.dart';
import 'package:freelancing/widgets/custom_button.dart';
import 'package:freelancing/widgets/success_auth_view.dart';

import 'firebase_options.dart';
import 'logic/auth_cubit/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  CustomFirebase customFirebase = CustomFirebase();
  MyRepo myRepo = MyRepo(customFirebase);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(myRepo)),
        BlocProvider(create: (context) => SendMessageCubit(myRepo))
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    BlocProvider.of<AuthCubit>(context).signOut();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthSuccess) {
                return const SuccessAuthView();
              } else {
                return Center(
                  child: CustomButton(
                    onPressed: () {
                      BlocProvider.of<AuthCubit>(context).signInWithGoogle();
                    },
                    label: 'Login',
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

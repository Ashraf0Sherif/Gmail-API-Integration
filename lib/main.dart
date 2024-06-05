import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelancing/firebase/custom_firebase.dart';
import 'package:freelancing/logic/send_message_cubit/send_message_cubit.dart';
import 'package:freelancing/repositories/my_repo.dart';
import 'package:freelancing/widgets/custom_button.dart';
import 'package:freelancing/widgets/show_snack_bar.dart';
import 'package:freelancing/widgets/success_auth_view.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
  bool _isLoading = false;

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
        child: ModalProgressHUD(
          progressIndicator: const CircularProgressIndicator(
            color: Colors.red,
          ),
          blur: 1,
          inAsyncCall: _isLoading,
          child: Scaffold(
            body: BlocConsumer<AuthCubit, AuthState>(
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
              listener: (BuildContext context, AuthState state) {
                if (state is AuthFailure) {
                  showSnackBar(context, message: state.errorMessage);
                  setState(() {
                    _isLoading = false;
                  });
                } else if (state is AuthLoading) {
                  setState(() {
                    _isLoading = true;
                  });
                } else {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

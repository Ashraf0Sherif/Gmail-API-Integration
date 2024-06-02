import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelancing/widgets/custom_text_field.dart';
import 'package:freelancing/widgets/show_snack_bar.dart';

import '../logic/auth_cubit/auth_cubit.dart';
import '../logic/send_message_cubit/send_message_cubit.dart';

class SuccessAuthView extends StatefulWidget {
  const SuccessAuthView({super.key});

  @override
  State<SuccessAuthView> createState() => _SuccessAuthViewState();
}

class _SuccessAuthViewState extends State<SuccessAuthView> {
  String? email, body, title;
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CustomTextField(
                    hintText: "Email",
                    onChanged: (text) {
                      email = text;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    hintText: "Title",
                    onChanged: (text) {
                      title = text;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    hintText: "Body",
                    minLines: 2,
                    maxLines: 5,
                    onChanged: (text) {
                      body = text;
                    },
                  ),
                ],
              ),
            ),
            BlocListener<SendMessageCubit, SendMessageState>(
              listener: (context, state) {
                if (state is SendMessageFailure) {
                  showSnackBar(context, message: state.errorMessage);
                } else {
                  showSnackBar(context, message: "Message sent !");
                }
              },
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    BlocProvider.of<SendMessageCubit>(context)
                        .sendMessage(email: email!, body: body!, title: title!);
                  } else {
                    setState(() {});
                  }
                },
                child: const Text("Send Message"),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<AuthCubit>(context).signOut();
                },
                child: const Text("Logout"),
              ),
            ),
          ],
        ));
  }
}

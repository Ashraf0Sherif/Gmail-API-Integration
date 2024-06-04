import 'package:flutter/cupertino.dart';
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
  TextEditingController email = TextEditingController();
  TextEditingController body = TextEditingController();
  TextEditingController title = TextEditingController();

  //String? email, body, title;
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      CustomTextFormField(
                        label: 'Email',
                        onChanged: (text) {},
                        controller: email,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextFormField(
                        label: 'Title',
                        onChanged: (text) {},
                        controller: title,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextFormField(
                        label: 'Body',
                        onChanged: (text) {},
                        controller: body,
                        minLines: 3,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                BlocListener<SendMessageCubit, SendMessageState>(
                  listener: (context, state) {
                    if (state is SendMessageFailure) {
                      showSnackBar(context, message: state.errorMessage);
                    } else {
                      FocusScope.of(context).unfocus();
                      showSnackBar(context, message: "Message sent !");
                      email.clear();
                      body.clear();
                      title.clear();
                    }
                  },
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        BlocProvider.of<SendMessageCubit>(context).sendMessage(
                          email: email.text,
                          body: body.text,
                          title: title.text,
                        );
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
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return ConfirmDialog();
                        },
                      );
                    },
                    child: const Text("Logout"),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text("Logout"),
      content: const Text("Are you sure ?"),
      actions: [
        CupertinoDialogAction(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: const Text("Logout"),
          onPressed: () {
            BlocProvider.of<AuthCubit>(context).signOut();
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}

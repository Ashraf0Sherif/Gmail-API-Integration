import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/auth_cubit/auth_cubit.dart';

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

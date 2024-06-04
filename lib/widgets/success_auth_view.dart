import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelancing/widgets/custom_text_field.dart';
import 'package:freelancing/widgets/show_snack_bar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../logic/send_message_cubit/send_message_cubit.dart';
import 'confirm_dialog.dart';
import 'custom_button.dart';
import 'my_behavior.dart';

class SuccessAuthView extends StatefulWidget {
  const SuccessAuthView({super.key});

  @override
  State<SuccessAuthView> createState() => _SuccessAuthViewState();
}

class _SuccessAuthViewState extends State<SuccessAuthView> {
  TextEditingController email = TextEditingController();
  TextEditingController body = TextEditingController();
  TextEditingController title = TextEditingController();
  File? _attachment;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      List<PlatformFile> files = result.files;
      if (files.isNotEmpty) {
        PlatformFile file = files.first;
        setState(() {
          _attachment = File(file.path!);
        });
      }
    } else {
      // User canceled the picker
    }
  }

  String? _getAttachmentTitle() {
    if (_attachment != null) {
      String path = _attachment!.path;
      List<String> pathSegments = path.split('/');
      return pathSegments.last;
    }
    return null;
  }

  void _clearMessage() {
    FocusScope.of(context).unfocus();
    email.clear();
    body.clear();
    title.clear();
    setState(() {
      _attachment = null;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    const Center(
                        child: Text(
                      "Send Message",
                      style: TextStyle(
                          fontSize: 26,
                          fontFamily: "VarelaRound-Regular",
                          color: Colors.black54),
                    )),
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
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
                          minLines: 4,
                          maxLines: 4,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              _attachment != null
                                  ? Expanded(
                                      child: Text(
                                        'Attachment: ${_getAttachmentTitle()}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  : CustomButton(
                                      onPressed: _pickFile,
                                      label: 'Attach File',
                                    ),
                            ],
                          ),
                        )
                      ],
                    ),
                    BlocListener<SendMessageCubit, SendMessageState>(
                      listener: (context, state) {
                        if (state is SendMessageFailure) {
                          showSnackBar(context, message: state.errorMessage);
                          setState(() {
                            _isLoading = false;
                          });
                        } else {
                          showSnackBar(context, message: "Message sent !");
                          _clearMessage();
                        }
                      },
                      child: Center(
                        child: CustomButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<SendMessageCubit>(context)
                                  .sendMessage(
                                      email: email.text,
                                      body: body.text,
                                      title: title.text,
                                      attachment: _attachment);
                              setState(() {
                                _isLoading = true;
                              });
                            } else {
                              setState(() {});
                            }
                          },
                          label: "Send Message",
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          CustomButton(
                              label: 'Clear Message', onPressed: _clearMessage),
                          CustomButton(
                            onPressed: () {
                              showCupertinoDialog(
                                context: context,
                                builder: (context) {
                                  return const ConfirmDialog();
                                },
                              );
                            },
                            label: 'Logout',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

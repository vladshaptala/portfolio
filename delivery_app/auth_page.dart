import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:delivery/core/router/index.dart';
import 'package:delivery/styles/index.dart';
import 'package:delivery/utyls/helpers.dart';
import 'package:delivery/utyls/validators/validation_rule.dart';
import 'package:delivery/views/auth/bloc/auth_cubit.dart';
import 'package:delivery/views/auth/bloc/auth_state.dart';
import 'package:delivery/widgets/buttons/app_button.dart';
import 'package:delivery/widgets/buttons/app_text_button.dart';
import 'package:delivery/widgets/icon/app_icon.dart';
import '../../widgets/inputs/app_input.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _keyboardController = KeyboardVisibilityController();
  final _email = TextEditingController(text: '');
  final _psw = TextEditingController(text: '');
  bool _enterBtnEnable = true;
  bool _isInputValidating = false;

  void _configEnterBtn() {
    _enterBtnEnable = _email.text.isNotEmpty && _psw.text.isNotEmpty;
    if (_isInputValidating) _formKey.currentState!.validate();
    setState(() {});
  }

  void _auth() {
    _isInputValidating = true;
    final isInputValid = _formKey.currentState!.validate();
    if (isInputValid) {
      context.read<AuthStateCubit>().auth(_email.text, _psw.text);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.primary,
      child: BlocBuilder<AuthStateCubit, AuthState>(
        builder: (context, state) => SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Material(
                  color: AppColors.backgroundGrey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AppSpacer.lg,
                        Logo(),
                        AppSpacer.lg,
                        AppInput.email(
                          params: AppInputParams(
                            controller: _email,
                            disposeController: false,
                            label: 'email'.t,
                            req: true,
                            onChange: (v) => _configEnterBtn(),
                            validator: EmailValidator(),
                            semanticLabel: "login_input",
                          ),
                        ),
                        AppSpacer.lg,
                        AppInput.password(
                          params: AppInputParams(
                            label: 'password'.t,
                            controller: _psw,
                            disposeController: false,
                            validator: PasswordValidator(
                              errorText: 'not_correct'.t,
                            ),
                            onChange: (v) => _configEnterBtn(),
                            req: true,
                            semanticLabel: "password_input",
                          ),
                        ),
                        AppSpacer.def,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppTextButton(
                              semanticLabel: "restore_password_button",
                              child: Text(
                                'restore_password'.t.toUpperCase(),
                                style: AppTextStyles.button,
                              ),
                              onTap: () {
                                RouterCore.goTo(RestorePswRoute);
                              },
                            ),
                            AppSpacer.xlg,
                          ],
                        ),
                        AppSpacer.custom(44),
                        AppButton(
                          text: 'enter'.t,
                          fullWidth: true,
                          onTap: _enterBtnEnable ? _auth() : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:auth/auth/presentation/bloc/auth_bloc.dart';
import 'package:auth/auth/presentation/bloc/auth_event.dart';
import 'package:auth/auth/presentation/bloc/auth_state.dart';
import 'package:auth/auth/presentation/pages/login_page.dart';
import 'package:auth/auth/presentation/pages/sign_up_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({
    required this.bloc,
    this.onAuthSuccess,
    super.key,
  });

  final AuthBloc bloc;
  final VoidCallback? onAuthSuccess;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _showSignUp = false;

  void _toggleView() {
    setState(() {
      _showSignUp = !_showSignUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: widget.bloc,
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          widget.onAuthSuccess?.call();
        }
      },
      child: _showSignUp
          ? SignUpPage(
              bloc: widget.bloc,
              onSignUpSuccess: () {
                setState(() {
                  _showSignUp = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Usuário criado com sucesso! Faça login.'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              },
            )
          : LoginPage(
              bloc: widget.bloc,
              onLoginSuccess: widget.onAuthSuccess,
            ),
    );
  }
}

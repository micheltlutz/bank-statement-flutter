import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:auth/auth/presentation/bloc/auth_bloc.dart';
import 'package:auth/auth/presentation/bloc/auth_event.dart';
import 'package:auth/auth/presentation/bloc/auth_state.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    required this.bloc,
    this.onSignUpSuccess,
    super.key,
  });

  final AuthBloc bloc;
  final VoidCallback? onSignUpSuccess;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _birthDateController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  DateTime? _selectedBirthDate;

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 100);
    final lastDate = DateTime(now.year - 13); // Minimum 13 years old

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? lastDate,
      firstDate: firstDate,
      lastDate: lastDate,
      locale: const Locale('pt', 'BR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: AppTheme.surfaceColor,
              onSurface: AppTheme.textPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  void _handleSignUp() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedBirthDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, selecione sua data de nascimento'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }

      widget.bloc.add(
        CreateUserEvent(
          userId: _userIdController.text.trim(),
          password: _passwordController.text,
          fullName: _fullNameController.text.trim(),
          birthDate: _selectedBirthDate!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
        backgroundColor: AppTheme.backgroundColor,
      ),
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          bloc: widget.bloc,
          listener: (context, state) {
            if (state is UserCreatedSuccess) {
              widget.onSignUpSuccess?.call();
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            bloc: widget.bloc,
            builder: (context, state) {
              final isLoading = state is AuthLoading;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),
                      // Header
                      Text(
                        'Crie sua conta',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Preencha os dados abaixo para criar sua conta',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      // Full Name Field
                      TextFormField(
                        controller: _fullNameController,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        autofocus: false,
                        decoration: InputDecoration(
                          labelText: 'Nome Completo *',
                          hintText: 'João Silva',
                          prefixIcon: const Icon(Icons.person_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: AppTheme.surfaceColor.withOpacity(0.3),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu nome completo';
                          }
                          final trimmed = value.trim();
                          if (trimmed.length < 3) {
                            return 'O nome deve ter pelo menos 3 caracteres';
                          }
                          if (trimmed.split(' ').where((s) => s.isNotEmpty).length < 2) {
                            return 'Por favor, insira nome e sobrenome';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Email/User ID Field
                      TextFormField(
                        controller: _userIdController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: 'Email *',
                          hintText: 'seu@email.com',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: AppTheme.surfaceColor.withOpacity(0.3),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu email';
                          }
                          // Validação de email mais robusta
                          final emailRegex = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          );
                          if (!emailRegex.hasMatch(value.trim())) {
                            return 'Por favor, insira um email válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Birth Date Field
                      TextFormField(
                        controller: _birthDateController,
                        readOnly: true,
                        onTap: _selectBirthDate,
                        decoration: InputDecoration(
                          labelText: 'Data de Nascimento *',
                          hintText: 'DD/MM/AAAA',
                          prefixIcon: const Icon(Icons.calendar_today_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: AppTheme.surfaceColor.withOpacity(0.3),
                          suffixIcon: const Icon(Icons.arrow_drop_down),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, selecione sua data de nascimento';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: InputDecoration(
                          labelText: 'Senha *',
                          hintText: 'Mínimo 6 caracteres',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: AppTheme.surfaceColor.withOpacity(0.3),
                          helperText: 'A senha deve ter pelo menos 6 caracteres',
                          helperMaxLines: 2,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira uma senha';
                          }
                          if (value.length < 6) {
                            return 'A senha deve ter pelo menos 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Confirm Password Field
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleSignUp(),
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: InputDecoration(
                          labelText: 'Confirmar Senha *',
                          hintText: 'Digite a senha novamente',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: AppTheme.surfaceColor.withOpacity(0.3),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, confirme sua senha';
                          }
                          if (value != _passwordController.text) {
                            return 'As senhas não coincidem';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      // Info text
                      Text(
                        '* Campos obrigatórios',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondaryColor,
                            ),
                      ),
                      const SizedBox(height: 32),
                      // Sign Up Button
                      ElevatedButton(
                        onPressed: isLoading ? null : _handleSignUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.person_add_outlined),
                                  SizedBox(width: 8),
                                  Text(
                                    'Criar Conta',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      const SizedBox(height: 16),
                      // Back to login link
                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                Navigator.of(context).pop();
                              },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.arrow_back, size: 16),
                            SizedBox(width: 4),
                            Text('Voltar para login'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


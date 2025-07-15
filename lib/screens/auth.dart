import 'package:flutter/material.dart';
import '../providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/chat.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _email = '';
  var _password = '';
  var _username = '';

  void _submit(WidgetRef ref, BuildContext context) {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    if (_isLogin) {
          final userData = ref.watch(userDataProvider);

      if (userData!.any(
        (user) => user.email == _email && user.password == _password,
      )) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => ChatScreen(
              userData: userData
                  .where(
                    (user) =>
                        user.email == _email && user.password == _password,
                  )
                  .first,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Invalid email or password')));
      }
    } else {
      ref
          .read(userDataProvider.notifier)
          .saveUserData(
            email: _email,
            password: _password,
            username: _username,
            context: context,
          );
      final userData2 = ref.watch(userDataProvider);
      print(userData2);
      print(userData2!.length);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => ChatScreen(
            userData: ref.watch(userDataProvider)!
                .where(
                  (user) => user.email == _email && user.password == _password,
                )
                .first,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  bottom: 20,
                  top: 30,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogin)
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Username',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().length < 3) {
                                  return 'Please enter a username with at least 3 characters.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _username = value!;
                              },
                            ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _email = value!;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value.trim().length < 7) {
                                return 'Password must be at least 7 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _password = value!;
                            },
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => _submit(ref, context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.onPrimary,
                            ),
                            child: Text(_isLogin ? 'Login' : 'Signup'),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(
                              _isLogin
                                  ? 'Create an account'
                                  : 'I already have an account',
                            ),
                          ),
                        ],
                      ),
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

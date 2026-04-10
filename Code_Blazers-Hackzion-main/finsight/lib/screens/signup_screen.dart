import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../services/finance_service.dart';
import '../main.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (_emailController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email and Password are required')));
      return;
    }
    if (_passController.text != _confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final Map<String, dynamic> res = await Provider.of<FinanceService>(context, listen: false).signup(
        _emailController.text.trim(),
        _passController.text,
        fullName: _nameController.text.trim(),
      );

      if (mounted) {
        if (res['access_token'] == 'verification_email_sent') {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Verify Email'),
              content: const Text('A verification email has been sent. Please confirm your email to continue.'),
              actions: [
                TextButton(onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context); // Go back to login
                }, child: const Text('OK')),
              ],
            ),
          );
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScaffold()));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: AppColors.textMain)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Account',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textMain),
              ),
              const SizedBox(height: 8),
              const Text(
                'Start your financial journey with SpendWise',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _confirmPassController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock_clock_outlined),
                ),
              ),
              const SizedBox(height: 48),
              _isLoading 
                ? const Center(child: CircularProgressIndicator(color: AppColors.accentBlue))
                : ElevatedButton(
                    onPressed: _handleSignup,
                    child: const Text('Create Account'),
                  ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? ", style: TextStyle(color: AppColors.textSecondary)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text('Login', style: TextStyle(color: AppColors.accentBlue, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

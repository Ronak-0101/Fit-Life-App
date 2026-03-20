import 'package:fit_life_app_/screens/auth/register_screen.dart';
import 'package:fit_life_app_/services/api_service.dart';
import 'package:fit_life_app_/services/auth_service.dart';
import 'package:fit_life_app_/utils/app_colors.dart';
import 'package:fit_life_app_/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obsecurePassword = true;
  String _errorMessage = '';

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final result = await AuthService.login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (result['success'] == true) {
      // Navigate to home with fade transition
      // if (!mounted) return;

      debugPrint('✅ Login successful');

      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _errorMessage = result['message'] ?? 'Login failed';
      });

      //Shake animation for error
      _showErrorShake();
    }
  }

  void _showErrorShake() {
    //Simple shake animation for error
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<bool> _checkApiConnection() async {
    try {
      debugPrint('🔍 Checking API connection...');

      final response =
          await ApiService.get(AppConstants.healthEndpoint, includeAuth: false);

      debugPrint('🌐 API Status Code: ${response.statusCode}');
      debugPrint('🌐 API URL: ${AppConstants.baseUrl}');

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ API Connection Failed');
      debugPrint('❌ Error: $e');
      debugPrint('❌ URL: ${AppConstants.baseUrl}');
      return false;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: IntrinsicHeight(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: AppColors.backgroundLogin,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FIT LIFE',
                    style: GoogleFonts.oswald(
                      fontSize: 45,
                      color: AppColors.logoColor,
                      // fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 0),
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 40,
                      color: AppColors.titleColor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Continue your fitness journey',
                    style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          // height: 500,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  'EMAIL ADDRESS',
                                  style: GoogleFonts.montserrat(
                                    color: AppColors.subtitleColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 25),
                                  fillColor: AppColors.textboxBG,
                                  prefixIcon: Icon(Icons.email_rounded),
                                  hintText: 'athelete@fitlife.com',
                                ),
                                style: const TextStyle(
                                  color: AppColors.accentColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          // height: 500,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: Row(
                                  children: [
                                    Text(
                                      'PASSWORD',
                                      style: GoogleFonts.montserrat(
                                        color: AppColors.subtitleColor,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      'FORGOT PASSWORD?',
                                      style: GoogleFonts.montserrat(
                                        color: AppColors.subtitleColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(25),
                                    ),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 25),
                                  fillColor: AppColors.textboxBG,
                                  prefixIcon: const Icon(Icons.lock),
                                  hintText: '.......',
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(
                                        () {
                                          _obsecurePassword =
                                              !_obsecurePassword;
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      _obsecurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  color: AppColors.accentColor,
                                ),
                                obscureText: _obsecurePassword,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  end: Alignment.centerRight,
                                  begin: Alignment.centerLeft,
                                  colors: [
                                    AppColors.accentColor,
                                    Color.fromARGB(255, 111, 29, 29)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              'LOGIN',
                              style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.titleColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                height: 1.5,
                                color:
                                    AppColors.subtitleColor.withOpacity(0.35),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 18),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  color: AppColors.subtitleColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 3,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1.5,
                                color:
                                    AppColors.subtitleColor.withOpacity(0.35),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(),
                              ),
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    AppColors.subtitleColor.withOpacity(0.35),
                              ),
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'CREATE ACCOUNT',
                                style: GoogleFonts.montserrat(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.titleColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'By logging in, you aggree to our Terms and Service and Privacy Policy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}

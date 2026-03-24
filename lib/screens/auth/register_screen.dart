import 'package:fit_life_app_/screens/auth/login_screen.dart';
import 'package:fit_life_app_/screens/profile/profile_screen.dart';
import 'package:fit_life_app_/services/auth_service.dart';
import 'package:fit_life_app_/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _conrirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obsecurePassword = true;
  final bool _obsecureConfirmPassword = true;
  String _errorMessage = '';
  String _successMessage = '';

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _conrirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Password does not match';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _successMessage = '';
    });

    final Map<String, dynamic> result = await AuthService.register(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      name: _nameController.text.trim(),
    );
    print('REGISTER RESPONSE: $result');

    setState(() {
      _isLoading = false;
    });

    if (result['success'] == true) {
      setState(() {
        _successMessage = result['message'] ?? 'Registration successfull';
      });

      // Show success dialog and navigate to login
      _showSuccessDialog();
    } else {
      setState(() {
        _errorMessage = result['message'] ?? 'Something went wrong';
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 50,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Registration Successfull',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(_successMessage),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
            child: const Text("Go to Login"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            textAlign: TextAlign.left,
            'FIT LIFE',
            style: GoogleFonts.oswald(
              fontSize: 30,
              color: AppColors.logoColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: AppColors.background,
        ),
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Image.asset(
                'assets/images/register_bg/Register_screen_BG.jpeg',
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                // fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation<double>(0.5),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 40,
                  bottom: 40,
                  left: 10,
                  right: 10,
                ),
                child: Column(
                  children: [
                    Text(
                      'ELEVATE YOUR STANDARD',
                      style: GoogleFonts.montserrat(
                        color: AppColors.logoColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text.rich(
                      TextSpan(
                        text: 'Join the ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                          color: AppColors.titleColor,
                        ),
                        children: [
                          TextSpan(
                            text: 'Elite',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 50,
                              color: AppColors.logoColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Start your fitness journey today with \n world-class programming.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.subtitleColor,
                        fontSize: 20,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: AppColors.registerContainerBG,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 25, horizontal: 10),
                                    prefixIcon: Icon(
                                      Icons.person,
                                    ),
                                    prefixIconColor: AppColors.subtitleColor,
                                    hintText: 'Full Name',
                                    hintStyle: TextStyle(
                                        color: AppColors.subtitleColor),
                                    fillColor: AppColors.registerTxtField,
                                  ),
                                  style: const TextStyle(
                                    color: AppColors.accentColor,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                    ),
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 20),
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                    ),
                                    prefixIconColor: AppColors.subtitleColor,
                                    hintText: 'Email',
                                    hintStyle: TextStyle(
                                        color: AppColors.subtitleColor),
                                    fillColor: AppColors.registerTxtField,
                                  ),
                                  style: const TextStyle(
                                    color: AppColors.accentColor,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 10),
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                    ),
                                    prefixIconColor: AppColors.subtitleColor,
                                    hintText: 'Password',
                                    hintStyle: const TextStyle(
                                        color: AppColors.subtitleColor),
                                    fillColor: AppColors.registerTxtField,
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
                                const SizedBox(height: 15),
                                TextFormField(
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 10),
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                    ),
                                    prefixIconColor: AppColors.subtitleColor,
                                    hintText: 'Confirm Password',
                                    hintStyle: const TextStyle(
                                        color: AppColors.subtitleColor),
                                    fillColor: AppColors.registerTxtField,
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obsecurePassword =
                                              !_obsecurePassword;
                                        });
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
                                const SizedBox(height: 30),
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
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Text(
                                      'CREATE ACCOUNT',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.titleColor,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Text(
                                  'OR CONTINUE WITH',
                                  style: GoogleFonts.montserrat(
                                    color: AppColors.subtitleColor,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade800,
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.logo_dev),
                                              const SizedBox(width: 7),
                                              Text(
                                                'GOOGLE',
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.titleColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade800,
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.logo_dev),
                                              const SizedBox(width: 7),
                                              Text(
                                                'APPLE',
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.titleColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text.rich(
                                    TextSpan(
                                      text: 'Already have an account? ',
                                      style: TextStyle(
                                        color: AppColors.subtitleColor,
                                        fontSize: 15,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'Login',
                                          style: TextStyle(
                                            color: AppColors.logoColor,
                                            fontSize: 15,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(
                        text: 'BY JOINING FIT LIFE. YOUR AGREE TO OUR\n',
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          color: AppColors.subtitleColor.withOpacity(0.5),
                        ),
                        children: [
                          TextSpan(
                            text: 'TERMS OF SERVICE',
                            style: const TextStyle(
                              color: AppColors.subtitleColor,
                              fontSize: 13,
                              // fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: ' & ',
                                style: TextStyle(
                                  color: AppColors.subtitleColor
                                      .withOpacity(0.5),
                                  fontSize: 13,
                                  // fontWeight: FontWeight.bold,
                                ),
                                children: const [
                                  TextSpan(
                                    text: 'PRIVACY POLICY',
                                    style: TextStyle(
                                      color: AppColors.subtitleColor,
                                      fontSize: 13,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _conrirmPasswordController.dispose();
    super.dispose();
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/connectivity_service.dart';
import '../user_state.dart';
import '../utils/diagnostics.dart';

class LoginPage extends StatefulWidget {
  final String language;

  const LoginPage({
    Key? key,
    required this.language,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String _errorMessage = '';

  // Text values based on language
  String get _loginText => widget.language == 'Filipino' ? 'Mag-login' : 'Login';
  String get _emailText => widget.language == 'Filipino' ? 'Email' : 'Email';
  String get _passwordText => widget.language == 'Filipino' ? 'Password' : 'Password';
  String get _createAccountText => widget.language == 'Filipino' ? 'Gumawa ng account' : 'Create an account';
  String get _forgotPasswordText => widget.language == 'Filipino' ? 'Nakalimutan ang password?' : 'Forgot password?';
  String get _emailErrorText => widget.language == 'Filipino' ? 'Mangyaring maglagay ng wastong email' : 'Please enter a valid email';
  String get _passwordErrorText => widget.language == 'Filipino' ? 'Password ay kinakailangan' : 'Password is required';
  String get _noInternetText => widget.language == 'Filipino' ? 'Walang koneksyon sa internet' : 'No internet connection';
  String get _loginFailedText => widget.language == 'Filipino' ? 'Hindi makapasok. Pakisubukang muli.' : 'Login failed. Please try again.';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<bool> _checkInternetConnection() async {
    try {
      DiagnosticsService.log('Login', 'Checking internet connection');
      
      final hasConnection = await ConnectivityService.hasInternetConnection();
      
      if (!hasConnection) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _noInternetText,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        DiagnosticsService.log('Login', 'No internet connection detected');
      } else {
        DiagnosticsService.log('Login', 'Internet connection available');
      }
      
      return hasConnection;
    } catch (e) {
      DiagnosticsService.logError('Login', 'Error checking internet connection: $e');
      // Return true to allow login attempt even if connectivity check fails
      return true;
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    if (!(await _checkInternetConnection())) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    
    try {
      DiagnosticsService.log('Login', 'Attempting login for user: ${_emailController.text}');
      
      final authService = AuthService();
      final user = await authService.signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
      
      if (user != null) {
        DiagnosticsService.log('Login', 'Login successful for user: ${user.email}');
        
        // Update UserState
        await UserState.instance.setLoggedIn(true);
        await UserState.instance.setUserEmail(user.email ?? '');
        await UserState.instance.setUserFullName(user.displayName ?? '');
        await UserState.instance.setUid(user.uid);
        
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        DiagnosticsService.log('Login', 'Login failed - user is null');
        setState(() {
          _isLoading = false;
          _errorMessage = _loginFailedText;
        });
      }
    } catch (e) {
      DiagnosticsService.logError('Login', 'Login error: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().contains('Exception:') 
            ? e.toString().split('Exception: ')[1] 
            : _loginFailedText;
      });
    }
  }

  void _navigateToCreateAccount() {
    Navigator.pushNamed(context, '/create_account');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DIWA',
          style: TextStyle(
            color: Colors.brown,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF8F4E1),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 500.0 : double.infinity,
            ),
            child: Card(
              elevation: 4.0,
              shadowColor: Colors.brown.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // App logo
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.brown.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'D',
                            style: TextStyle(
                              color: Colors.brown,
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Login heading
                      Text(
                        _loginText,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Error message
                      if (_errorMessage.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            _errorMessage,
                            style: TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      if (_errorMessage.isNotEmpty) const SizedBox(height: 24),
                      
                      // Email field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: _emailText,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.email, color: Colors.brown),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty || !value.contains('@')) {
                            return _emailErrorText;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Password field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: _passwordText,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.lock, color: Colors.brown),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              color: Colors.brown,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return _passwordErrorText;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      
                      // Login button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: _isLoading 
                              ? Container(
                                  width: 24,
                                  height: 24,
                                  padding: const EdgeInsets.all(2.0),
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Icon(Icons.login),
                          label: Text(
                            _loginText,
                            style: const TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _isLoading ? null : _handleLogin,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Create account button
                      TextButton.icon(
                        icon: const Icon(Icons.person_add),
                        label: Text(_createAccountText),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.brown,
                        ),
                        onPressed: _isLoading ? null : _navigateToCreateAccount,
                      ),
                      
                      // Debug information in debug mode
                      if (kDebugMode) ...[
                        const Divider(height: 32),
                        Text(
                          'Debug Info: ${kIsWeb ? 'Web Platform' : 'Mobile Platform'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
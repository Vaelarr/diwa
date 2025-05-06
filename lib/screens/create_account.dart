import 'package:flutter/material.dart';
import '../user_state.dart';
import '../main.dart'; // Import for ResponsiveUtil
import '../services/connectivity_service.dart'; // Add import for connectivity service

class CreateAccountScreen extends StatefulWidget {
  final String language;
  
  const CreateAccountScreen({
    super.key,
    required this.language,
  });

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  
  bool _nameFieldTouched = false;
  bool _emailFieldTouched = false;
  bool _passwordFieldTouched = false;
  bool _confirmPasswordFieldTouched = false;

  String get _appBarTitle => widget.language == 'Filipino' ? 'Gumawa ng Account' : 'Create Account';
  String get _fullNameLabel => widget.language == 'Filipino' ? 'Buong Pangalan' : 'Full Name';
  String get _emailLabel => widget.language == 'Filipino' ? 'E-mail' : 'Email';
  String get _passwordLabel => widget.language == 'Filipino' ? 'Password' : 'Password';
  String get _confirmPasswordLabel => widget.language == 'Filipino' ? 'Kumpirmahin ang Password' : 'Confirm Password';
  String get _createAccountButtonText => widget.language == 'Filipino' ? 'Gumawa ng Account' : 'Create Account';
  String get _alreadyHaveAccountText => widget.language == 'Filipino' ? 'May account na? Mag-login' : 'Already have an account? Login';
  String get _accountCreatedSuccessText => widget.language == 'Filipino' 
      ? 'Matagumpay na nalikha ang iyong account!' 
      : 'Account created successfully!';
  String get _accountCreationFailedText => widget.language == 'Filipino' 
      ? 'Hindi matagumpay ang paglikha ng account. Pakisubukang muli.' 
      : 'Failed to create account. Please try again.';
  String get _noInternetText => widget.language == 'Filipino'
      ? 'Walang koneksyon sa internet. Pakisubukang muli.'
      : 'No internet connection. Please try again.';
  
  void _validateName() {
    if (!_nameFieldTouched) return;
    
    final name = _nameController.text.trim();
    setState(() {
      if (name.isEmpty) {
        _nameError = widget.language == 'Filipino'
            ? 'Mangyaring ilagay ang iyong pangalan'
            : 'Please enter your name';
      } else if (name.length < 2) {
        _nameError = widget.language == 'Filipino'
            ? 'Masyadong maikli ang pangalan'
            : 'Name is too short';
      } else {
        _nameError = null;
      }
    });
  }
  
  void _validateEmail() {
    if (!_emailFieldTouched) return;
    
    final email = _emailController.text.trim();
    setState(() {
      if (email.isEmpty) {
        _emailError = widget.language == 'Filipino'
            ? 'Mangyaring ilagay ang iyong email'
            : 'Please enter your email';
      } else if (!email.contains('@') || !email.contains('.')) {
        _emailError = widget.language == 'Filipino'
            ? 'Hindi wastong format ng email'
            : 'Invalid email format';
      } else {
        _emailError = null;
      }
    });
  }
  
  void _validatePassword() {
    if (!_passwordFieldTouched) return;
    
    final password = _passwordController.text;
    setState(() {
      if (password.isEmpty) {
        _passwordError = widget.language == 'Filipino'
            ? 'Mangyaring ilagay ang password'
            : 'Please enter a password';
      } else if (password.length < 6) {
        _passwordError = widget.language == 'Filipino'
            ? 'Ang password ay dapat hindi bababa sa 6 na character'
            : 'Password must be at least 6 characters';
      } else if (!RegExp(r'\d').hasMatch(password)) {
        _passwordError = widget.language == 'Filipino'
            ? 'Ang password ay dapat may kahit isang numero'
            : 'Password must contain at least one number';
      } else {
        _passwordError = null;
      }
      
      if (_confirmPasswordFieldTouched) {
        _validateConfirmPassword();
      }
    });
  }
  
  void _validateConfirmPassword() {
    if (!_confirmPasswordFieldTouched) return;
    
    final confirmPassword = _confirmPasswordController.text;
    setState(() {
      if (confirmPassword.isEmpty) {
        _confirmPasswordError = widget.language == 'Filipino'
            ? 'Mangyaring kumpirmahin ang iyong password'
            : 'Please confirm your password';
      } else if (confirmPassword != _passwordController.text) {
        _confirmPasswordError = widget.language == 'Filipino'
            ? 'Hindi magkatugma ang mga password'
            : 'Passwords do not match';
      } else {
        _confirmPasswordError = null;
      }
    });
  }
  
  Future<bool> _checkInternetConnection() async {
    try {
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
      }
      
      return hasConnection;
    } catch (e) {
      debugPrint('Error checking internet connection: $e');
      return true;
    }
  }
  
  @override
  void initState() {
    super.initState();
    _nameError = null;
    _emailError = null;
    _passwordError = null;
    _confirmPasswordError = null;

    _nameController.addListener(_validateName);
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validateConfirmPassword);
  }
  
  @override
  void dispose() {
    _nameController.removeListener(_validateName);
    _emailController.removeListener(_validateEmail);
    _passwordController.removeListener(_validatePassword);
    _confirmPasswordController.removeListener(_validateConfirmPassword);
    
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveUtil.isTablet(context);
    final padding = ResponsiveUtil.getResponsivePadding(context: context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4E1),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.brown.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                'D',
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: isTablet ? 32 : 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'DIWA',
              style: TextStyle(
                color: Colors.brown,
                fontSize: isTablet ? 32 : 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.brown.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.brown),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        toolbarHeight: isTablet ? 90 : 70,
      ),
      body: SingleChildScrollView(
        padding: padding,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 600.0 : double.infinity,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Create Account header text
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.brown.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _appBarTitle.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                // Main form card
                Card(
                  elevation: 4,
                  shadowColor: Colors.brown.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.brown.withOpacity(0.8),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.brown.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.person_add,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          _buildInputField(
                            controller: _nameController,
                            label: _fullNameLabel,
                            icon: Icons.person,
                            errorText: _nameError,
                            textCapitalization: TextCapitalization.words,
                            onChanged: (value) {
                              setState(() {
                                _nameFieldTouched = true;
                                _validateName();
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          _buildInputField(
                            controller: _emailController,
                            label: _emailLabel,
                            icon: Icons.email,
                            errorText: _emailError,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              setState(() {
                                _emailFieldTouched = true;
                                _validateEmail();
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          _buildInputField(
                            controller: _passwordController,
                            label: _passwordLabel,
                            icon: Icons.lock,
                            errorText: _passwordError,
                            obscureText: _obscurePassword,
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
                            onChanged: (_) => _validatePassword(),
                            onTap: () {
                              if (!_passwordFieldTouched) {
                                setState(() => _passwordFieldTouched = true);
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          _buildInputField(
                            controller: _confirmPasswordController,
                            label: _confirmPasswordLabel,
                            icon: Icons.lock_outline,
                            errorText: _confirmPasswordError,
                            obscureText: _obscureConfirmPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                color: Colors.brown,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                            ),
                            onChanged: (_) => _validateConfirmPassword(),
                            onTap: () {
                              if (!_confirmPasswordFieldTouched) {
                                setState(() => _confirmPasswordFieldTouched = true);
                              }
                            },
                          ),
                          const SizedBox(height: 24),
                          
                          // Password requirements card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.brown.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.brown.withOpacity(0.1)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.brown.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.info_outline,
                                        color: Colors.brown,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      widget.language == 'Filipino' 
                                          ? 'Mga Kinakailangan sa Password:' 
                                          : 'Password Requirements:',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                _buildRequirementItem(
                                  widget.language == 'Filipino'
                                      ? 'Hindi bababa sa 6 na character'
                                      : 'At least 6 characters',
                                  _passwordController.text.length >= 6,
                                ),
                                const SizedBox(height: 4),
                                _buildRequirementItem(
                                  widget.language == 'Filipino'
                                      ? 'Dapat may kahit isang numero'
                                      : 'Must include at least one number',
                                  RegExp(r'\d').hasMatch(_passwordController.text),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Create Account button
                          ElevatedButton(
                            onPressed: _isLoading ? null : () => _handleCreateAccount(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 2,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    _createAccountButtonText,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Already have account row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.language == 'Filipino' 
                          ? 'May account na?' 
                          : 'Already have an account?'
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.brown,
                      ),
                      child: Text(
                        widget.language == 'Filipino' ? 'Mag-login' : 'Login',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? errorText,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    Function(String)? onChanged,
    Function()? onTap,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        prefixIcon: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.brown.withOpacity(0.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
          ),
          child: Icon(icon, color: Colors.brown),
        ),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.brown.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.brown.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.brown, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
  
  Widget _buildRequirementItem(String text, bool isMet) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.circle_outlined,
          color: isMet ? Colors.green : Colors.grey,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: isMet ? Colors.green[700] : Colors.grey[700],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Future<void> _handleCreateAccount() async {
    setState(() {
      _nameFieldTouched = true;
      _emailFieldTouched = true;
      _passwordFieldTouched = true;
      _confirmPasswordFieldTouched = true;
    });
    
    _validateName();
    _validateEmail();
    _validatePassword();
    _validateConfirmPassword();
    
    if (_nameError != null || _emailError != null || 
        _passwordError != null || _confirmPasswordError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.language == 'Filipino'
                ? 'May mga error sa form. Mangyaring ayusin muna ang mga ito.'
                : 'There are errors in the form. Please fix them first.'
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    final hasInternet = await _checkInternetConnection();
    if (!hasInternet) return;
    
    setState(() {
      _isLoading = true;
    });
    
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    
    // Show loading dialog with animated progress indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF8F4E1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
              ),
              const SizedBox(height: 24),
              Text(
                widget.language == 'Filipino'
                    ? 'Gumagawa ng account...'
                    : 'Creating your account...',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
    
    try {
      // Check if email already exists
      final userExists = await UserState.instance.checkIfUserExists(email);
      
      if (userExists) {
        if (mounted) {
          Navigator.of(context).pop(); // Close the loading dialog
          setState(() => _isLoading = false);
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.language == 'Filipino'
                    ? 'Ang email na ito ay ginagamit na. Mangyaring gumamit ng ibang email.'
                    : 'This email is already in use. Please use a different email.'
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      
      final success = await UserState.instance.register(
        name, 
        email, 
        password,
      );
      
      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }
      
      setState(() {
        _isLoading = false;
      });
      
      if (success) {
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_accountCreatedSuccessText),
            backgroundColor: Colors.green,
          ),
        );
        
        // Show account creation successful dialog with animation
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color(0xFFF8F4E1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), 
              ),
              title: Text(
                widget.language == 'Filipino'
                    ? 'Matagumpay na Paglikha ng Account!'
                    : 'Account Created Successfully!',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 70,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.language == 'Filipino'
                        ? 'Ire-redirect ka sa login page...'
                        : 'Redirecting you to login page...',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(
                    height: 6,
                    child: LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
                      backgroundColor: Colors.brown,
                    ),
                  ),
                ],
              ),
            );
          },
        );
        
        // Delay before redirecting to login page with the email pre-filled
        Future.delayed(const Duration(seconds: 3), () async {
          if (!mounted) return;
          Navigator.of(context).pop(); // Close the success dialog
          
          // Logout first to ensure clean state for login
          await UserState.instance.logout();
          
          // Navigate to login page with email
          Navigator.pushNamedAndRemoveUntil(
            context, 
            '/login',
            (route) => false,
            arguments: {'prefilledEmail': email},
          );
        });
      } else {
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_accountCreationFailedText),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
        setState(() => _isLoading = false);
        
        // Show specific error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

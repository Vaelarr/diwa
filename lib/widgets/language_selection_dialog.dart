import 'package:flutter/material.dart';
import '../user_state.dart';

class LanguageSelectionDialog extends StatelessWidget {
  final Function onLanguageSelected;
  
  const LanguageSelectionDialog({
    Key? key,
    required this.onLanguageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(
        'Select Your Preferred Language\nPiliin ang Ginustong Wika',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.brown,
          fontSize: 18,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Welcome to DIWA! Please select your preferred language.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Maligayang pagdating sa DIWA! Mangyaring piliin ang iyong ginustong wika.',
            textAlign: TextAlign.center,
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 24),
          _buildLanguageOption(context, 'English'),
          const SizedBox(height: 8),
          _buildLanguageOption(context, 'Filipino'),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
    );
  }
  
  Widget _buildLanguageOption(BuildContext context, String language) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          await UserState.instance.setLanguagePreference(language);
          await UserState.instance.completeFirstLaunch();
          onLanguageSelected(language);
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          language,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

import 'package:chat_app/globla.dart';
import 'package:chat_app/Screens/sms_code_screen.dart';
import 'package:chat_app/Services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({Key? key}) : super(key: key);

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final AuthService _authService = AuthService();
  String _selectedCountry = 'Mexico';
  String _countryCode = '+52';
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              
              // Título
              const Text(
                'Enter your phone number',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.black,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Selector de país
              GestureDetector(
                onTap: () {
                  _showCountryPicker(context);
                },
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.chevron_down,
                      color: AppColors.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _selectedCountry,
                      style: const TextStyle(
                        fontSize: 16,
                        color: CupertinoColors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Campo de entrada de número de teléfono
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Text(
                      _countryCode,
                      style: const TextStyle(
                        fontSize: 16,
                        color: CupertinoColors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 1,
                      height: 24,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CupertinoTextField(
                        controller: _phoneController,
                        placeholder: 'Phone number',
                        placeholderStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 16,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          color: CupertinoColors.black,
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const BoxDecoration(),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 50),
              
              // Botón "Next"
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _isLoading ? null : _sendSmsCode,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: _isLoading
                        ? const CupertinoActivityIndicator(
                            color: CupertinoColors.white,
                          )
                        : const Text(
                            'Next',
                            style: TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Link "Go back"
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Go back',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
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

  Future<void> _sendSmsCode() async {
    if (_phoneController.text.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final phoneNumber = _countryCode + _phoneController.text;
      
      // Enviar código SMS
      final verificationId = await _authService.sendSmsCodeWithVerificationId(phoneNumber);
      
      if (!mounted) return;

      // Navegar a pantalla de código SMS
      await Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => SmsCodeScreen(
            phoneNumber: phoneNumber,
            verificationId: verificationId,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text('Error al enviar código: ${e.toString()}'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showCountryPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Select Country'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _selectedCountry = 'United States';
                _countryCode = '+1';
              });
              Navigator.pop(context);
            },
            child: const Text('United States'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _selectedCountry = 'Mexico';
                _countryCode = '+52';
              });
              Navigator.pop(context);
            },
            child: const Text('Mexico'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _selectedCountry = 'Colombia';
                _countryCode = '+57';
              });
              Navigator.pop(context);
            },
            child: const Text('Colombia'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _selectedCountry = 'España';
                _countryCode = '+34';
              });
              Navigator.pop(context);
            },
            child: const Text('España'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ),
    );
  }
}


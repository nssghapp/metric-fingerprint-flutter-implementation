import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FingerprintImplementation extends StatefulWidget {
  const FingerprintImplementation({super.key});

  @override
  State<FingerprintImplementation> createState() =>
      _FingerprintImplementationState();
}

class _FingerprintImplementationState extends State<FingerprintImplementation> {
  static const MethodChannel platform = MethodChannel(
    'com.metric.metric-sdk/fingerprint',
  );

  String _authStatus = 'Press the button to start verification.';
  bool _isLoading = false;

  Future<void> _authenticateWithFingerprint() async {
    setState(() {
      _isLoading = true;
      _authStatus = 'Initiating fingerprint scan...';
    });
    const String verificationTokenPlaceholder = "TOKEN-HERE";

    try {
      // The method name 'startFingerprintAuth' must match the one used in native code.
      final String result = await platform.invokeMethod(
        'startFingerprintAuth',
        {'verification_token': verificationTokenPlaceholder},
      );
      print('Fingerprint auth result: $result');

      setState(() {
        _authStatus = result;
        _isLoading = false;
      });
    } on PlatformException catch (e) {
      // Handle errors coming from the native side
      setState(() {
        _authStatus = "Authentication Error: ${e.message}";
        _isLoading = false;
      });
    } catch (e) {
      // Handle Dart-side errors
      setState(() {
        _authStatus = "Unknown Error: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fingerprint Verification Demo'),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Status Icon
              Icon(
                _authStatus.contains('SUCCESS')
                    ? Icons.lock_open_rounded
                    : Icons.fingerprint,
                size: 80,
                color: _authStatus.contains('SUCCESS')
                    ? Colors.green.shade600
                    : Colors.indigo,
              ),
              const SizedBox(height: 32),

              // Status Text
              Text(
                _authStatus,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: _authStatus.contains('SUCCESS')
                      ? Colors.green.shade800
                      : Colors.black87,
                ),
              ),
              const SizedBox(height: 48),

              // Action Button
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _authenticateWithFingerprint,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.security),
                label: Text(_isLoading ? 'Scanning...' : 'Verify Fingerprint'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.indigo.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Uses the native Android BiometricPrompt API via Platform Channels.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final savedNumber = prefs.getString('my_number') ?? '';
  runApp(NobabApp(savedNumber: savedNumber));
}

class NobabApp extends StatelessWidget {
  final String savedNumber;
  const NobabApp({super.key, required this.savedNumber});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'নবাব (NOBAB)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0088CC),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0088CC)),
        useMaterial3: true,
      ),
      home: savedNumber.isEmpty ? const LoginScreen() : HomeScreen(myNumber: savedNumber),
    );
  }
}

// 1. IMO Style Phone Number Registration Screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  void _login() async {
    final number = _phoneController.text.trim();
    if (number.length >= 10) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('my_number', number);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(myNumber: number)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sothik mobile number likhun!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.phone_android, size: 70, color: Color(0xFF0088CC)),
              const SizedBox(height: 16),
              const Text(
                'নবাব (NOBAB)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0088CC)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Apnar mobile number diye shuru korun (Kono Ads chara)',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.call),
                  hintText: 'Mobile Number (e.g. 017xxxxxxxx)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0088CC),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Login / Shuru Korun', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 2. IMO Main Screen (Dial Number to Call & Chat)
class HomeScreen extends StatefulWidget {
  final String myNumber;
  const HomeScreen({super.key, required this.myNumber});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _targetController = TextEditingController();

  void _startCall(bool isVideo) {
    final target = _targetController.text.trim();
    if (target.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jake call diben tar number likhun!')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          callID: [widget.myNumber, target]..sort(), // unique channel for both numbers
          userID: widget.myNumber,
          userName: widget.myNumber,
          isVideo: isVideo,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('নবাব: ${widget.myNumber}', style: const TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: const Color(0xFF0088CC),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Direct IMO Calling (No Ads)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Jake call diben tar number likhe Voice ba Video Call-e chap din:'),
            const SizedBox(height: 20),
            TextField(
              controller: _targetController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.dialpad),
                hintText: 'Receiver Phone Number',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _startCall(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.phone),
                    label: const Text('Voice Call'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _startCall(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0088CC),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.videocam),
                    label: const Text('Video Call'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 3. Real Audio/Video Call Screen
class CallPage extends StatelessWidget {
  final List<String> callID;
  final String userID;
  final String userName;
  final bool isVideo;

  const CallPage({
    super.key,
    required this.callID,
    required this.userID,
    required this.userName,
    required this.isVideo,
  });

  @override
  Widget build(BuildContext context) {
    // Demo Zego Credentials (Replace with your actual keys from zegocloud console)
    const int appID = 123456789;
    const String appSign = "abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890";

    return SafeArea(
      child: ZegoUIKitPrebuiltCall(
        appID: appID,
        appSign: appSign,
        userID: userID,
        userName: userName,
        callID: callID.join('_'),
        config: isVideo
            ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
      ),
    );
  }
}

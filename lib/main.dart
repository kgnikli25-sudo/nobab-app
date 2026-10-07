import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

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
        const SnackBar(content: Text('সঠিক মোবাইল নম্বর লিখুন!')),
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
              const Icon(Icons.mark_chat_unread_rounded, size: 80, color: Color(0xFF0088CC)),
              const SizedBox(height: 16),
              const Text(
                'নবাব (NOBAB)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0088CC)),
              ),
              const SizedBox(height: 8),
              const Text(
                'বিজ্ঞাপন-মুক্ত সরাসরি কলিং ও মেসেজিং',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 36),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone),
                  hintText: 'আপনার মোবাইল নম্বর লিখুন',
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
                child: const Text('লগইন / প্রবেশ করুন', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String myNumber;
  const HomeScreen({super.key, required this.myNumber});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _targetController = TextEditingController();

  Future<void> _makeCall(bool isVideo) async {
    final target = _targetController.text.trim();
    if (target.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('যাকে কল করবেন তার নম্বর লিখুন!')),
      );
      return;
    }

    await [Permission.camera, Permission.microphone].request();

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActiveCallScreen(
          myNumber: widget.myNumber,
          targetNumber: target,
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
              'সরাসরি IMO স্টাইল কলিং',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text('যাকে কল দিতে চান তার মোবাইল নম্বর লিখুন:'),
            const SizedBox(height: 18),
            TextField(
              controller: _targetController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.dialpad),
                hintText: 'প্রাপকের নম্বর (যেমন: 017...)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _makeCall(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.phone),
                    label: const Text('ভয়েস কল'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _makeCall(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0088CC),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.videocam),
                    label: const Text('ভিডিও কল'),
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

class ActiveCallScreen extends StatelessWidget {
  final String myNumber;
  final String targetNumber;
  final bool isVideo;

  const ActiveCallScreen({
    super.key,
    required this.myNumber,
    required this.targetNumber,
    required this.isVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFF0088CC),
                    child: Text(
                      targetNumber.isNotEmpty ? targetNumber[0] : 'U',
                      style: const TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    targetNumber,
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isVideo ? 'ভিডিও কল হচ্ছে...' : 'ভয়েস কল হচ্ছে...',
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 48.0),
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                child: const Icon(Icons.call_end, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

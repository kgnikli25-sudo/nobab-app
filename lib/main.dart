import 'package:flutter/material.dart';

void main() {
  runApp(const NobabApp());
}

class NobabApp extends StatelessWidget {
  const NobabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'নবাব - NOBAB',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Map<String, String>> dummyChats = [
    {"name": "Rahim Ahmed", "msg": "আসসালামু আলাইকুম, কেমন আছেন?", "time": "10:30 AM"},
    {"name": "Karim Ullah", "msg": "জরুরি কল দিতে পারেন।", "time": "Yesterday"},
    {"name": "Farhan Kabir", "msg": "ফাইলটি পাঠানো হয়েছে।", "time": "Monday"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('নবাব (NOBAB)', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: _currentIndex == 0 ? _buildChatList() : _buildCallList(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF1E88E5),
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'চ্যাট (Chats)'),
          BottomNavigationBarItem(icon: Icon(Icons.call_outlined), label: 'কল (Calls)'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E88E5),
        onPressed: () {},
        child: Icon(_currentIndex == 0 ? Icons.message : Icons.add_call, color: Colors.white),
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      itemCount: dummyChats.length,
      itemBuilder: (context, index) {
        final chat = dummyChats[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blueGrey,
            child: Text(chat["name"]![0], style: const TextStyle(color: Colors.white)),
          ),
          title: Text(chat["name"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(chat["msg"]!),
          trailing: Text(chat["time"]!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        );
      },
    );
  }

  Widget _buildCallList() {
    return ListView(
      children: const [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.teal,
            child: Icon(Icons.call, color: Colors.white),
          ),
          title: Text("Rahim Ahmed", style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("Incoming Call • Today, 9:15 AM"),
          trailing: Icon(Icons.phone, color: Colors.green),
        ),
      ],
    );
  }
}

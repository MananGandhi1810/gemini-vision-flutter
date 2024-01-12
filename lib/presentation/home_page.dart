import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final gemini = Gemini.instance;
  final TextEditingController _promptController = TextEditingController();
  List messages = [];
  String result = "";

  void newMessage(String text) async {
    var res = await gemini.text(text);
    setState(() {
      result = res?.output ?? "No Output";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(result),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promptController,
                    decoration: const InputDecoration(
                      label: Text("Your message"),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    newMessage(_promptController.text);
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

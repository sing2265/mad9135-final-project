import 'package:final_project/screens/movie_selection_screen.dart';
import 'package:final_project/utils/app_state.dart';
import 'package:final_project/utils/http_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnterCodeScreen extends StatefulWidget {
  const EnterCodeScreen({super.key});

  @override
  State<EnterCodeScreen> createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  int code = 0;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Enter Code',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.number,
                maxLength: 4,
                controller: _controller,
                onSubmitted: (String value) {
                  setState(() {
                    code = int.parse(value);
                  });
                },
                onChanged: (String value) {
                  setState(() {
                    code = int.parse(value);
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  _joinSession(code);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MovieSelectionScreen(),
                      ));
                },
                child: const Text('Begin'),
              ),
            ],
          ),
        ));
  }

  Future<void> _joinSession(int code) async {
    String? deviceId = Provider.of<AppState>(context, listen: false).deviceId;

    final response = await HttpHelper.joinSession(deviceId, code);
    Provider.of<AppState>(context, listen: false)
        .setSessionId(response['data']['session_id']);
  }
}

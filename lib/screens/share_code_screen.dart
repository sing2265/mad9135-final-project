import 'package:final_project/screens/movie_selection_screen.dart';
import 'package:final_project/utils/app_state.dart';
import 'package:final_project/utils/http_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShareCodeScreen extends StatefulWidget {
  const ShareCodeScreen({super.key});

  @override
  State<ShareCodeScreen> createState() => _ShareCodeScreenState();
}

class _ShareCodeScreenState extends State<ShareCodeScreen> {
  String code = "Unset";

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Share Code',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            children: [
              Text('Code: $code'),
              ElevatedButton(
                onPressed: () {
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

  Future<void> _startSession() async {
    String? deviceId = Provider.of<AppState>(context, listen: false).deviceId;

    final response = await HttpHelper.startSession(deviceId);
    Provider.of<AppState>(context, listen: false)
        .setSessionId(response['data']['session_id']);

    setState(() {
      code = response['data']['code'];
    });
  }
}

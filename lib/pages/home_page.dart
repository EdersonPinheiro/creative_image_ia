import 'package:creative_image_ia/network/api_client.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _input = TextEditingController();
  bool _loading = false;
  Map<String, dynamic> responseData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        title: Text("Creative Image I.A"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: responseData.isEmpty
                ? const Center(
                    child: Text("Welcome"),
                  )
                : ListView(
                    children: [
                      Image(
                        image: NetworkImage(responseData['url']),
                        loadingBuilder: (context, child, progress) {
                          return progress?.cumulativeBytesLoaded ==
                                  progress?.expectedTotalBytes
                              ? child
                              : Container(
                                  height: 400,
                                  color: Colors.grey.shade700,
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    height: 70,
                                    width: 70,
                                    child: CircularProgressIndicator(
                                      value: progress!.cumulativeBytesLoaded /
                                          progress.expectedTotalBytes!,
                                      strokeWidth: 5,
                                    ),
                                  ),
                                );
                        },
                      ),
                      Text('data')
                    ],
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.blueGrey.shade800),
                    child: TextField(
                      controller: _input,
                      decoration: InputDecoration(
                          hintText: "Qual imagem você deseja gerar ?",
                          hintStyle: TextStyle(fontWeight: FontWeight.w300),
                          border: InputBorder.none),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                    onPressed: () {
                      _sendRequest();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey.shade800,
                        foregroundColor: Colors.white,
                        fixedSize: const Size(50, 50)),
                    child: const Icon(Icons.send))
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _sendRequest() async {
    setState(() {
      _loading = true;
    });

    final response = await ApiClient.postRequest(prompt: _input.text);
    print("API Response: $response");

    setState(() {
      _loading = false;
    });

    if (response != null) {
      setState(() {
        responseData = response;
        _input.clear();
      });
    }
  }
}

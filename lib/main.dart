import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '명언 리스트',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const QuoteListScreen(),
    );
  }
}

class QuoteListScreen extends StatelessWidget {
  const QuoteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Quote> quotes = [
      Quote(
        text: "삶이 있는 한 희망은 있다",
        author: "키케로"
      ),
      Quote(
        text: "산다는것 그것은 치열한 전투이다",
        author: "로망로랑"
      ),
      Quote(
        text: "하루에 3시간을 걸으면 7년 후에 지구를 한바퀴 돌 수 있다",
        author: "사무엘존슨"
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 명언'),
      ),
      body: ListView.builder(
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(
                quotes[index].text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '- ${quotes[index].author}',
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Quote {
  final String text;
  final String author;

  Quote({required this.text, required this.author});
}

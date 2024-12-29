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

class QuoteListScreen extends StatefulWidget {
  const QuoteListScreen({super.key});

  @override
  State<QuoteListScreen> createState() => _QuoteListScreenState();
}

class _QuoteListScreenState extends State<QuoteListScreen> {
  final List<Quote> quotes = [
    Quote(text: "삶이 있는 한 희망은 있다", author: "키케로"),
    Quote(text: "산다는것 그것은 치열한 전투이다", author: "로망로랑"),
    Quote(text: "하루에 3시간을 걸으면 7년 후에 지구를 한바퀴 돌 수 있다", author: "사무엘존슨"),
  ];

  final TextEditingController _quoteController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  void _addQuote() {
    if (_quoteController.text.isNotEmpty && _authorController.text.isNotEmpty) {
      setState(() {
        quotes.add(Quote(
          text: _quoteController.text,
          author: _authorController.text,
        ));
      });
      _quoteController.clear();
      _authorController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 명언'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
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
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  controller: _quoteController,
                  decoration: const InputDecoration(
                    labelText: '명언을 입력하세요',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _authorController,
                  decoration: const InputDecoration(
                    labelText: '작가를 입력하세요',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addQuote,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('명언 추가하기'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _quoteController.dispose();
    _authorController.dispose();
    super.dispose();
  }
}

class Quote {
  final String text;
  final String author;

  Quote({required this.text, required this.author});
}

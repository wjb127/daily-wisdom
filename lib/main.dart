import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;

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
  List<Quote> quotes = [];
  final TextEditingController _quoteController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      // 웹 환경일 때 기본 데이터로 시작
      quotes = [
        Quote(text: "삶이 있는 한 희망은 있다", author: "키케로"),
        Quote(text: "산다는것 그것은 치열한 전투이다", author: "로망로랑"),
        Quote(text: "하루에 3시간을 걸으면 7년 후에 지구를 한바퀴 돌 수 있다", author: "사무엘존슨"),
      ];
      _loadWebQuotes();
    } else {
      _loadQuotes();
    }
  }

  Future<void> _loadQuotes() async {
    final prefs = await SharedPreferences.getInstance();
    final savedQuotes = prefs.getStringList('quotes') ?? [];
    
    setState(() {
      quotes = savedQuotes.map((quoteString) {
        final quoteMap = json.decode(quoteString);
        return Quote(
          text: quoteMap['text'],
          author: quoteMap['author'],
        );
      }).toList();

      if (quotes.isEmpty) {
        quotes = [
          Quote(text: "삶이 있는 한 희망은 있다", author: "키케로"),
          Quote(text: "산다는것 그것은 치열한 전투이다", author: "로망로랑"),
          Quote(text: "하루에 3시간을 걸으면 7년 후에 지구를 한바퀴 돌 수 있다", author: "사무엘존슨"),
        ];
        _saveQuotes();
      }
    });
  }

  Future<void> _saveQuotes() async {
    final prefs = await SharedPreferences.getInstance();
    final quotesStringList = quotes.map((quote) {
      return json.encode({
        'text': quote.text,
        'author': quote.author,
      });
    }).toList();
    
    await prefs.setStringList('quotes', quotesStringList);
  }

  // 웹 환경에서의 데이터 로드
  Future<void> _loadWebQuotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedQuotes = prefs.getStringList('web_quotes');
      if (savedQuotes != null && savedQuotes.isNotEmpty) {
        setState(() {
          quotes = savedQuotes.map((quoteString) {
            final quoteMap = json.decode(quoteString);
            return Quote(
              text: quoteMap['text'],
              author: quoteMap['author'],
            );
          }).toList();
        });
      }
    } catch (e) {
      print('웹 스토리지 로드 에러: $e');
    }
  }

  // 웹 환경에서의 데이터 저장
  Future<void> _saveWebQuotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final quotesStringList = quotes.map((quote) {
        return json.encode({
          'text': quote.text,
          'author': quote.author,
        });
      }).toList();
      
      await prefs.setStringList('web_quotes', quotesStringList);
    } catch (e) {
      print('웹 스토리지 저장 에러: $e');
    }
  }

  void _addQuote() {
    if (_quoteController.text.isNotEmpty && _authorController.text.isNotEmpty) {
      setState(() {
        quotes.add(Quote(
          text: _quoteController.text,
          author: _authorController.text,
        ));
      });
      
      if (kIsWeb) {
        _saveWebQuotes();
      } else {
        _saveQuotes();
      }
      
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

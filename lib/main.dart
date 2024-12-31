import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences.dart';

// 명언과 작가 정보를 저장하는 모델 클래스
class Quote {
  final String text;    // 명언 텍스트
  final String author;  // 작가 이름

  Quote({
    required this.text,
    required this.author,
  });

  // JSON 형태로 변환하기 위한 메서드
  Map<String, dynamic> toJson() => {
        'text': text,
        'author': author,
      };

  // JSON 데이터로부터 Quote 객체를 생성하는 팩토리 생성자
  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        text: json['text'],
        author: json['author'],
      );
}

void main() {
  runApp(const MyApp());
}

// 앱의 기본 설정과 테마를 정의하는 루트 위젯
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '명언 앱',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

// 앱의 메인 화면을 구성하는 상태 위젯
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 명언 목록을 저장하는 리스트
  List<Quote> quotes = [];
  
  // 텍스트 입력을 위한 컨트롤러들
  final TextEditingController _quoteController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 앱 시작 시 저장된 명언들을 불러옴
    if (kIsWeb) {
      _loadWebQuotes();
    } else {
      _loadQuotes();
    }
  }

  // 웹용 데이터 로드 메서드
  void _loadWebQuotes() async {
    final prefs = await SharedPreferences.getInstance();
    final quotesJson = prefs.getString('quotes');
    if (quotesJson != null) {
      setState(() {
        quotes = (jsonDecode(quotesJson) as List)
            .map((item) => Quote.fromJson(item))
            .toList();
      });
    }
  }

  // 모바일용 데이터 로드 메서드
  void _loadQuotes() async {
    final prefs = await SharedPreferences.getInstance();
    final quotesJson = prefs.getString('quotes');
    if (quotesJson != null) {
      setState(() {
        quotes = (jsonDecode(quotesJson) as List)
            .map((item) => Quote.fromJson(item))
            .toList();
      });
    }
  }

  // 웹용 데이터 저장 메서드
  void _saveWebQuotes() async {
    final prefs = await SharedPreferences.getInstance();
    final quotesJson = jsonEncode(quotes.map((q) => q.toJson()).toList());
    await prefs.setString('quotes', quotesJson);
  }

  // 모바일용 데이터 저장 메서드
  void _saveQuotes() async {
    final prefs = await SharedPreferences.getInstance();
    final quotesJson = jsonEncode(quotes.map((q) => q.toJson()).toList());
    await prefs.setString('quotes', quotesJson);
  }

  // 명언 수정을 위한 다이얼로그를 표시하는 메서드
  void _editQuote(int index) {
    _quoteController.text = quotes[index].text;
    _authorController.text = quotes[index].author;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('명언 수정'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
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
          ],
        ),
        actions: [
          // 취소 버튼
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _quoteController.clear();
              _authorController.clear();
            },
            child: const Text('취소'),
          ),
          // 삭제 버튼
          TextButton(
            onPressed: () {
              setState(() {
                quotes.removeAt(index);
              });
              
              if (kIsWeb) {
                _saveWebQuotes();
              } else {
                _saveQuotes();
              }
              
              Navigator.pop(context);
              _quoteController.clear();
              _authorController.clear();
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
          // 수정 버튼
          TextButton(
            onPressed: () {
              if (_quoteController.text.isNotEmpty && 
                  _authorController.text.isNotEmpty) {
                setState(() {
                  quotes[index] = Quote(
                    text: _quoteController.text,
                    author: _authorController.text,
                  );
                });
                
                if (kIsWeb) {
                  _saveWebQuotes();
                } else {
                  _saveQuotes();
                }
                
                Navigator.pop(context);
                _quoteController.clear();
                _authorController.clear();
              }
            },
            child: const Text('수정'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('명언 앱'),
      ),
      // 명언 목록을 표시하는 ListView
      body: ListView.builder(
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(quotes[index].text),
              subtitle: Text('- ${quotes[index].author}'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _editQuote(index),
              ),
            ),
          );
        },
      ),
      // 새로운 명언을 추가하는 플로팅 버튼
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('새 명언 추가'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
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
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _quoteController.clear();
                    _authorController.clear();
                  },
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () {
                    if (_quoteController.text.isNotEmpty && 
                        _authorController.text.isNotEmpty) {
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
                      
                      Navigator.pop(context);
                      _quoteController.clear();
                      _authorController.clear();
                    }
                  },
                  child: const Text('추가'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    // 컨트롤러들의 메모리 해제
    _quoteController.dispose();
    _authorController.dispose();
    super.dispose();
  }
}

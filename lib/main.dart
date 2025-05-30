import 'package:flutter/material.dart';

void main() {
  runApp(BaccaratPredictorApp());
}

class BaccaratPredictorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '바카라 예측 앱',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '바카라 예측 앱',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController playerController = TextEditingController();
  final TextEditingController bankerController = TextEditingController();

  List<String> history = [];
  String lastWinner = '';
  String prediction = '';

  void submitGame() {
    int? playerScore = int.tryParse(playerController.text);
    int? bankerScore = int.tryParse(bankerController.text);

    if (playerScore == null || bankerScore == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('숫자를 정확히 입력해주세요.')),
      );
      return;
    }

    String winner;
    if (playerScore > bankerScore) {
      winner = 'Player';
    } else if (bankerScore > playerScore) {
      winner = 'Banker';
    } else {
      winner = 'Tie';
    }

    setState(() {
      history.add(winner);
      lastWinner = winner;
      prediction = predictNextWinner();
      playerController.clear();
      bankerController.clear();
    });
  }

  String predictNextWinner() {
    if (history.length < 10) {
      return '데이터 부족 (랜덤 예측)';
    }
    List<String> recent = history.sublist(history.length - 10);
    int playerWins = recent.where((w) => w == 'Player').length;
    int bankerWins = recent.where((w) => w == 'Banker').length;

    if (playerWins > bankerWins) {
      return 'Player';
    } else if (bankerWins > playerWins) {
      return 'Banker';
    } else {
      return ['Player', 'Banker'][DateTime.now().millisecondsSinceEpoch % 2];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('바카라 예측 앱'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: playerController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Player 점수 입력'),
            ),
            TextField(
              controller: bankerController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Banker 점수 입력'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitGame,
              child: Text('결과 입력'),
            ),
            SizedBox(height: 20),
            Text('최근 승자: $lastWinner'),
            SizedBox(height: 10),
            Text('다음 예측: $prediction'),
          ],
        ),
      ),
    );
  }
}

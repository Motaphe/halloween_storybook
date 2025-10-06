import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';
import 'dart:async';
import '../widgets/spooky_object.dart';
import '../widgets/custom_painter.dart';
import '../services/sound_manager.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _flickerController;
  late Timer _objectTimer;
  
  List<SpookyObject> objects = [];
  bool gameWon = false;
  bool gameLost = false;
  int score = 0;
  int trapsHit = 0;
  final int maxTraps = 3;
  
  final Random _random = Random();
  final SoundManager _soundManager = SoundManager();

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _flickerController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _initializeObjects();
    _startObjectSpawning();
    _soundManager.playBackgroundMusic();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _flickerController.dispose();
    _objectTimer.cancel();
    _soundManager.stopAll();
    super.dispose();
  }

  void _initializeObjects() {
    objects.clear();
    // Add the golden pumpkin (winning object)
    objects.add(SpookyObject(
      id: 'golden_pumpkin',
      type: SpookyObjectType.goldenPumpkin,
      x: _random.nextDouble() * 0.8 + 0.1,
      y: _random.nextDouble() * 0.6 + 0.2,
      size: 60,
    ));
    
    // Add some trap objects
    for (int i = 0; i < 5; i++) {
      objects.add(SpookyObject(
        id: 'trap_$i',
        type: SpookyObjectType.trap,
        x: _random.nextDouble() * 0.8 + 0.1,
        y: _random.nextDouble() * 0.6 + 0.2,
        size: 50,
      ));
    }
    
    // Add some decoy objects
    for (int i = 0; i < 8; i++) {
      objects.add(SpookyObject(
        id: 'decoy_$i',
        type: SpookyObjectType.decoy,
        x: _random.nextDouble() * 0.8 + 0.1,
        y: _random.nextDouble() * 0.6 + 0.2,
        size: 45,
      ));
    }
  }

  void _startObjectSpawning() {
    _objectTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!gameWon && !gameLost) {
        setState(() {
          // Add new moving objects
          objects.add(SpookyObject(
            id: 'moving_${DateTime.now().millisecondsSinceEpoch}',
            type: SpookyObjectType.moving,
            x: _random.nextDouble() * 0.8 + 0.1,
            y: _random.nextDouble() * 0.6 + 0.2,
            size: 40,
          ));
        });
      }
    });
  }

  void _onObjectTapped(SpookyObject object) {
    if (gameWon || gameLost) return;

    setState(() {
      if (object.type == SpookyObjectType.goldenPumpkin) {
        gameWon = true;
        score += 100;
        _soundManager.playSuccess();
        _showWinDialog();
      } else if (object.type == SpookyObjectType.trap) {
        trapsHit++;
        score -= 20;
        _soundManager.playTrap();
        if (trapsHit >= maxTraps) {
          gameLost = true;
          _showLoseDialog();
        } else {
          _showTrapDialog();
        }
      } else {
        score += 10;
        objects.remove(object);
      }
    });
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          '🎉 YOU FOUND IT! 🎉',
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Congratulations! You found the Golden Pumpkin!\nScore: $score',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetGame();
            },
            child: const Text('Play Again', style: TextStyle(color: Colors.orange)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Home', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _showLoseDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          '💀 GAME OVER! 💀',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'You hit too many traps!\nFinal Score: $score',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetGame();
            },
            child: const Text('Try Again', style: TextStyle(color: Colors.orange)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Home', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _showTrapDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          '👻 TRAP! 👻',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'You hit a trap! Traps remaining: ${maxTraps - trapsHit}',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      gameWon = false;
      gameLost = false;
      score = 0;
      trapsHit = 0;
      _initializeObjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halloween Hunt'),
        backgroundColor: const Color(0xFF1A1A1A),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'Score: $score',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D0D0D),
              Color(0xFF1A0A0A),
              Color(0xFF2D0A0A),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background
            AnimatedBuilder(
              animation: _backgroundController,
              builder: (context, child) {
                return CustomPaint(
                  painter: SpookyBackgroundPainter(_backgroundController.value),
                  size: Size.infinite,
                );
              },
            ),
            
            // Flickering effect
            AnimatedBuilder(
              animation: _flickerController,
              builder: (context, child) {
                return Container(
                  color: Colors.black.withValues(alpha: 0.1 * _flickerController.value),
                );
              },
            ),
            
            // Game objects
            ...objects.map((object) => _buildSpookyObject(object)),
            
            // Instructions
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange, width: 2),
                ),
                child: const Text(
                  'Find the Golden Pumpkin! Avoid the traps! 👻',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            
            // Lives indicator
            Positioned(
              top: 80,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Lives: ${maxTraps - trapsHit}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpookyObject(SpookyObject object) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;
    final availableHeight = screenSize.height - (isLandscape ? 100 : 200);
    
    return Positioned(
      left: object.x * (screenSize.width - object.size),
      top: object.y * availableHeight + (isLandscape ? 50 : 100),
      child: GestureDetector(
        onTap: () => _onObjectTapped(object),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: object.size.toDouble(),
          height: object.size.toDouble(),
          child: _getObjectWidget(object),
        ),
      ),
    );
  }

  Widget _getObjectWidget(SpookyObject object) {
    switch (object.type) {
      case SpookyObjectType.goldenPumpkin:
        return const Text(
          '🎃',
          style: TextStyle(fontSize: 50),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 1000.ms, color: Colors.orange)
            .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1))
            .then()
            .scale(begin: const Offset(1.1, 1.1), end: const Offset(0.9, 0.9));
            
      case SpookyObjectType.trap:
        return const Text(
          '💀',
          style: TextStyle(fontSize: 40),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .fadeIn(duration: 500.ms)
            .then()
            .fadeOut(duration: 500.ms);
            
      case SpookyObjectType.moving:
        return const Text(
          '🦇',
          style: TextStyle(fontSize: 35),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .moveX(begin: -10, end: 10, duration: 1000.ms)
            .then()
            .moveX(begin: 10, end: -10, duration: 1000.ms);
            
      case SpookyObjectType.decoy:
        return const Text(
          '👻',
          style: TextStyle(fontSize: 40),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .fadeIn(duration: 2000.ms)
            .then()
            .fadeOut(duration: 2000.ms);
    }
  }
}

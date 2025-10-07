import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/sound_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _pumpkinController;
  late AnimationController _ghostController;
  late AnimationController _batController;
  final SoundManager _soundManager = SoundManager();
  bool _musicStarted = false;

  @override
  void initState() {
    super.initState();
    _pumpkinController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _ghostController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _batController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }


  @override
  void dispose() {
    _pumpkinController.dispose();
    _ghostController.dispose();
    _batController.dispose();
    _soundManager.stopAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            // Animated background elements
            _buildFloatingPumpkin(),
            _buildFloatingGhost(),
            _buildFlyingBat(),
            _buildFlyingBat2(),
            
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title with spooky animation
                  Text(
                    '🎃 HALLOWEEN STORYBOOK 🎃',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 28,
                      color: Colors.orange,
                      shadows: const [
                        Shadow(color: Colors.red, blurRadius: 15),
                        Shadow(color: Colors.orange, blurRadius: 10),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(duration: 1000.ms)
                      .slideY(begin: -0.5, end: 0)
                      .then()
                      .shimmer(duration: 2000.ms, color: Colors.orange)
                      .then()
                      .shimmer(duration: 2000.ms, color: Colors.red),
                  
                  const SizedBox(height: 20),
                  
                  Text(
                    'Find the Golden Pumpkin!',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 20,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate(delay: 500.ms)
                      .fadeIn(duration: 1000.ms)
                      .slideY(begin: 0.5, end: 0),
                  
                  const SizedBox(height: 40),
                  
                  // Start button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/game');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 10,
                    ),
                    child: const Text(
                      'START THE HUNT',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                      .animate(delay: 1000.ms)
                      .fadeIn(duration: 1000.ms)
                      .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1))
                      .then()
                      .shimmer(duration: 3000.ms, color: Colors.white),
                  
                  const SizedBox(height: 20),
                  
                  // Start Music button
                  if (!_musicStarted)
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _musicStarted = true;
                        });
                        await _soundManager.playBackgroundMusic();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        '🎵 Start Spooky Music',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                        .animate(delay: 2000.ms)
                        .fadeIn(duration: 1000.ms)
                        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
                  
                  const SizedBox(height: 20),
                  
                  Text(
                    'Beware of the traps! 👻',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      color: Colors.red,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate(delay: 1500.ms)
                      .fadeIn(duration: 1000.ms)
                      .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.1, 1.1), duration: 1000.ms)
                      .then()
                      .scale(begin: const Offset(1.1, 1.1), end: const Offset(1.0, 1.0), duration: 1000.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingPumpkin() {
    return Positioned(
      top: 100,
      left: 50,
      child: AnimatedBuilder(
        animation: _pumpkinController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 20 * _pumpkinController.value),
            child: const Text(
              '🎃',
              style: TextStyle(fontSize: 40),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingGhost() {
    return Positioned(
      top: 200,
      right: 60,
      child: AnimatedBuilder(
        animation: _ghostController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 30 * _ghostController.value),
            child: const Text(
              '👻',
              style: TextStyle(fontSize: 35),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFlyingBat() {
    return Positioned(
      top: 150,
      left: 20,
      child: AnimatedBuilder(
        animation: _batController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(50 * _batController.value, 0),
            child: const Text(
              '🦇',
              style: TextStyle(fontSize: 25),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFlyingBat2() {
    return Positioned(
      top: 300,
      right: 20,
      child: AnimatedBuilder(
        animation: _batController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(-50 * _batController.value, 0),
            child: const Text(
              '🦇',
              style: TextStyle(fontSize: 25),
            ),
          );
        },
      ),
    );
  }
}

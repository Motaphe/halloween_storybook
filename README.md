# 🎃 Halloween Storybook 🎃

A spooky interactive Flutter game where players hunt for the Golden Pumpkin while avoiding scary traps!

## 🎮 Game Features

- **Interactive Gameplay**: Tap on spooky objects to collect points
- **Animated Characters**: Floating ghosts, flying bats, and glowing pumpkins
- **Trap System**: Avoid skull traps that reduce your lives
- **Sound Effects**: Spooky background music and sound effects
- **Responsive Design**: Works on different screen sizes and orientations
- **Custom Animations**: Smooth transitions and floating effects

## 🎯 How to Play

1. **Objective**: Find the Golden Pumpkin 🎃 among the spooky objects
2. **Avoid Traps**: Don't tap on skulls 💀 - they reduce your lives!
3. **Collect Points**: Tap on ghosts 👻 and bats 🦇 for bonus points
4. **Lives System**: You have 3 lives - don't hit too many traps!
5. **Win Condition**: Find the Golden Pumpkin to win the game

## 🛠️ Technical Features

- **Flutter Animations**: Using `flutter_animate` for smooth animations
- **Custom Painters**: Spooky background effects with moving particles
- **State Management**: Efficient game state handling
- **Audio Integration**: Background music and sound effects
- **Responsive UI**: Adapts to different screen sizes

## 🚀 Getting Started

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run the App**:
   ```bash
   flutter run
   ```

3. **Choose Platform**:
   - Desktop: `flutter run -d linux` or `flutter run -d windows`
   - Mobile: `flutter run -d android` or `flutter run -d ios`
   - Web: `flutter run -d web`

## 📱 Screenshots

The app features:
- A spooky home screen with animated Halloween characters
- An interactive game screen with floating objects
- Victory and game over dialogs
- Smooth animations and transitions

## 🎨 Customization

You can easily customize:
- Object types and behaviors in `lib/widgets/spooky_object.dart`
- Visual effects in `lib/widgets/custom_painter.dart`
- Sound effects in `lib/services/sound_manager.dart`
- Game logic in `lib/screens/game_screen.dart`

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/
│   ├── home_screen.dart     # Main menu screen
│   └── game_screen.dart     # Game play screen
├── widgets/
│   ├── spooky_object.dart   # Game object model
│   └── custom_painter.dart  # Background effects
└── services/
    └── sound_manager.dart   # Audio management
```

## 🎃 Happy Halloween! 👻

Enjoy this spooky Flutter adventure! Try to beat your high score and see how fast you can find the Golden Pumpkin!

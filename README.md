<div align="center">

<br/>

<!-- Banner -->
<img src="https://capsule-render.vercel.app/api?type=waving&color=gradient&customColorList=6,11,20&height=200&section=header&text=Flutter%20Card%20UI&fontSize=60&fontColor=fff&animation=twinkling&fontAlignY=35&desc=Premium%203D%20Interactive%20Cards%20%2B%20Counter&descAlignY=58&descSize=18" width="100%"/>

<br/>

<!-- Badges -->
![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-7890FF?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-success?style=for-the-badge&logo=android&logoColor=white)
![Stars](https://img.shields.io/github/stars/yourusername/flutter-card-ui?style=for-the-badge&color=FFB070)
![PRs Welcome](https://img.shields.io/badge/PRs-Welcome-50EE9A?style=for-the-badge)

<br/>

> **A pixel-perfect, production-grade Flutter UI kit featuring interactive 3D payment cards with real-time drag physics, inertia, glow animations, and a fully themed counter — all with zero external dependencies.**

<br/>

---

</div>

<br/>

## ✨ &nbsp;Overview

This project delivers a **premium dark-themed Flutter UI** built entirely with Flutter's core rendering engine — no third-party packages, no shortcuts. Every animation, shadow, gradient, and physics calculation is hand-crafted for a truly native, buttery-smooth 60fps experience.

Whether you're building a fintech app, a design system prototype, or just want to study advanced Flutter animation patterns — this codebase has you covered.

<br/>

---

## 🎴 &nbsp;Features

<br/>

### 🃏 &nbsp;Interactive 3D Payment Cards

| Feature | Details |
|---|---|
| **3D Drag Rotation** | Free-axis rotation on X & Y with clamped limits (`±55°` / `±35°`) |
| **Inertia Physics** | Exponential decay velocity after pan-end for natural feel |
| **Double-tap Reset** | Snaps card back to center with smooth animation |
| **Glow Border Pulse** | Ambient edge glow breathing animation (2.4s cycle) |
| **Shimmer Sweep** | Diagonal light sweep across the card surface |
| **EMV Chip** | Realistic chip rendered via `CustomPainter` with grid lines |
| **NFC Symbol** | Arc-based NFC icon drawn programmatically |
| **Network Logo** | Overlapping circle Mastercard-style logo |
| **Decorative Rings** | Layered translucent ring overlays |
| **Grid Overlay** | Subtle background grid texture |
| **Press Scale** | 0.97× scale animation on drag-start |

<br/>

### 🎨 &nbsp;4 Premium Card Themes

<br/>

<div align="center">

| &nbsp;&nbsp;&nbsp;🖤 &nbsp;Obsidian&nbsp;&nbsp;&nbsp; | &nbsp;&nbsp;&nbsp;💚 &nbsp;Verdant&nbsp;&nbsp;&nbsp; | &nbsp;&nbsp;&nbsp;💙 &nbsp;Azure&nbsp;&nbsp;&nbsp; | &nbsp;&nbsp;&nbsp;🧡 &nbsp;Ember&nbsp;&nbsp;&nbsp; |
|:---:|:---:|:---:|:---:|
| `#1a1a2e → #0f3460` | `#0d2818 → #0f6b3a` | `#0c1445 → #1565c0` | `#3e1c00 → #d4620a` |
| Accent `#9AABFF` | Accent `#50EE9A` | Accent `#80C0FF` | Accent `#FFB070` |
| Gold chip | Green chip | Blue chip | Orange chip |
| Infinite tier | Platinum tier | Signature tier | Business tier |

</div>

<br/>

### 🔢 &nbsp;Counter App

| Feature | Details |
|---|---|
| **Bounce Animation** | Elastic spring scale on the counter number |
| **Ripple Ring** | Expanding ring animation on every tap |
| **Tap History** | Last 5 actions logged with precise timestamps |
| **Theme Cycling** | Palette button cycles all 4 card color themes live |
| **Stats Cards** | Real-time increases / decreases / total taps |
| **Haptic Feedback** | Light / medium / heavy impact on each action |
| **Decrement Guard** | Prevents going below zero with heavy haptic |

<br/>

### 🏠 &nbsp;Cards Screen

| Feature | Details |
|---|---|
| **PageView Carousel** | `viewportFraction: 0.88` with peek effect |
| **Scale Parallax** | Inactive cards scale down to 0.93× |
| **Animated Dot Indicator** | Active dot stretches to 22px pill |
| **Balance Switcher** | `AnimatedSwitcher` fade on card change |
| **Quick Actions** | Send / Receive / Pay / More with accent theming |
| **Transaction List** | Income / expense color-coded with icons |
| **Dynamic Bottom Nav** | Accent color updates to match active card |

<br/>

---

## 📁 &nbsp;Project Structure

```
flutter_card_ui/
│
├── lib/
│   ├── main.dart                  # Counter app entry point
│   ├── cards_screen.dart          # Full wallet/cards screen
│   ├── interactive_3d_card.dart   # 3D card widget + painters
│   └── card_data.dart             # Data models + 4 sample cards
│
├── pubspec.yaml
└── README.md
```

<br/>

---

## 🚀 &nbsp;Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Android Studio / VS Code
- A physical device or emulator

<br/>

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/flutter-card-ui.git

# 2. Navigate into the project
cd flutter-card-ui

# 3. Get dependencies  (none external — just Flutter core)
flutter pub get

# 4. Run the app
flutter run
```

<br/>

### Switch Entry Points

```bash
# Run the Cards Wallet screen
flutter run -t lib/cards_screen.dart

# Run the Counter app
flutter run -t lib/main.dart
```

<br/>

---

## 🎬 &nbsp;Animations Deep Dive

```dart
// Exponential inertia decay — the core of the 3D card feel
_inertiaController.addListener(() {
  final t = _inertiaController.value;
  final decay = math.exp(-t * 5);      // e^(-5t) — fast start, smooth stop
  setState(() {
    _rotY = startRotY + initialVelX * (1 - decay) * 80;
    _rotX = startRotX - initialVelY * (1 - decay) * 80;
  });
});
```

```dart
// Elastic bounce on counter number
TweenSequence<double>([
  TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.28), weight: 30),   // overshoot
  TweenSequenceItem(tween: Tween(begin: 1.28, end: 0.92), weight: 30),  // undershoot
  TweenSequenceItem(tween: Tween(begin: 0.92, end: 1.0)                 // settle
    .chain(CurveTween(curve: Curves.elasticOut)), weight: 40),
])
```

```dart
// 3D perspective matrix — the secret to realistic card rotation
Matrix4.identity()
  ..setEntry(3, 2, 0.0008)   // perspective depth
  ..rotateX(rotXRad)
  ..rotateY(rotYRad)
```

<br/>

---

## 🎨 &nbsp;Design System

### Color Palette

```dart
// Background layers
const bg        = Color(0xFF090E1A);   // Deep navy — app background
const surface   = Color(0xFF0F1629);   // Elevated surface — cards, lists

// Theme accents
const obsidian  = Color(0xFF9AABFF);   // Periwinkle blue
const verdant   = Color(0xFF50EE9A);   // Neon mint green
const azure     = Color(0xFF80C0FF);   // Sky blue
const ember     = Color(0xFFFFB070);   // Warm amber orange

// Semantic
const income    = Color(0xFF50EE9A);   // Positive / increase
const expense   = Color(0xFFFF5252);   // Negative / decrease
```

### Typography Scale

| Usage | Size | Weight | Tracking |
|---|---|---|---|
| Card Bank Name | 12px | 800 | +2.8px |
| Counter Display | 88px | 800 | -1px |
| Screen Title | 20px | 700 | default |
| Meta Labels | 7.5px | 600 | +1.8px |
| Nav Labels | 10.5px | 500–700 | default |

<br/>

---

## 🧩 &nbsp;Custom Painters

Three `CustomPainter` classes do the heavy lifting for vector elements:

**`_ChipPainter`** — Draws the EMV chip with a 3×3 grid of lines and a frosted center cell.

**`_NFCPainter`** — Renders 3 concentric arcs with decreasing opacity to simulate the NFC wave symbol.

**`_GridPainter`** — Paints a faint 36px grid across the card face for texture depth.

<br/>

---

## 📱 &nbsp;Platform Support

| Platform | Status |
|---|:---:|
| Android | ✅ Fully supported |
| iOS | ✅ Fully supported |
| Web | ⚠️ Works (no haptics) |
| macOS | ⚠️ Works (no haptics) |
| Windows | ⚠️ Works (no haptics) |
| Linux | ⚠️ Works (no haptics) |

<br/>

---

## 📦 &nbsp;Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

# ✅ Zero external packages — pure Flutter SDK only
```

> All animations, painters, physics, and UI components use **Flutter's built-in engine exclusively**. No `animations`, `flutter_animate`, `provider`, or any other pub.dev package.

<br/>

---

## 🤝 &nbsp;Contributing

Contributions are warmly welcome! Here's how:

```bash
# 1. Fork the repo
# 2. Create your feature branch
git checkout -b feature/amazing-feature

# 3. Commit your changes
git commit -m 'feat: add amazing feature'

# 4. Push to the branch
git push origin feature/amazing-feature

# 5. Open a Pull Request
```

Please follow the existing code style — no external packages, comments on non-obvious logic, and keep each widget focused.

<br/>

---

## 📄 &nbsp;License

```
MIT License

Copyright (c) 2026 Your Name

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software.
```

<br/>

---

## 👤 &nbsp;Author

<div align="center">

**Your Name**

[![GitHub](https://img.shields.io/badge/GitHub-yourusername-181717?style=for-the-badge&logo=github)](https://github.com/yourusername)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-yourprofile-0A66C2?style=for-the-badge&logo=linkedin)](https://linkedin.com/in/yourprofile)
[![Twitter](https://img.shields.io/badge/Twitter-@yourhandle-1DA1F2?style=for-the-badge&logo=twitter)](https://twitter.com/yourhandle)

<br/>

*If this project helped you, please consider giving it a ⭐ — it means a lot!*

</div>

<br/>

---

<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=gradient&customColorList=6,11,20&height=100&section=footer" width="100%"/>

**Built with 💙 using Flutter — no limits, no packages, just code.**

</div>

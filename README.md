# Fintech App Dashboard & Cards UI

A high-fidelity Flutter implementation of a modern, dark-themed e-wallet dashboard and card management interface. Built with custom interactive components, mock state management, and SVG iconography.

## Features

- **Interactive Spline Chart:** Drag and tap across the monthly spending chart to see a tooltip with dynamic spending values.
- **Credit Card Carousel:** Smooth animated scaling between the center card and background cards.
- **Card Controls:** Visually "Freeze" a card with a frosted glass effect or "Reveal" sensitive digits on demand.
- **Profile Drawer:** A custom side-menu overlay containing profile data and responsive settings toggles.
- **State Management:** Fully reactive UI powered by `provider` and `ChangeNotifier`.

## Setup Instructions

1. Ensure you have the Flutter SDK installed (tested on `v3.41.6` or greater).
2. From the root directory, run:
   ```bash
   flutter pub get
   ```
3. Run the application on your preferred emulator or device:
   ```bash
   flutter run
   ```

## Implementation Notes

- **Architecture:** The application's UI is broken down into modular, reusable widgets inside the `lib/widgets/` directory for better code maintainability.
- **State Management:** Simple state management is implemented using the `provider` package and `ChangeNotifier` to handle mock application data, user balances, and active card states.
- **Charts:** The interactive spline chart is rendered using the `fl_chart` library.
- **Assets:** SVG graphics and iconography are loaded via `flutter_svg` and are consolidated in a centralized constants file. A local font family (`Arimo`) is included.
- **Empty States:** The UI accounts for potential empty lists with dedicated empty state widgets to ensure a smooth user experience even when data is absent.

## Demo

<video src="assets/showcase/demo.mp4" controls autoplay muted loop width="100%"></video>

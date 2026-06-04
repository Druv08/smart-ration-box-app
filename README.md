# RationBox — Smart Ration Monitoring

A mobile-first Flutter app that monitors a smart ration container (rice, wheat, sugar, etc.) in real time. It shows the container's current weight, fill percentage, battery level, device connection and contextual alerts so households or fair-price shops can plan refills before they run out.

> **Project name:** Smart Ration Box
> **App name:** RationBox

---

## Tech Stack

- **Flutter** (stable channel) — UI framework
- **Dart** — application language
- **Material 3** — design system

No backend, no Firebase, no ESP32 integration yet — Week 1 ships a pure-UI prototype driven by dummy data.

---

## Project Structure

```
lib/
├── main.dart                 # App entrypoint
├── app.dart                  # MaterialApp setup
├── screens/
│   └── dashboard_screen.dart # Main dashboard
├── widgets/
│   ├── info_card.dart        # Small sensor data tile
│   └── alert_card.dart       # Alert banner (5 states)
├── models/
│   └── smart_box_data.dart   # SmartBoxData + AlertState
├── data/
│   └── dummy_data.dart       # Sample data + alert logic
└── utils/
    └── constants.dart        # App name, colours, padding
```

---

## Week 1 — Completed

- [x] Project scaffolding with clean folder structure
- [x] `SmartBoxData` model (8 fields: container, weight, capacity, stock %, status, refill, battery, connection)
- [x] Dummy data layer (no Firebase / no ESP32)
- [x] Mobile-first dashboard:
  - Custom header with **RationBox** title, **Smart Ration Monitoring** tagline and live online/offline pill
  - Prominent green stock card (container name, % full, weight / capacity, progress bar)
  - 2-column grid of info cards (weight, capacity, status, refill, battery, connection)
  - Alert section with 5 states: **All Good**, **Low Stock**, **Battery Low**, **Device Offline**, **Refill Detected**
- [x] Reusable `InfoCard` and `AlertCard` widgets
- [x] Runs on Chrome via `flutter run -d chrome`

---

## Next Steps

- **Firebase integration** — replace dummy data with Firestore / Realtime Database streams
- **ESP32 integration** — push live weight + battery readings from the hardware into Firebase
- Notifications for low stock and refill events
- Multi-container support (Rice, Wheat, Sugar, …)
- Authentication

---

## Getting Started

```bash
flutter pub get
flutter run -d chrome      # web
flutter run                # connected mobile device / emulator
```

To preview different alert states during development, change values in `lib/data/dummy_data.dart` (e.g. set `stockLevel: 10` for **Low Stock** or `battery: 15` for **Battery Low**).

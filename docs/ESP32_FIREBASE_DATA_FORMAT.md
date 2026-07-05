# ESP32 / Firebase Data Format

This document defines the **wire format** for a Smart Ration Box reading — the
single contract shared by the ESP32 firmware, Firebase, and the Flutter app.

> Status (Week 3): **planning only.** The app still runs on mock data. No real
> ESP32 or Firebase connection exists yet. This format is what we will target
> when hardware is ready. It is already implemented in code by
> `SmartBoxData.fromMap` / `SmartBoxData.toMap`
> (`lib/models/smart_box_data.dart`).

## Storage layout (Firestore)

```
boxes (collection)
  └── <boxId> (document)        // e.g. "rice-box" — the document id IS the box id
        ├── containerName: string
        ├── currentWeight: number   (kg)
        ├── capacity: number        (kg)
        ├── status: string          ("Normal" | "Low")
        ├── refillDetected: bool
        ├── battery: number         (int, 0–100, %)
        ├── connectionStatus: string ("Online" | "Offline")
        ├── lastRefillDate: string  (ISO‑8601, nullable)
        └── lowStockThreshold: number (percent 0–100, optional, default 25)
```

The box `id` is the **document key**, so it is not duplicated as a field.

## Field reference

| Field              | Type    | Unit / Range        | Notes                                                        |
| ------------------ | ------- | ------------------- | ------------------------------------------------------------ |
| `containerName`    | string  | —                   | Human label, e.g. "Rice Box".                                |
| `currentWeight`    | number  | kg                  | Live load‑cell reading.                                      |
| `capacity`         | number  | kg (≤ 25)           | Max the container holds.                                     |
| `status`           | string  | `Normal` \| `Low`   | Derived; app recomputes from weight vs. threshold.           |
| `refillDetected`   | bool    | —                   | True when a top‑up is sensed; cleared on next consumption.   |
| `battery`          | number  | int %, 0–100        | < 20 % triggers the Battery Low alert.                       |
| `connectionStatus` | string  | `Online`\|`Offline` | Device link state.                                           |
| `lastRefillDate`   | string  | ISO‑8601 / null     | e.g. `2026-06-22T14:03:00.000`.                              |
| `lowStockThreshold`| number  | percent 0–100       | Optional; defaults to 25. Below this `% full` ⇒ Low Stock.   |

## Example JSON payload (one box)

```json
{
  "containerName": "Rice Box",
  "currentWeight": 6.5,
  "capacity": 10.0,
  "status": "Normal",
  "refillDetected": false,
  "battery": 78,
  "connectionStatus": "Online",
  "lastRefillDate": "2026-05-26T00:00:00.000",
  "lowStockThreshold": 25
}
```

## Derived values (computed by the app, NOT sent over the wire)

These are getters on `SmartBoxData`; firmware/Firebase should **not** store them:

- `stockPercentage` = `currentWeight / capacity * 100`
- `isLowStock`      = `stockPercentage < lowStockThreshold`
- `isBatteryLow`    = `battery < 20`
- `isOnline`        = `connectionStatus == "Online"`
- `activeAlerts`    = list derived from the flags above (drives dashboard alerts)

## How this maps to the code

| Concern                     | Where                                                       |
| --------------------------- | ---------------------------------------------------------- |
| Model + (de)serialization   | `lib/models/smart_box_data.dart` (`fromMap` / `toMap`)     |
| Read interface              | `lib/services/box_data_source.dart` (`fetchBoxes`/`watchBoxes`) |
| Current (mock) source       | `lib/services/mock_box_data_source.dart`                   |
| Planned Firebase source     | `lib/services/firebase_box_data_source.dart` (stub + example) |

## Integration path (future weeks — not done in Week 3)

1. **Firebase:** add `firebase_core` + `cloud_firestore`, run `flutterfire configure`,
   init in `main.dart`, then implement `FirebaseBoxDataSource` using
   `SmartBoxData.fromMap(doc.id, doc.data())`.
2. **ESP32 → Firebase:** firmware publishes the JSON above to
   `boxes/<boxId>` over Wi‑Fi (Firebase REST/SDK). The app needs no change —
   it already reads through `BoxDataSource`.
3. **ESP32 direct (optional):** a future `EspBoxDataSource` (BLE/MQTT) can
   implement the same interface and parse the same payload via `fromMap`.

## Swapping the data source

The app depends only on the `BoxDataSource` interface, so going live is a
one‑line change in `lib/screens/dashboard_screen.dart` and
`lib/screens/item_details_screen.dart`:

```dart
// Week 3 (now):
final BoxDataSource _dataSource = MockBoxDataSource();
// Later:
final BoxDataSource _dataSource = FirebaseBoxDataSource();
```

> Note: the `simulate*` methods on `MockBoxDataSource` are mock-only and have no
> equivalent on real sources — remove the simulation controls on the details
> page when hardware is connected.

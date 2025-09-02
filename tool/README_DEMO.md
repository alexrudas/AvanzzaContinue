# Avanzza 2.0 Demo Seed & Run

This guide helps populate a minimal dataset and run the app to explore the initial slice (orgs, assets, incidencias, purchases).

## Prerequisites
- Flutter stable installed
- Firebase project configured for the app (or run without connecting to real services)

## 1) Install dependencies
```
flutter pub get
```

## 2) Generate code (if needed)
```
sh tool/build_runner.sh
```

## 3) Run the seed script
This will insert:
- Country CO and City bogota
- Organization org_demo
- Membership for user_demo in org_demo
- Two assets (vehiculo and inmueble)
- One incidencia for asset_demo_1

Run:
```
dart run tool/seed.dart
```

If you are not connected to a real Firestore project, the local cache and Isar storage will still allow browsing in the app (offline-first).

## 4) Run the app
```
flutter run
```

## 5) Navigate the slice
- Login with uid: `user_demo`
- Select the organization: `Org Demo`
- View assets list
- Open incidencias for a specific asset and create new ones
- Go to purchases and create a simple purchase request

Enjoy exploring the Avanzza 2.0 foundations!

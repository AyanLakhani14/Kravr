# 🍔 Kravr

## 📌 Project Description

Kravr is a mobile application that helps users track, rate, and explore food spots.
It allows users to save restaurants, add notes, mark favorites, and view locations on a map with radius-based filtering.

The app is designed for anyone who struggles to decide where to eat or wants to remember great food experiences.

---

## 👥 Team Members

* Ayan Lakhani — Full Stack Development (UI, Database, Features)

---

## 🚀 Features

* Add new food spots with name, cuisine, notes, rating, and location
* View saved food spots in a clean list layout
* Edit and update food spot details
* Mark/unmark food spots as favorites
* View favorite food spots in a dedicated screen
* Track history of viewed food spots
* Map integration with Google Maps API
* Radius-based filtering of nearby food spots
* Smooth navigation between screens
* Local data persistence using SQLite

---

## 🛠 Technologies Used

* Flutter (Dart)
* SQLite (sqflite package)
* Google Maps Flutter API
* Geocoding package
* Android Studio / VS Code

---

## ⚙️ Installation Instructions

1. Clone the repository:

   ```bash
   git clone https://github.com/AyanLakhani14/kravr.git
   ```

2. Navigate to the project folder:

   ```bash
   cd kravr
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Run the app:

   ```bash
   flutter run
   ```

---

## 📱 Usage Guide

1. Open the app and land on the Home screen
2. Tap the ➕ button to add a new food spot
3. Enter details like name, cuisine, and address
4. Use "Find Location" to pin it on the map
5. Save the entry
6. Tap any food item to view details
7. Use Favorites tab to view saved favorites
8. Use Map tab to explore nearby food spots
9. Adjust the radius slider to filter results

---

## 📸 Screenshots

> Create this folder in your repo:
> assets/screenshots/

Add your screenshots with these names:

* home.png
* add.png
* map.png
* favorites.png
* history.png
* settings.png

Then they will display here automatically once added.

---

## 🗄 Database Schema

### Table: `food_spots`

| Column     | Type         | Description         |
| ---------- | ------------ | ------------------- |
| id         | INTEGER (PK) | Unique ID           |
| name       | TEXT         | Food name           |
| cuisine    | TEXT         | Cuisine type        |
| rating     | INTEGER      | User rating         |
| notes      | TEXT         | Optional notes      |
| latitude   | REAL         | Location latitude   |
| longitude  | REAL         | Location longitude  |
| isFavorite | INTEGER      | Favorite flag (0/1) |

---

## ⚠️ Known Issues

* Data is stored locally and not tied to user accounts
* No cloud sync or backup
* Uses `setState()` which may not scale well for larger apps
* Map may not update instantly on slower devices

---

## 🚀 Future Enhancements

* Add user authentication with data separation
* Implement Provider or Riverpod for better state management
* Add cloud database (Firebase)
* Improve UI with animations and themes
* Add search and filter by cuisine
* Show nearest restaurant automatically
* Add image uploads for food spots

---

## 📄 License

This project is licensed under the MIT License.

# CareConnect 🩺

**A Flutter-Based Doctor Appointment Booking & Management App**

CareConnect is a mobile application built with **Flutter and Dart** that simplifies the process of finding doctors and managing healthcare appointments. Users can explore medical specialists, view doctor profiles, book or reschedule appointments, and manage their appointment history through a clean and intuitive interface.

The application uses **SQLite for local data persistence**, allowing users to access their stored information without requiring a backend server.

This project is a Flutter implementation of the original React + TypeScript web application.

---

## ✨ Features

### 🔐 Authentication & Onboarding
- Welcome screen with a simple onboarding experience.
- User registration and sign-in.
- Forgot password screen.
- First-time specialty setup.

### 🏠 Home Dashboard
- Overview of upcoming appointments.
- Popular medical specialties.
- Recommended doctors.
- Quick access to essential app features.

### 🔎 Doctor Discovery
- Browse available doctors and specialists.
- Search doctors by name.
- Filter doctors by medical specialty.
- Filter doctors using the "Available Now" option.

### 👨‍⚕️ Doctor Profiles
- View doctor information and specialization.
- Check professional experience.
- View consultation fees.
- Explore working days and available appointment times.

### 📅 Appointment Management
- Four-step appointment booking process:
  1. Select appointment date.
  2. Choose an available time slot.
  3. Enter patient details.
  4. Review and confirm the appointment.
- Reschedule upcoming appointments.
- Cancel appointments.
- View appointment history using Upcoming, Completed, and Cancelled tabs.

### 🔔 Notifications
- In-app appointment notifications.
- Appointment booking and status updates.
- Mark all notifications as read.
- Reminder preferences.

### 👤 User Profile
- View and update personal information.
- Appointment statistics.
- Toggle appointment reminders.
- Log out securely.

### 💾 Local Data Storage
- SQLite database integration using `sqflite`.
- Persistent storage for user information and appointments.
- Local notification and settings storage.
- Offline access to stored application data.

---

## 🛠️ Tech Stack

| Technology / Package | Purpose |
|---|---|
| Flutter | Cross-platform mobile application development |
| Dart | Application programming language |
| Provider | State management |
| SQLite | Local database |
| sqflite | SQLite integration for Flutter |
| sqflite_common_ffi | SQLite support for Windows and Linux |
| Google Fonts | DM Sans and Manrope typography |
| path | Database file path management |

---

## 📂 Project Structure

```text
lib/
│
├── main.dart              # Application entry point and Provider setup
├── theme.dart             # Colors, typography and app theme
├── models.dart            # Data models
├── data.dart              # Doctors, specialties and time slots
├── db.dart                # SQLite database management
├── app_state.dart         # Application state and business logic
├── widgets.dart           # Reusable UI components
│
└── screens/
    ├── auth.dart          # Authentication and onboarding
    ├── shell.dart         # Main navigation and Home tab
    ├── explore.dart       # Doctor discovery and details
    ├── booking.dart       # Booking flow and confirmation
    ├── appointments.dart  # Appointment management
    └── profile.dart       # Profile and notifications
```
## Screenshots
<img width="214" height="469" alt="0" src="https://github.com/user-attachments/assets/408e891e-d6f8-45ff-9c55-8ac03c154971" />
<img width="214" height="475" alt="00" src="https://github.com/user-attachments/assets/b9bfa7cd-d5b5-41f1-92f6-03196851b569" />
<img width="215" height="478" alt="000" src="https://github.com/user-attachments/assets/6ddcb674-f064-44f2-b5c6-fb7605e64c65" />
<img width="215" height="470" alt="1" src="https://github.com/user-attachments/assets/fe7e4d38-a59d-4675-80f9-fb27b75e4adb" />
<img width="215" height="473" alt="2" src="https://github.com/user-attachments/assets/45172b27-c6c9-4dcc-865d-89ee117a2678" />
<img width="215" height="471" alt="3" src="https://github.com/user-attachments/assets/4cfea170-2227-457f-8fb7-012283dae2ac" />
<img width="215" height="452" alt="4" src="https://github.com/user-attachments/assets/7882cb3a-323a-409f-9604-9a6d92b645f0" />

---

## 🚀 Getting Started

### Prerequisites

Before running the application, make sure you have:

- Flutter SDK installed.
- Dart SDK 3.7 or newer.
- Android Studio or VS Code.
- An Android emulator or physical device.

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/CareConnect.git
```

### 2. Navigate to the Project Directory

```bash
cd CareConnect
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run the Application

```bash
flutter run
```

---

## 🔑 Demo Account

You can explore the application using the following demo credentials:

| Field | Credentials |
|---|---|
| Email | `demo@careconnect.app` |
| Password | `password123` |

**Note:** New user registration is also available. The current sign-in implementation accepts the predefined demo account.

---

## 📱 Platform Support

| Platform | Support |
|---|---|
| Android | Supported |
| iOS | Supported |
| macOS | Supported |
| Windows | Supported through `sqflite_common_ffi` |
| Linux | Supported through `sqflite_common_ffi` |
| Web | Not supported |

### Android Internet Permission

Doctor images and Google Fonts are loaded from external sources. For Android release builds, add the following permission inside the `<manifest>` element in:

`android/app/src/main/AndroidManifest.xml`

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

---

## 🗄️ Database Structure

CareConnect uses **SQLite** to store application data locally.

The database file is named:

`careconnect.db`

It is created automatically on the first application launch and seeded with demo data once.

### Database Tables

| Table | Description |
|---|---|
| `user` | Stores the signed-in user's information (single row). |
| `appointments` | Stores appointments and their statuses. |
| `notices` | Stores in-app notifications. |
| `settings` | Stores application settings and key/value flags. |

### Appointment Statuses

- `upcoming`
- `completed`
- `cancelled`

### Resetting the Application Data

To restore the application to its initial state, uninstall the application or manually delete its local database file.

---

Run:

```bash
flutter pub get
```

**3. Images or fonts are not loading**

Check your internet connection because doctor images and Google Fonts are loaded online.
---

## 📝 Project Notes

- Doctor information is currently maintained as static data in `lib/data.dart`.
- Doctor profile images are loaded from Unsplash.
- Appointment reminders are displayed within the application.
- System-level push notifications are not currently implemented.
- The application stores its data locally using SQLite.
- The current authentication flow uses a predefined demo account for sign-in.

---

## 👩‍💻 Developer

Fareeda Zarlal

Software Engineering Student

Stack and Scale Intern


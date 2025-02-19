# Chat App

## Overview
This is a real-time chat application built using **Flutter** for the frontend and **Node.js with Socket.io** for the backend. The app supports:
- User registration & login (email/password)
- Profile update (name, avatar, etc.)
- Real-time messaging using **Socket.io**
- One-on-one chat
- Audio & Video calls using **ZegoCloud**

## Tech Stack
### Frontend (Flutter)
- Flutter (Dart)
- Provider / Bloc for state management
- Firebase for authentication (optional)
- ZegoCloud SDK for calls
- SharedPreferences for local storage

### Backend (Node.js)
- Node.js with Express.js
- MongoDB with Mongoose
- Socket.io for real-time messaging
- JWT for authentication
- Multer for profile image uploads

---
## Features
### Authentication
✅ Register user with email & password  
✅ Login user securely with JWT  
✅ Update user profile (name, avatar, password)  

### Chat
✅ Start a new chat  
✅ Real-time messaging using **Socket.io**  
✅ Message seen status  
✅ Typing indicators  
✅ Push notifications (Firebase)  

### Audio/Video Call (ZegoCloud)
✅ Start one-on-one **audio call**  
✅ Start one-on-one **video call**  
✅ Call notifications  
✅ In-call UI (mute, camera switch, end call)  

---
## Installation
### Backend Setup
1. Clone the repository:
   ```sh
   git clone https://github.com/theDeveloper574/Chat-App
   cd chat-app-backend
   ```
2. Install dependencies:
   ```sh
   npm install
   ```
3. Set up your **.env** file:
   ```env
   PORT=5000
   MONGO_URI=mongodb+srv://yourdb
   JWT_SECRET=your_secret_key
   ```
4. Run the server:
   ```sh
   npm start
   ```

### Frontend Setup
1. Clone the repository:
   ```sh
   git clone https://github.com/theDeveloper574/Chat-App
   cd chat-app-flutter
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Set up ZegoCloud:
   - Get your **App ID** and **App Sign** from [ZegoCloud](https://www.zegocloud.com/)
   - Add them to your Flutter app.

4. Run the app:
   ```sh
   flutter run
   ```

---
## API Endpoints (Backend)
| Method | Endpoint            | Description              |
|--------|---------------------|--------------------------|
| POST   | /api/auth/register  | Register a new user     |
| POST   | /api/auth/login     | Login user              |
| PUT    | /api/users/profile  | Update user profile     |
| GET    | /api/users/:id      | Get user details        |
| POST   | /api/messages/send  | Send a chat message     |
| GET    | /api/messages/:chatId | Get chat messages   |

---
## Usage
1. **User Registration/Login**  
   - New users can register with their email and password.
   - Login to access the chat features.

2. **Start a New Chat**  
   - Select a user from the contact list.
   - Send a message in real-time using **Socket.io**.

3. **Audio/Video Call**  
   - Click on the **Call** button.
   - The recipient receives a call notification.
   - The call starts using **ZegoCloud**.

---
## Screenshots
🖼️ Coming soon...

---

Happy coding! 🚀






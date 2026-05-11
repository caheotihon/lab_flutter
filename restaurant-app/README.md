# Restaurant App

A full-stack food delivery application built with Flutter, Node.js, and MongoDB.

## Team Members
- **Trần Văn Tài**
- **Trần Tấn Phúc**

## Demo Video
You can watch the application demo here: [Project Demo Video](https://drive.google.com/file/d/1oGIlXly-sIW-OcBQu2Xp8GSU6eYIN2Tm/view?usp=drive_link)

## Features
- **Auth**: Login and Registration.
- **Menu**: Browse food by culture/category (Chinese, Mexican, Indian, etc.).
- **Cart**: Add/remove items and adjust quantities.
- **Checkout**: Simulated payment success screen.

## Project Structure
- `api/`: Node.js Express server.
- `flutter_app/`: Flutter mobile application.
- `assets/images/`: Image assets used in the app.

## Technologies Used
- **Frontend**: Flutter, Provider (State Management), Google Fonts.
- **Backend**: Node.js, Express, Mongoose.
- **Database**: MongoDB.
- **Auth**: JWT & Bcryptjs.

## Backend Architecture & Connection

### 1. Database Connection (MongoDB)
The application uses **MongoDB** as its primary database. The connection is managed through the `mongoose` library:
- **Environment Variables**: Sensitive information like the MongoDB URI and Port are stored in a `.env` file for security.
- **Connection Logic**: A dedicated `db.js` configuration file handles the asynchronous connection to MongoDB Atlas or a local instance. It ensures the server only starts once the database is successfully connected.
- **Schema Design**: Models for `User`, `Category`, and `Food` are defined with strict types and relationships (e.g., each Food item references a Category ID).

### 2. Node.js Server Construction
The backend is built as a RESTful API using **Express.js**:
- **Middleware**: Uses `express.json()` for parsing request bodies and `cors` to allow communication with the Flutter frontend.
- **Authentication**: Implements **JWT (JSON Web Tokens)**. When a user logs in, the server signs a token that the mobile app stores to authenticate subsequent requests.
- **Routing**: Modular routing is used to separate concerns:
    - `/api/auth`: Handles registration and login logic.
    - `/api/categories`: Fetches food categories.
    - `/api/foods`: Handles food item retrieval and filtering.
- **Seeding**: Includes a `seed.js` script to automatically populate the database with initial food and category data (using remote image URLs).

## Getting Started
1. Navigate to the `api` folder and run `npm install`.
2. Configure your `.env` file with `MONGO_URI` and `JWT_SECRET`.
3. Start the server with `npm start` or `node server.js`.
4. Run the Flutter app using `flutter run`.
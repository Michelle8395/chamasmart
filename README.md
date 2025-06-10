# 💰 ChamaSmart

ChamaSmart is a Flutter-based mobile application designed to simplify the management of Chamas (informal savings and investment groups). It helps streamline contributions, loans, fines, and financial records, all from a mobile device — with support for M-Pesa and AI-powered assistance.

---

## 🚀 Features

- 🔐 Firebase Authentication (Email/Password)
- 💳 **M-Pesa Integration** via Daraja API (STK Push for contributions/payments)
- 📈 Track contributions, withdrawals, deposits, profits, and fines
- 🧾 Member management and meeting scheduling
- 💬 Real-time chat (Firebase)
- 🧠 Built-in AI Assistant for user support (OpenAI integration; prompt/response disabled until API is activated)
- 📱 Clean, intuitive Flutter UI

---

> [!NOTE]
> ## 🛠️ Setup Instructions
>
> 1.Clone the repository:
>    ```bash
>    git clone https://github.com/your-username/chamasmart.git
>    cd chamasmart
>    ```
> 2.Install dependencies:
>    ```bash
>    flutter pub get
>    ```
> 3. Add Firebase configuration:
>    - Generate `firebase_options.dart` using `flutterfire configure`
>    - Or place your Firebase config manually under `lib/firebase_options.dart`
> 4. Run the app:
>    ```bash
>    flutter run
>    ```

---

> [!NOTE]
> ## 🧪 Testing
>
> - ✅ Unit tests: form validation, authentication logic  
> - ✅ Widget tests: login and registration flows  
> - 🚧 Integration tests (in progress)  
>
> Run all tests:
> ```bash
> flutter test
> ```

---

## 👨🏾‍💻 Development Workflow

- 🔁 Agile development with weekly standups
- 🗂️ Task tracking with GitHub Projects / Issues
- ✅ Code reviews and pair programming
- 🌱 Branch naming: `feature/`, `fix/`, `test/`

---

## 👥 Team

- Michelle Wanjiru Kang'ethe – Lead Developer, M-Pesa API Integration, Flutter UI

---

## 📂 Folder Structure

```
lib/
├── screens/         # All UI screens
├── models/          # Data models
├── services/        # Firebase, M-Pesa API services
├── widgets/         # Reusable UI components
├── firebase_options.dart
```

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

## 📬 Contact

For support or inquiries, reach out to:  
📧 [michellekangethe@example.com]  
📱 +254 717 895 133

---

### ✅ Optional Additions

- Screenshots of the app
- Demo video link
- Environment variable instructions for M-Pesa keys
- GitHub Actions or CI/CD badge

---

 
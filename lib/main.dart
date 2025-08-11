import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ChamaSmartApp());
}

class ChamaSmartApp extends StatelessWidget {
  const ChamaSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChamaSmart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF5F5DC),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/terms': (context) => const TermsScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/verification': (context) => const VerificationScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/contributions': (context) => const GeneralChamaContributionsScreen(),
        '/deposits': (context) => const DepositsScreen(),
        '/withdrawals': (context) => const WithdrawalsScreen(),
        '/profits': (context) => const ProfitsAndDividendsScreen(),
        '/loan-request': (context) => const LoanRequestFormScreen(),
        '/fines': (context) => const FinesIncurredScreen(),
        '/chat': (context) => const ChatRoomScreen(),
        '/meetings': (context) => const MeetingsScreen(),
        '/members': (context) => const MembersScreen(),
        '/ai-assistant': (context) => const AIAssistantDialog(),
        '/postVerification': (context) => const PostVerificationScreen(),
        '/createChama': (context) => const CreateChamaScreen(),
        '/joinChama': (context) => const JoinChamaScreen(),
        '/loan-approval': (context) => const LoanApprovalScreen(),
      },
    );
  }
}

// Firebase Auth helper functions
 Future<void> signUp(String email, String password, BuildContext context) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    // Send verification email
    if (!userCredential.user!.emailVerified) {
      await userCredential.user!.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Verification email sent! Please check your inbox.")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Sign up failed: $e")),
    );
  }
}

Future<void> signIn(String email, String password, BuildContext context) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    Navigator.pushReplacementNamed(context, '/dashboard');
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Login failed: $e")),
    );
  }
}


List<String> members = [
  "Lucy Nduta Gichuru",
  "David Otieno Owino",
  "Elizabeth Mwake",
  "Jane Nyeri Kamau",
  "Ahmed Nazer Hussein",
  "Mary Atieno Achieng",
  "Samuel Mwangi Thuo",
  "Grace Wanjiku Muriuki",
  "Peter Kiprono Cheruiyot",
  "Catherine Njeri Wambui",
  "John Mwangi Kariuki",
  "Fatuma Hassan Mohamed",
];
String? userGroup;
String? adminEmail;

// SPLASH SCREEN
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/terms');
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Images/CHAMASMART.jpg',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              "ChamaSmart",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}

// TERMS & CONDITIONS SCREEN
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  void _agreeAndContinue(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.indigo[900],
    );

    const bodyStyle = TextStyle(
      fontSize: 16,
      color: Colors.black87,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Conditions"),
        backgroundColor: Colors.indigo[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: RichText(
                  text: TextSpan(
                    style: bodyStyle,
                    children: [
                      TextSpan(text: "ChamaSmart Terms and Conditions\n\n", style: titleStyle),
                      ...[
                        "1. Eligibility\nTo use ChamaSmart, you must be a Kenyan citizen, at least 18 years old, and legally capable of entering into binding agreements. By registering, you confirm your citizenship and eligibility. Minors are not permitted to use the platform.",
                        "2. User Account Responsibility\nEach user is responsible for maintaining the confidentiality of their account credentials and is liable for all activity under their account. Sharing login credentials is strictly prohibited.",
                        "3. Accuracy of Information\nUsers must provide accurate, up-to-date, and complete information during account registration and whenever updating personal details. ChamaSmart reserves the right to suspend or terminate accounts that contain misleading or false information.",
                        "4. Acceptable Use\nUsers agree not to use ChamaSmart for any illegal, fraudulent, or unauthorized purposes, including—but not limited to—misappropriation of group funds or misrepresentation of identity.",
                        "5. Role-Based Access\nUsers are assigned roles that determine their permissions within the system. Attempting to bypass role restrictions or manipulate permissions is prohibited and may result in immediate termination.",
                        "6. Financial Transactions\nChamaSmart records and facilitates group savings, contributions, and loan disbursements, but does not directly handle or store any user funds. Users are responsible for confirming M-Pesa or bank transactions externally.",
                        "7. Third-Party Integrations\nChamaSmart integrates with services such as M-Pesa for financial transactions. Users agree to comply with the terms of those third-party services when using them via ChamaSmart.",
                        "8. Data Privacy\nAll data is stored securely using Firebase in accordance with our Privacy Policy. We do not sell or rent user data. Users' financial records are confidential and shared only with authorized group members.",
                        "9. Security Measures\nTo protect user data, ChamaSmart implements secure authentication, two-factor authentication (2FA), audit logging, and encryption. Users are responsible for securing their own devices and passwords.",
                        "10. Real-Time Notifications\nChamaSmart sends real-time alerts related to contributions, loan approvals, meetings, or changes in group settings. Users may customize or disable certain notifications in their account settings.",
                        "11. Limitation of Liability\nChamaSmart is a tool for managing financial records and does not intervene in internal group conflicts. We are not liable for financial loss, disputes, or transaction errors caused by user actions or third-party failures.",
                        "12. Termination of Services\nWe may suspend or terminate accounts that breach these terms, engage in fraudulent activity, or compromise platform security. Users may also request voluntary account deletion.",
                        "13. Modification of Terms\nWe may revise these Terms periodically. Continued use of the platform implies acceptance of updated terms. Users will be notified of major updates.",
                        "14. Intellectual Property\nAll branding, software, and designs are the exclusive intellectual property of ChamaSmart. You may not copy, distribute, or alter platform components without express written permission.",
                        "15. Dispute Resolution\nIn case of any dispute, users agree to attempt resolution internally within their chama. If unresolved, the matter shall be governed by Kenyan law, and escalated to Kenyan courts as necessary.",
                      ].map(
                        (para) => TextSpan(text: "$para\n\n"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDAA520),
                foregroundColor: Colors.white,
              ),
              onPressed: () => _agreeAndContinue(context),
              child: const Text("Agree & Continue"),
            ),
          ],
        ),
      ),
    );
  }
}

// LOGIN SCREEN
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      await signIn(email, password, context);
    }
  }

  void _register() {
    Navigator.pushNamed(context, '/register');
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    const darkBlue = Color(0xFF0A0E21);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: darkBlue,
            )),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          validator: validator,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Color(0xFFF9F9F9),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF0A0E21);
    const golden = Color(0xFFFFD700);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: darkBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Already have an account?",
                  style: TextStyle(
                    fontSize: 18,
                    color: darkBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                _buildField(
                  "EMAIL ADDRESS",
                  _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Email is required";
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return "Enter a valid email";
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                _buildField(
                  "PASSWORD",
                  _passwordController,
                  obscure: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Password is required";
                    if (value.length < 6) return "Password must be at least 6 characters";
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                Center(
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: golden,
                      foregroundColor: darkBlue,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: const Text("LOGIN"),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: Column(
                    children: [
                      const Text("Not yet registered?", style: TextStyle(color: darkBlue)),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: _register,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: darkBlue,
                          side: const BorderSide(color: darkBlue),
                        ),
                        child: const Text("REGISTER"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// REGISTER SCREEN
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      await signUp(email, password, context);
      members.add(_nameController.text.trim());
      Navigator.pushNamed(context, '/verification');
    }
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    const darkBlue = Color(0xFF0A0E21);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: darkBlue,
            )),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          validator: validator,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Color(0xFFF9F9F9),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF0A0E21);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        backgroundColor: darkBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildField(
                "FULL NAMES",
                _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Name is required";
                  if (value.length < 3) return "Name must be at least 3 characters";
                  return null;
                },
              ),
              const SizedBox(height: 15),
              _buildField(
                "NATIONAL ID NO",
                _idController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return "ID is required";
                  if (!RegExp(r'^\d{7,8}$').hasMatch(value)) return "Enter a valid 7-8 digit ID";
                  return null;
                },
              ),
              const SizedBox(height: 15),
              _buildField(
                "PHONE NUMBER",
                _phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Phone is required";
                  if (!RegExp(r'^\+?254\d{9}$').hasMatch(value)) return "Enter a valid Kenyan phone (+254...)";
                  return null;
                },
              ),
              const SizedBox(height: 15),
              _buildField(
                "EMAIL ADDRESS",
                _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Email is required";
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return "Enter a valid email";
                  return null;
                },
              ),
              const SizedBox(height: 15),
              _buildField(
                "CREATE PASSWORD",
                _passwordController,
                obscure: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Password is required";
                  if (value.length < 6) return "Password must be at least 6 characters";
                  return null;
                },
              ),
              const SizedBox(height: 15),
              _buildField(
                "CONFIRM PASSWORD",
                _confirmPasswordController,
                obscure: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Confirm your password";
                  if (value != _passwordController.text) return "Passwords do not match";
                  return null;
                },
              ),
              const SizedBox(height: 25),
              const Text(
                "After you tap sign up, you will receive a one-time code via Email. Kindly enter the verification code below.",
                style: TextStyle(fontSize: 14, color: darkBlue),
              ),
              const SizedBox(height: 25),
              Center(
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: const Text("SIGN UP"),
                  
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// VERIFICATION SCREEN
class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final codeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Phone"),
        backgroundColor: const Color(0xFF0A0E21),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Enter the one-time verification code sent via Email:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Verification Code",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                  Navigator.pushReplacementNamed(context, '/postVerification');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text("Verify"),
            )
          ],
        ),
      ),
    );
  }
}
// POST VERIFICATION SCREEN
class PostVerificationScreen extends StatelessWidget {
  const PostVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // If user is already in a group, go straight to dashboard
    if (userGroup != null) {
      Future.microtask(() {
        Navigator.pushReplacementNamed(
          context,
          '/dashboard',
          arguments: userGroup,
        );
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello user,\nWhat do you want to do today?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final groupName = await Navigator.pushNamed(context, '/createChama');
                  if (groupName != null && groupName is String) {
                    userGroup = groupName;
                    Navigator.pushReplacementNamed(
                      context,
                      '/dashboard',
                      arguments: userGroup,
                    );
                  }
                },
                child: const Text('CREATE NEW CHAMA'),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  final groupName = await Navigator.pushNamed(context, '/joinChama');
                  if (groupName != null && groupName is String) {
                    userGroup = groupName;
                    Navigator.pushReplacementNamed(
                      context,
                      '/dashboard',
                      arguments: userGroup,
                    );
                  }
                },
                child: const Text('JOIN EXISTING CHAMA'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//CREATE CHAMA SCREEN
class CreateChamaScreen extends StatefulWidget {
  const CreateChamaScreen({super.key});

  @override
  State<CreateChamaScreen> createState() => _CreateChamaScreenState();
}

class _CreateChamaScreenState extends State<CreateChamaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _adminController = TextEditingController();
  final _chamaNameController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _amountController = TextEditingController();
  final _profitController = TextEditingController();
  final _finesController = TextEditingController();
  final _codeController = TextEditingController();

  String? _generatedCode;
  bool _codeSent = false;

 void _createChama() {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _generatedCode = "CHAMA${DateTime.now().millisecondsSinceEpoch % 100000}";
      _codeSent = true;
    });
    // Set admin email
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      adminEmail = user.email;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Chama created! Code: $_generatedCode (share with members)")),
    );
  }
} 

  void _verifyCode() {
    if (_codeController.text.trim() == _generatedCode) {
      // Return the chama name to the previous screen
      Navigator.pop(context, _chamaNameController.text.trim());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid code. Please check and try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create New Chama")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 10),
              const Text("ADMIN NAME"),
              TextFormField(
                controller: _adminController,
                validator: (v) => v == null || v.isEmpty ? "Enter admin name" : null,
              ),
              const SizedBox(height: 15),
              const Text("CHAMA NAME"),
              TextFormField(
                controller: _chamaNameController,
                validator: (v) => v == null || v.isEmpty ? "Enter chama name" : null,
              ),
              const SizedBox(height: 15),
              const Text("CONTRIBUTION FREQUENCY"),
              TextFormField(
                controller: _frequencyController,
                validator: (v) => v == null || v.isEmpty ? "Enter frequency" : null,
              ),
              const SizedBox(height: 15),
              const Text("CONTRIBUTION AMOUNT"),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? "Enter amount" : null,
              ),
              const SizedBox(height: 15),
              const Text("PROFIT SHARING RATE"),
              TextFormField(
                controller: _profitController,
                validator: (v) => v == null || v.isEmpty ? "Enter profit sharing rate" : null,
              ),
              const SizedBox(height: 15),
              const Text("FINES"),
              TextFormField(
                controller: _finesController,
                validator: (v) => v == null || v.isEmpty ? "Enter fines" : null,
              ),
              const SizedBox(height: 25),
              const Text(
                "After you press create, a code will be generated and sent to your email which you will send to your group members so they can use it to join this existing group.",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _createChama,
                  child: const Text("CREATE"),
                ),
              ),
              if (_codeSent && _generatedCode != null) ...[
                const SizedBox(height: 30),
                TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    labelText: "Enter verification code",
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _verifyCode,
                    child: const Text("VERIFY CODE"),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

//JOIN CHAMA SCREEN
class JoinChamaScreen extends StatefulWidget {
  const JoinChamaScreen({super.key});

  @override
  State<JoinChamaScreen> createState() => _JoinChamaScreenState();
}

class _JoinChamaScreenState extends State<JoinChamaScreen> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _joining = false;

  void _joinChama() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _joining = true);

      // Simulate code validation (replace with real backend check)
      await Future.delayed(const Duration(seconds: 1));
      final code = _codeController.text.trim();

      if (code.isNotEmpty) {
        // For demo, use code as group name. In real app, fetch group name from backend.
        Navigator.pop(context, code); // Returns group name to PostVerificationScreen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid code. Please try again.")),
        );
      }

      setState(() => _joining = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Join Existing Chama")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Enter Group Code",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "e.g. CHAMA12345",
                ),
                validator: (v) => v == null || v.isEmpty ? "Please enter the group code" : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _joining ? null : _joinChama,
                  child: _joining
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text("JOIN"),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Ask your admin for the group code.",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// DASHBOARD SCREEN
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
     final user = FirebaseAuth.instance.currentUser;
final userName = user?.displayName ?? user?.email ?? "User";
final isAdmin = user != null && user.email == adminEmail;
    final List<Map<String, String>> features = [
      {
        "label": "GENERAL CHAMA CONTRIBUTIONS",
        "icon": "assets/Images/GENERAL CHAMA CONTRIBUTIONS.jpg",
        "route": "/contributions"
      },
      {
        "label": "DEPOSITS",
        "icon": "assets/Images/DEPOSITS.webp",
        "route": "/deposits"
      },
      {
        "label": "WITHDRAWALS",
        "icon": "assets/Images/WITHDRAWALS.jpg",
        "route": "/withdrawals"
      },
      {
        "label": "PROFITS & DIVIDENDS",
        "icon": "assets/Images/PROFITS AND DIVIDENDS.png",
        "route": "/profits"
      },
      {
        "label": "LOAN REQUEST FORM",
        "icon": "assets/Images/LOAN REQUEST FORM.png",
        "route": "/loan-request"

      },

      if (isAdmin) // Only show for admin
    {
      "label": "LOAN APPROVAL",
      "icon": "assets/Images/LOANS APPROVAL FORM.png",
      "route": "/loan-approval"
    },
      {
        "label": "FINES INCURRED",
        "icon": "assets/Images/FINES INCURRED.jpg",
        "route": "/fines"
      },
      {
        "label": "GENERAL CHAMA CHAT ROOM",
        "icon": "assets/Images/CHAT ROOM.png",
        "route": "/chat"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("CHAMASMART"),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome, color: Colors.amber, size: 30),
            tooltip: "AI Assistant",
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AIAssistantDialog(),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text("Menu")),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/dashboard');
              },
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text("Meetings"),
              onTap: () {
                Navigator.pushNamed(context, '/meetings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Members"),
              onTap: () {
                Navigator.pushNamed(context, '/members');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Welcome, $userName!',
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: features.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final feature = features[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, feature['route']!);
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            feature['icon']!,
                            width: 64,
                            height: 64,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              feature['label']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (isAdmin) ...[
  const SizedBox(height: 12),
  const Text(
    "Upcoming Meetings",
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  ),
  _AdminMeetingsCalendar(),
],
          ],
        ),
      ),
    );
  }
  
}

// --- GENERAL CHAMA CONTRIBUTIONS SCREEN ---
class GeneralChamaContributionsScreen extends StatelessWidget {
  const GeneralChamaContributionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
     final List<Map<String, String>> contributions = [
  {
    "id": "CHM001",
    "name": "Lucy Nduta Gichuru",
    "phone": "0712345678",
    "date": "2025-06-03",
    "amount": "3,000",
    "status": "Completed",
    "receipt": "MPESAX YZ505"
  },
  {
    "id": "CHM002",
    "name": "David Otieno Owino",
    "phone": "0723456789",
    "date": "2025-06-03",
    "amount": "3,000",
    "status": "Completed",
    "receipt": "MPESAX YZ506"
  },
  {
    "id": "CHM003",
    "name": "Elizabeth Mwake",
    "phone": "0734567890",
    "date": "2025-06-03",
    "amount": "3,000",
    "status": "Completed",
    "receipt": "MPESAX YZ507"
  },
  {
    "id": "CHM004",
    "name": "Jane Nyeri Kamau",
    "phone": "0745678901",
    "date": "2025-06-03",
    "amount": "3,000",
    "status": "Completed",
    "receipt": "MPESAX YZ508"
  },
  {
    "id": "CHM005",
    "name": "Ahmed Nazer Hussein",
    "phone": "0756789012",
    "date": "2025-06-03",
    "amount": "3,000",
    "status": "Completed",
    "receipt": "MPESAX YZ509"
  },
  {
    "id": "CHM006",
    "name": "Mary Atieno Achieng",
    "phone": "0767890123",
    "date": "2025-06-03",
    "amount": "3,000",
    "status": "Completed",
    "receipt": "MPESAX YZ510"
  },
  {
    "id": "CHM007",
    "name": "Samuel Mwangi Thuo",
    "phone": "0778901234",
    "date": "2025-06-03",
    "amount": "3,000",
    "status": "Completed",
    "receipt": "MPESAX YZ511"
  },
  {
    "id": "CHM008",
    "name": "Grace Wanjiku Muriuki",
    "phone": "0789012345",
    "date": "2025-06-03",
    "amount": "3,000",
    "status": "Completed",
    "receipt": "MPESAX YZ512"
  },
  {
    "id": "CHM009",
    "name": "Peter Kiprono Cheruiyot",
    "phone": "0790123456",
    "date": "2025-06-03",
    "amount": "3,000",
    "status": "Completed",
    "receipt": "MPESAX YZ513"
  },
  {
    "id": "CHM010",
    "name": "Catherine Njeri Wambui",
    "phone": "0701234567",
    "date": "2025-06-03",
    "amount": "3,000",
    "status": "Completed",
    "receipt": "MPESAX YZ514"
  },
  {
    "id": "CHM011",
    "name": "John Mwangi Kariuki",
    "phone": "0712345679",
    "date": "2025-06-03",
    "amount": "3,000",
    "status": "Completed",
    "receipt": "MPESAX YZ515"
  },
  {
    "id": "CHM012",
    "name": "Fatuma Hassan Mohamed",
    "phone": "0723456780",
    "date": "2025-06-03",
    "amount": "3,000",
    "status": "Completed",
    "receipt": "MPESAX YZ516"
  },
];

    return Scaffold(
      appBar: AppBar(
        title: const Text("General Chama Contributions"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
             
            const SizedBox(height: 10),
            const Text(
              "GENERAL CHAMA CONTRIBUTIONS",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateColor.resolveWith(
                      (states) => Colors.blueGrey.shade100),
                  columns: const [
                    DataColumn(label: Text("Member ID")),
                    DataColumn(label: Text("Full Name")),
                    DataColumn(label: Text("Phone Number")),
                    DataColumn(label: Text("Payment Date")),
                    DataColumn(label: Text("Amount (KES)")),
                    DataColumn(label: Text("Status")),
                    DataColumn(label: Text("Receipt No.")),
                  ],
                  rows: contributions.map((data) {
                    return DataRow(cells: [
                      DataCell(Text(data["id"]!)),
                      DataCell(Text(data["name"]!)),
                      DataCell(Text(data["phone"]!)),
                      DataCell(Text(data["date"]!)),
                      DataCell(Text(data["amount"]!)),
                      DataCell(
                        Text(
                          data["status"]!,
                          style: TextStyle(
                            color: data["status"] == "Completed"
                                ? Colors.green
                                : data["status"] == "Partial"
                                    ? Colors.orange
                                    : Colors.red,
                            fontWeight: FontWeight.bold,
                            ),
                        ),
                      ),
                      DataCell(Text(data["receipt"]!)),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
Future<void> initiateSTKPush(String phone, String amount, BuildContext context) async {
  final response = await http.post(
    Uri.parse('http://192.168.117.181:3001/mpesa/stkpush'), 
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "phone": phone,  // Example: "254712345678"
      "amount": amount // Example: "100"
    }),
  );

  if (response.statusCode == 200) {
    final res = jsonDecode(response.body);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("STK Push success: ${res['CustomerMessage'] ?? 'Prompt sent!'}")),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("STK Push failed: ${response.body}")),
    );
  }
}

// --- DEPOSITS SCREEN ---
class DepositsScreen extends StatefulWidget {
  const DepositsScreen({super.key});

  @override
  State<DepositsScreen> createState() => _DepositsScreenState();
}

class _DepositsScreenState extends State<DepositsScreen> {
  final phoneController = TextEditingController();
  final amountController = TextEditingController();
  bool _loading = false;

 Future<void> payWithMpesa() async {
  final phone = phoneController.text.trim();
  final amount = amountController.text.trim();

  if (phone.isEmpty || !RegExp(r'^254\d{9}$').hasMatch(phone)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Enter a valid phone (2547XXXXXXXX)")),
    );
    return;
  }
  if (amount.isEmpty || double.tryParse(amount) == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Enter a valid amount")),
    );
    return;
  }

  setState(() => _loading = true);
  await initiateSTKPush(phone, amount, context);
  setState(() => _loading = false);
}
   
  @override
  Widget build(BuildContext context) {
    final Map<String, String> userDetails = {
  "fullName": "Lucy Nduta Gichuru",
  "memberId": "CHM001",
  "joinedDate": "2024-01-10",
  "phone": "+254712345678",
  "groupName": "Kilimani Munna Choma",
  "monthlyTarget": "KES 3,000",
    };

    final List<Map<String, String>> deposits = [
      {
        "month": "January",
        "date": "2024-01-10",
        "amount": "3,000",
        "method": "M-Pesa",
        "receipt": "MPESAXYZ101",
        "status": "Completed"
      },
      {
        "month": "February",
        "date": "2024-02-10",
        "amount": "3,000",
        "method": "M-Pesa",
        "receipt": "MPESAXYZ202",
        "status": "Completed"
      },
      {
        "month": "March",
        "date": "2024-03-10",
        "amount": "3,000",
        "method": "M-Pesa",
        "receipt": "MPESAXYZ203",
        "status": "Completed"
      },
      {
        "month": "April",
        "date": "2024-04-08",
        "amount": "3,000",
        "method": "M-Pesa",
        "receipt": "MPESAXYZ204",
        "status": "Completed"
      },
      {
        "month": "May",
        "date": "2024-05-03",
        "amount": "3,000",
        "method": "M-Pesa",
        "receipt": "MPESAXYZ205",
        "status": "Completed"
      },
      {
        "month": "June",
        "date": "2024-06-07",
        "amount": "3,000",
        "method": "M-Pesa",
        "receipt": "MPESAXYZ206",
        "status": "Completed"
      },
      {
        "month": "July",
        "date": "2024-07-05",
        "amount": "3,000",
        "method": "M-Pesa",
        "receipt": "MPESAXYZ207",
        "status": "Completed"
      },
      {
        "month": "August",
        "date": "2024-08-04",
        "amount": "3,000",
        "method": "M-Pesa",
        "receipt": "MPESAXYZ208",
        "status": "Completed"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Deposits"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Phone Number (2547XXXXXXXX)"),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.phone_android),
                label: const Text("Pay with M-Pesa"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: _loading ? null : payWithMpesa,
              ),
            ),
            const SizedBox(height: 24),
            Text("Full Name: ${userDetails["fullName"]}"),
            Text("Member ID: ${userDetails["memberId"]}"),
            Text("Joined Date: ${userDetails["joinedDate"]}"),
            Text("Phone Number: ${userDetails["phone"]}"),
            Text("Group Name: ${userDetails["groupName"]}"),
            Text("Monthly Target: ${userDetails["monthlyTarget"]}"),
            const SizedBox(height: 20),
            const Text(
              "Deposits",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateColor.resolveWith(
                    (states) => Colors.lightBlue.shade50),
                columns: const [
                  DataColumn(label: Text("Month")),
                  DataColumn(label: Text("Contribution Date")),
                  DataColumn(label: Text("Amount (KES)")),
                  DataColumn(label: Text("Payment Method")),
                  DataColumn(label: Text("Receipt No.")),
                  DataColumn(label: Text("Status")),
                ],
                rows: deposits.map((data) {
                  return DataRow(cells: [
                    DataCell(Text(data["month"]!)),
                    DataCell(Text(data["date"]!)),
                    DataCell(Text(data["amount"]!)),
                    DataCell(Text(data["method"]!)),
                    DataCell(Text(data["receipt"]!)),
                    DataCell(
                      Text(
                        data["status"]!,
                        style: TextStyle(
                          color: data["status"] == "Completed"
                              ? Colors.green
                              : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- WITHDRAWALS SCREEN ---
class WithdrawalsScreen extends StatelessWidget {
  const WithdrawalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> withdrawals = [
      {
        "date": "2025-06-01",
        "amount": "2,000",
        "method": "M-Pesa",
        "destination": "0712345678",
        "status": "Success"
      },
      {
        "date": "2025-05-15",
        "amount": "1,500",
        "method": "Bank Transfer",
        "destination": "Equity Bank",
        "status": "Success"
      },
      {
        "date": "2025-04-20",
        "amount": "1,000",
        "method": "M-Pesa",
        "destination": "0723456789",
        "status": "Success"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdrawals'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recent Withdrawals",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: withdrawals.length,
                itemBuilder: (context, index) {
                  final withdrawal = withdrawals[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.swap_vert, color: Colors.green),
                      title: Text('KES ${withdrawal["amount"]}'),
                      subtitle: Text('${withdrawal["method"]} • ${withdrawal["date"]}'),
                      trailing: Text(
                        withdrawal["status"]!,
                        style: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.w600),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- PROFITS AND DIVIDENDS SCREEN ---
class ProfitsAndDividendsScreen extends StatelessWidget {
  const ProfitsAndDividendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
     final List<Map<String, String>> membersData = [
  {'id': 'CHM001', 'name': 'Lucy Nduta Gichuru', 'contributions': '12,000', 'share': '10%', 'dividend': '3,000', 'status': 'Paid'},
  {'id': 'CHM002', 'name': 'David Otieno Owino', 'contributions': '12,000', 'share': '10%', 'dividend': '3,000', 'status': 'Paid'},
  {'id': 'CHM003', 'name': 'Elizabeth Mwake', 'contributions': '12,000', 'share': '10%', 'dividend': '3,000', 'status': 'Paid'},
  {'id': 'CHM004', 'name': 'Jane Nyeri Kamau', 'contributions': '12,000', 'share': '10%', 'dividend': '3,000', 'status': 'Paid'},
  {'id': 'CHM005', 'name': 'Ahmed Nazer Hussein', 'contributions': '12,000', 'share': '10%', 'dividend': '3,000', 'status': 'Paid'},
  {'id': 'CHM006', 'name': 'Mary Atieno Achieng', 'contributions': '12,000', 'share': '10%', 'dividend': '3,000', 'status': 'Paid'},
  {'id': 'CHM007', 'name': 'Samuel Mwangi Thuo', 'contributions': '12,000', 'share': '10%', 'dividend': '3,000', 'status': 'Paid'},
  {'id': 'CHM008', 'name': 'Grace Wanjiku Muriuki', 'contributions': '12,000', 'share': '10%', 'dividend': '3,000', 'status': 'Paid'},
  {'id': 'CHM009', 'name': 'Peter Kiprono Cheruiyot', 'contributions': '12,000', 'share': '10%', 'dividend': '3,000', 'status': 'Paid'},
  {'id': 'CHM010', 'name': 'Catherine Njeri Wambui', 'contributions': '12,000', 'share': '10%', 'dividend': '3,000', 'status': 'Paid'},
  {'id': 'CHM011', 'name': 'John Mwangi Kariuki', 'contributions': '12,000', 'share': '10%', 'dividend': '3,000', 'status': 'Paid'},
  {'id': 'CHM012', 'name': 'Fatuma Hassan Mohamed', 'contributions': '12,000', 'share': '10%', 'dividend': '3,000', 'status': 'Paid'},
];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profits and Dividends'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor:
                WidgetStateColor.resolveWith((states) => Colors.grey.shade200),
            columns: const [
              DataColumn(label: Text('Member ID')),
              DataColumn(label: Text('Full Name')),
              DataColumn(label: Text('Total Contributions (KES)')),
              DataColumn(label: Text('Profit Share')),
              DataColumn(label: Text('Dividend Earned (KES)')),
              DataColumn(label: Text('Status')),
            ],
            rows: membersData.map((member) {
              return DataRow(
                cells: [
                  DataCell(Text(member['id']!)),
                  DataCell(Text(member['name']!)),
                  DataCell(Text(member['contributions']!)),
                  DataCell(Text(member['share']!)),
                  DataCell(Text(member['dividend']!)),
                  DataCell(Text(
                    member['status']!,
                    style: TextStyle(
                      color: member['status'] == 'Paid' ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// --- LOAN REQUEST FORM SCREEN ---
class LoanRequestFormScreen extends StatefulWidget {
  const LoanRequestFormScreen({super.key});

  @override
  State<LoanRequestFormScreen> createState() => _LoanRequestFormScreenState();
}

class _LoanRequestFormScreenState extends State<LoanRequestFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String? selectedMemberId;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController loanAmountController = TextEditingController();
  final TextEditingController repaymentPeriodController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();

   final List<Map<String, String>> membersList = [
  {'id': 'CHM001', 'name': 'Lucy Nduta Gichuru'},
  {'id': 'CHM002', 'name': 'David Otieno Owino'},
  {'id': 'CHM003', 'name': 'Elizabeth Mwake'},
  {'id': 'CHM004', 'name': 'Jane Nyeri Kamau'},
  {'id': 'CHM005', 'name': 'Ahmed Nazer Hussein'},
  {'id': 'CHM006', 'name': 'Mary Atieno Achieng'},
  {'id': 'CHM007', 'name': 'Samuel Mwangi Thuo'},
  {'id': 'CHM008', 'name': 'Grace Wanjiku Muriuki'},
  {'id': 'CHM009', 'name': 'Peter Kiprono Cheruiyot'},
  {'id': 'CHM010', 'name': 'Catherine Njeri Wambui'},
  {'id': 'CHM011', 'name': 'John Mwangi Kariuki'},
  {'id': 'CHM012', 'name': 'Fatuma Hassan Mohamed'},
];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loan Request Form'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Member ID'),
                value: selectedMemberId,
                items: membersList.map((member) {
                  return DropdownMenuItem(
                    value: member['id'],
                    child: Text(member['id']!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMemberId = value;
                    fullNameController.text = membersList
                        .firstWhere((m) => m['id'] == value)['name']!;
                  });
                },
                validator: (value) => value == null ? 'Please select a member' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: fullNameController,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: loanAmountController,
                decoration: const InputDecoration(labelText: 'Loan Amount (KES)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter loan amount';
                  final num? amount = num.tryParse(value);
                  if (amount == null) return 'Amount must be a number';
                  if (amount < 1000 || amount > 1000000) return 'Amount must be between 1,000 and 1,000,000';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: repaymentPeriodController,
                decoration: const InputDecoration(labelText: 'Repayment Period (months)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter repayment period';
                  final int? months = int.tryParse(value);
                  if (months == null) return 'Must be a number';
                  if (months < 1 || months > 60) return 'Period must be 1-60 months';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: purposeController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Loan Purpose'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter purpose';
                  if (value.length < 5) return 'Purpose must be at least 5 characters';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Loan request submitted!')),
                    );
                  }
                },
                child: const Text('Submit Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//LOAN APPROVAL SCREEN
 class LoanApprovalScreen extends StatefulWidget {
  const LoanApprovalScreen({super.key});
  @override
  State<LoanApprovalScreen> createState() => _LoanApprovalScreenState();
}

class _LoanApprovalScreenState extends State<LoanApprovalScreen> {
  
  List<Map<String, dynamic>> loanRequests = [
    {
      'id': 'CHM001',
      'name': 'Lucy Nduta Gichuru',
      'amount': '10,000',
      'period': '12',
      'purpose': 'Business expansion',
      'status': 'Pending'
    },
    {
      'id': 'CHM002',
      'name': 'David Otieno Owino',
      'amount': '5,000',
      'period': '6',
      'purpose': 'School fees',
      'status': 'Pending'
    },
    {
      'id': 'CHM003',
      'name': 'Elizabeth Mwake',
      'amount': '8,000',
      'period': '10',
      'purpose': 'Medical emergency',
      'status': 'Pending'
    },
  ];

  void _updateStatus(int index, String newStatus) {
    setState(() {
      loanRequests[index]['status'] = newStatus;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Loan ${newStatus.toLowerCase()} for ${loanRequests[index]['name']}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Loan Approval")),
      body: loanRequests.isEmpty
          ? const Center(child: Text("No pending loan requests."))
          : ListView.builder(
              itemCount: loanRequests.length,
              itemBuilder: (context, index) {
                final req = loanRequests[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text("${req['name']} (${req['id']})"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Amount: KES ${req['amount']}"),
                        Text("Period: ${req['period']} months"),
                        Text("Purpose: ${req['purpose']}"),
                        Text("Status: ${req['status']}",
                          style: TextStyle(
                            color: req['status'] == "Pending"
                                ? Colors.orange
                                : req['status'] == "Approved"
                                    ? Colors.green
                                    : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: req['status'] == "Pending"
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check, color: Colors.green),
                                tooltip: "Approve",
                                onPressed: () => _updateStatus(index, "Approved"),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                tooltip: "Reject",
                                onPressed: () => _updateStatus(index, "Rejected"),
                              ),
                            ],
                          )
                        : null,
                  ),
                );
              },
            ),
    );
  }
}

// --- FINES INCURRED SCREEN ---
class FinesIncurredScreen extends StatelessWidget {
  const FinesIncurredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> fines = [
  {"member": "Lucy Nduta Gichuru", "reason": "Late payment", "amount": "KES 200"},
  {"member": "David Otieno Owino", "reason": "Missed meeting", "amount": "KES 150"},
  {"member": "Elizabeth Mwake", "reason": "Missed deadline", "amount": "KES 100"},
  {"member": "Jane Nyeri Kamau", "reason": "Late payment", "amount": "KES 200"},
  {"member": "Ahmed Nazer Hussein", "reason": "Missed meeting", "amount": "KES 150"},
  {"member": "Mary Atieno Achieng", "reason": "Missed deadline", "amount": "KES 100"},
];

    return Scaffold(
      appBar: AppBar(title: const Text("Fines Incurred")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: fines.length,
          itemBuilder: (context, index) {
            final fine = fines[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.warning_amber_rounded, color: Colors.red),
                title: Text(fine['member']!),
                subtitle: Text(fine['reason']!),
                trailing: Text(fine['amount']!),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add fine logic here
        },
        tooltip: 'Add Fine',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// --- CHAT ROOM SCREEN ---
class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _controller = TextEditingController();
   final List<Map<String, dynamic>> messages = [
  {"text": "Hi everyone!", "sender": "Lucy Nduta Gichuru"},
  {"text": "Hello Lucy!", "sender": "David Otieno Owino"},
  {"text": "How is everyone doing?", "sender": "Elizabeth Mwake"},
  {"text": "All good here!", "sender": "Jane Nyeri Kamau"},
  {"text": "Ready for the next meeting.", "sender": "Ahmed Nazer Hussein"},
  {"text": "Looking forward to it!", "sender": "Mary Atieno Achieng"},
];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    if (text.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message too short!')),
      );
      return;
    }
    setState(() {
      messages.add({"text": text, "sender": "You"});
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chama Chat Room")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[messages.length - 1 - index];
                final isMe = msg['sender'] == "You";
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.green[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg['sender'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(msg['text']),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: "Enter message..."),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: _sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// --- MEETINGS SCREEN ---
class MeetingsScreen extends StatelessWidget {
  const MeetingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DateTime> meetings = [
      DateTime.now().add(const Duration(days: 2)),
      DateTime.now().add(const Duration(days: 7)),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Meetings")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Upcoming Meetings",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: DateTime.now(),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (meetings.any((m) =>
                      m.year == date.year &&
                      m.month == date.month &&
                      m.day == date.day)) {
                    return const Icon(Icons.event, color: Colors.green, size: 16);
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- MEMBERS SCREEN ---
class MembersScreen extends StatelessWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Members")),
      body: ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(members[index]),
          );
        },
      ),
    );
  }
}

// --- AI ASSISTANT DIALOG  ---
class AIAssistantDialog extends StatefulWidget {
  const AIAssistantDialog({super.key});
  @override
  State<AIAssistantDialog> createState() => _AIAssistantDialogState();
}

class _AIAssistantDialogState extends State<AIAssistantDialog> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _responses = [];
 void _sendMessage() async {
  final text = _controller.text.trim();
  if (text.isEmpty) return;
  setState(() {
    _responses.add("You: $text");
  });
  final aiResponse = await getGeminiResponse(text);
  setState(() {
    _responses.add("AI: $aiResponse");
    _controller.clear();
  });
}
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("AI Assistant"),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: _responses.map((r) => Text(r)).toList(),
              ),
            ),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: "Ask me anything..."),
              onSubmitted: (_) => _sendMessage(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
        ElevatedButton(
          onPressed: _sendMessage,
          child: const Text("Send"),
        ),
      ],
    );
  }
} 
// GEMINI FUNCTION FOR AI ASSISTANT
Future<String> getGeminiResponse(String prompt) async {
  final url = Uri.parse('http://192.168.56.1:3001/gemini/ask'); // Use your backend IP
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({"prompt": prompt});

  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['text'] ?? "No response";
  } else {
    return "Error: ${response.body}";
  }
}
// ADMIN MEETINGS CALENDAR WIDGET
class _AdminMeetingsCalendar extends StatefulWidget {
  @override
  State<_AdminMeetingsCalendar> createState() => _AdminMeetingsCalendarState();
}

class _AdminMeetingsCalendarState extends State<_AdminMeetingsCalendar> {
  List<DateTime> meetings = [
    DateTime.now().add(const Duration(days: 2)),
    DateTime.now().add(const Duration(days: 7)),
  ];

  void _addMeetingDate(DateTime date) {
    setState(() {
      meetings.add(date);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Meeting added for ${date.toLocal()}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 350,
          child: TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: DateTime.now(),
            selectedDayPredicate: (date) =>
                meetings.any((m) =>
                    m.year == date.year &&
                    m.month == date.month &&
                    m.day == date.day),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (meetings.any((m) =>
                    m.year == date.year &&
                    m.month == date.month &&
                    m.day == date.day)) {
                  return const Icon(Icons.event, color: Colors.green, size: 16);
                }
                return null;
              },
            ),
            onDaySelected: (selectedDay, focusedDay) {
              if (!meetings.any((m) =>
                  m.year == selectedDay.year &&
                  m.month == selectedDay.month &&
                  m.day == selectedDay.day)) {
                _addMeetingDate(selectedDay);
              }
            },
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Tap a date to add a meeting.",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

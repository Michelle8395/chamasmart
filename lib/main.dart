import 'package:flutter/material.dart';

void main() {
  runApp(const ChamaSmartApp());
}

class ChamaSmartApp extends StatelessWidget {
  const ChamaSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChamaSmart',
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
        '/fines': (context) => FinesIncurredScreen(),
        '/chat': (context) => ChatRoomScreen(),
      },
    );
  }
}

List<String> members = [];
String? admin;

// SPLASH SCREEN
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/terms');
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Images/Chamasmart_logo.jpg',
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
  final _usernameController = TextEditingController();
  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text.trim();
      if (members.contains(username)) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not found. Please register.")),
        );
      }
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
                  "USERNAME",
                  _usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Username is required";
                    if (value.length < 3 || value.length > 15) return "Username must be 3-15 characters";
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

  void _register() {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text.trim();
      if (members.contains(name)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User already exists. Please login.")),
        );
        return;
      }
      members.add(name);
      if (members.length == 1) {
        admin = name;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Verification code sent via SMS")),
      );
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
                "After you tap sign up, you will receive a one-time code via SMS. Kindly enter the verification code below.",
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
              "Enter the one-time verification code sent via SMS:",
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
                Navigator.pushNamed(context, '/dashboard');
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

// DASHBOARD SCREEN
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/register');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final String userName = members.last;

    final List<Map<String, String>> features = [
      {"label": "GENERAL CHAMA CONTRIBUTIONS", "icon": "placeholder"},
      {"label": "DEPOSITS", "icon": "placeholder"},
      {"label": "WITHDRAWALS", "icon": "placeholder"},
      {"label": "PROFITS & DIVIDENDS", "icon": "placeholder"},
      {"label": "LOAN REQUEST FORM", "icon": "placeholder"},
      {"label": "FINES INCURRED", "icon": "placeholder"},
      {"label": "GENERAL CHAMA CHAT ROOM", "icon": "placeholder"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("CHAMaSMART"),
        actions: const [
          Icon(Icons.arrow_drop_down),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: const [
            DrawerHeader(child: Text("Menu")),
            ListTile(title: Text("Dashboard")),
            ListTile(title: Text("Settings")),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello and welcome $userName",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 1,
                children: features.map((feature) {
                  return InkWell(
                    onTap: () {
                      if (feature["label"] == "GENERAL CHAMA CONTRIBUTIONS") {
                        Navigator.pushNamed(context, '/contributions');
                      } else if (feature["label"] == "DEPOSITS") {
                        Navigator.pushNamed(context, '/deposits');
                      } else if (feature["label"] == "WITHDRAWALS") {
                        Navigator.pushNamed(context, '/withdrawals');
                      } else if (feature["label"] == "PROFITS & DIVIDENDS") {
                        Navigator.pushNamed(context, '/profits');
                      } else if (feature["label"] == "LOAN REQUEST FORM") {
                        Navigator.pushNamed(context, '/loan-request');
                      } else if (feature["label"] == "FINES INCURRED") {
                        Navigator.pushNamed(context, '/fines');
                      } else if (feature["label"] == "GENERAL CHAMA CHAT ROOM") {
                        Navigator.pushNamed(context, '/chat');
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.crop_square, size: 40),
                        const SizedBox(height: 8),
                        Text(
                          feature["label"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// GENERAL CHAMA CONTRIBUTIONS SCREEN
class GeneralChamaContributionsScreen extends StatelessWidget {
  const GeneralChamaContributionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> contributions = [
      {
        "id": "CHM001",
        "name": "Jane Njeri Kamau",
        "phone": "0712345678",
        "date": "2025-06-03",
        "amount": "3,000",
        "status": "Completed",
        "receipt": "MPESAX YZ505"
      },
      {
        "id": "CHM002",
        "name": "David Otieno Owino",
        "phone": "0722456789",
        "date": "2025-06-04",
        "amount": "3,000",
        "status": "Completed",
        "receipt": "MPESAX YZ506"
      },
      {
        "id": "CHM003",
        "name": "Alice Wanjiku Murungi",
        "phone": "0733567890",
        "date": "2025-05-10",
        "amount": "1,500",
        "status": "Partial",
        "receipt": "BANKTR F3301"
      },
      {
        "id": "CHM004",
        "name": "Kevin Kiprono Kibet",
        "phone": "0744678901",
        "date": "2025-05-09",
        "amount": "0",
        "status": "Missed",
        "receipt": "-"
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
                  headingRowColor: MaterialStateColor.resolveWith(
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

// DEPOSITS SCREEN
class DepositsScreen extends StatelessWidget {
  const DepositsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> userDetails = {
      "fullName": "Charlie Pele",
      "memberId": "CHM001",
      "joinedDate": "2024-01-10",
      "phone": "+254712345678",
      "groupName": "Kilimani munna choma",
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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateColor.resolveWith(
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
            ),
          ],
        ),
      ),
    );
  }
}

// WITHDRAWALS SCREEN
class WithdrawalsScreen extends StatelessWidget {
  const WithdrawalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdraw Funds'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Available Balance',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'KES 7,000',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Enter Withdrawal Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            // Add validation if you want to make this a form
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount (KES)',
                prefixIcon: const Icon(Icons.money),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(value: 'mpesa', child: Text('M-Pesa')),
                DropdownMenuItem(value: 'bank', child: Text('Bank Transfer')),
              ],
              decoration: InputDecoration(
                labelText: 'Withdrawal Method',
                prefixIcon: const Icon(Icons.account_balance_wallet),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Destination (Phone/Bank)',
                prefixIcon: const Icon(Icons.send),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Withdraw'),
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Recent Withdrawals',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return const ListTile(
                  leading: Icon(Icons.swap_vert, color: Colors.green),
                  title: Text('KES 1,000'),
                  subtitle: Text('M-Pesa • 2025-06-04'),
                  trailing: Text(
                    'Success',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// PROFITS AND DIVIDENDS
class ProfitsAndDividendsScreen extends StatelessWidget {
  const ProfitsAndDividendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> members = [
      {
        'id': 'CHM001',
        'name': 'Lucy Nduta Gichuru',
        'contributions': '12,000',
        'share': '10%',
        'dividend': '3,000',
        'status': 'Paid'
      },
      {
        'id': 'CHM002',
        'name': 'David Otieno Owino',
        'contributions': '12,000',
        'share': '10%',
        'dividend': '3,000',
        'status': 'Paid'
      },
      {
        'id': 'CHM003',
        'name': 'Elizabeth Mwake',
        'contributions': '9,000',
        'share': '7.5%',
        'dividend': '2,250',
        'status': 'Paid'
      },
      {
        'id': 'CHM004',
        'name': 'Jane Nyeri Kamau',
        'contributions': '6,000',
        'share': '5%',
        'dividend': '1,500',
        'status': 'Paid'
      },
      {
        'id': 'CHM005',
        'name': 'Ahmed Nazer Hussein',
        'contributions': '6,000',
        'share': '5%',
        'dividend': '1,500',
        'status': 'Paid'
      },
      {
        'id': 'CHM006',
        'name': 'Mary Atieno Achieng',
        'contributions': '6,000',
        'share': '5%',
        'dividend': '1,500',
        'status': 'Paid'
      },
      {
        'id': 'CHM007',
        'name': 'Samuel Mwangi Thuo',
        'contributions': '6,000',
        'share': '5%',
        'dividend': '1,500',
        'status': 'Paid'
      },
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
                MaterialStateColor.resolveWith((states) => Colors.grey.shade200),
            columns: const [
              DataColumn(label: Text('Member ID')),
              DataColumn(label: Text('Full Name')),
              DataColumn(label: Text('Total Contributions (KES)')),
              DataColumn(label: Text('Profit Share')),
              DataColumn(label: Text('Dividend Earned (KES)')),
              DataColumn(label: Text('Status')),
            ],
            rows: members.map((member) {
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

// LOAN REQUEST FORM
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

  final List<Map<String, String>> members = [
    {'id': 'CHM001', 'name': 'Lucy Nduta Gichuru'},
    {'id': 'CHM002', 'name': 'David Otieno Owino'},
    {'id': 'CHM003', 'name': 'Elizabeth Mwake'},
    {'id': 'CHM004', 'name': 'Jane Nyeri Kamau'},
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
                items: members.map((member) {
                  return DropdownMenuItem(
                    value: member['id'],
                    child: Text(member['id']!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMemberId = value;
                    fullNameController.text = members
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

// FINES INCURRED SCREEN
class FinesIncurredScreen extends StatelessWidget {
  final List<Map<String, String>> fines = [
    {"member": "Jane Doe", "reason": "Late payment", "amount": "KES 200"},
    {"member": "John Smith", "reason": "Missed meeting", "amount": "KES 150"},
  ];

  @override
  Widget build(BuildContext context) {
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
        child: const Icon(Icons.add),
        tooltip: 'Add Fine',
      ),
    );
  }
}

// GENERAL CHAMA CHAT ROOM
class ChatRoomScreen extends StatefulWidget {
  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> messages = [
    {"text": "Hi everyone!", "sender": "Jane"},
    {"text": "Hello Jane!", "sender": "John"},
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

import 'package:expense_tracker/helper/database_helper.dart';
import 'package:expense_tracker/pages/home_page.dart';
import 'package:expense_tracker/pages/transactions_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create DB and tables
  await DatabaseHelper.instance.database;

  // Insert default expense types
  await DatabaseHelper.instance.insertDefaultExpenseTypes();

  await DatabaseHelper.instance.insertDefaultAccounts();
  await DatabaseHelper.instance.insertDefaultTransactions();

  // DatabaseHelper.instance.fetchAllExpenses().then(
  //   (value) => {print(value.toString())},
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fade-In Pages',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const FadeIndexedApp(),
    );
  }
}

class FadeIndexedApp extends StatefulWidget {
  const FadeIndexedApp({super.key});
  @override
  State<FadeIndexedApp> createState() => _FadeIndexedAppState();
}

class _FadeIndexedAppState extends State<FadeIndexedApp>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  void _onItemTapped(int index) async {
    if (index == _currentIndex) return;

    await _fadeController.reverse();
    setState(() => _currentIndex = index);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _getPage(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        backgroundColor: Colors.blueGrey[800],
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: "Transactions",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Stats"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}

class _PageWidget extends StatelessWidget {
  final String title;
  final Color color;

  const _PageWidget({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withOpacity(0.1),
      child: Center(child: Text(title, style: const TextStyle(fontSize: 28))),
    );
  }
}

Widget _getPage(int index) {
  switch (index) {
    case 0:
      return HomePage();
    case 1:
      return TransactionsPage(); // will rebuild every time
    case 2:
      return _PageWidget(title: "Stats", color: Colors.deepOrange);
    case 3:
      return _PageWidget(title: "Settings", color: Colors.green);

    default:
      return HomePage();
  }
}

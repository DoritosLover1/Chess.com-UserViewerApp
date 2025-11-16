import 'package:chess_viewer/Classes/PlayerProfile.dart';
import 'package:chess_viewer/Classes/PlayerProfileCard.dart';
import 'package:chess_viewer/Classes/PlayerStats.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'functions/apifunctions.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String _username = '';
  PlayerProfile? _playerProfile;
  bool _isLoading = false;

  void _handleSearch(String username) {
    setState(() {
      _username = username;
    });
  }

  Future<void> _searchUser(BuildContext context) async {
    if (_username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a username')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final profile = await ChessApiService().getPlayerProfile(_username);
      setState(() {
        _playerProfile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (BuildContext scaffoldContext) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(242, 255, 255, 255),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "For Chess.com",
                    style: GoogleFonts.lato(
                      fontSize: 24,
                      color: const Color.fromARGB(255, 98, 175, 67),
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 50),
                  SearchBarWidget(onSearch: _handleSearch),
                  const SizedBox(height: 30),
                  if (_playerProfile != null)
                    Expanded(
                      child: SingleChildScrollView(
                        child: ProfileCard(profile: _playerProfile!),
                    ),
                  ),
                  SearchButtonWidget(
                    username: _username,
                    isLoading: _isLoading,
                    onPressed: () => _searchUser(scaffoldContext),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearch;

  const SearchBarWidget({super.key, required this.onSearch});

  @override
  _SearchScreenWidget createState() => _SearchScreenWidget();
}

class _SearchScreenWidget extends State<SearchBarWidget> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _inputController,
      onChanged: (value) => widget.onSearch(value),
      onSubmitted: (value) => widget.onSearch(value),
      decoration: InputDecoration(
        suffixIcon: const Icon(
          Icons.search_rounded,
          color: Color.fromARGB(255, 133, 133, 133),
        ),
        hintText: "Enter Username",
        hintStyle: GoogleFonts.lato(
          fontSize: 14,
          color: Colors.grey[400],
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color.fromARGB(255, 98, 175, 67)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}

class SearchButtonWidget extends StatelessWidget {
  final String username;
  final bool isLoading;
  final VoidCallback onPressed;

  const SearchButtonWidget({
    super.key,
    required this.username,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          backgroundColor: const Color.fromARGB(255, 98, 175, 67),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                "Search User",
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
    );
  }
}
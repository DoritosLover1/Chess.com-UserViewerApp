import 'package:chess_viewer/Classes/PlayerProfile.dart';
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

  Future<void> _searchUser() async {
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
      home: Scaffold(
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
            ],
          ),
        ),
        bottomSheet: SearchButtonWidget(
          username: _username,
          isLoading: _isLoading,
          onPressed: _searchUser,
        ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
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
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final PlayerProfile profile;

  const ProfileCard({super.key, required this.profile});

  String _formatTimestamp(int? timestamp) {
    if (timestamp == null) return 'Unknown';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatLastOnline(int? timestamp) {
    if (timestamp == null) return 'Unknown';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  profile.username,
                  style: GoogleFonts.lato(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 98, 175, 67),
                  ),
                ),
                if (profile.verified == true) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.verified,
                    color: Color.fromARGB(255, 98, 175, 67),
                    size: 24,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),
            if (profile.status != null && profile.status!.isNotEmpty)
              _buildInfoRow(Icons.info_outline, 'Status', profile.status!),
            if (profile.country != null && profile.country!.isNotEmpty)
              _buildInfoRow(Icons.flag, 'Country', profile.country!),
            if (profile.followers != null)
              _buildInfoRow(
                Icons.people,
                'Followers',
                profile.followers.toString(),
              ),
            if (profile.joined != null)
              _buildInfoRow(
                Icons.calendar_today,
                'Joined',
                _formatTimestamp(profile.joined),
              ),
            if (profile.lastOnline != null)
              _buildInfoRow(
                Icons.access_time,
                'Last Online',
                _formatLastOnline(profile.lastOnline),
              ),
            if (profile.streamingPlatforms != null &&
                profile.streamingPlatforms!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Streaming Platforms:',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              ...profile.streamingPlatforms!.map((platform) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: Text(
                    '• ${platform.toString()}',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Text(
                  '$label: ',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                Expanded(
                  child: Text(
                    value,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
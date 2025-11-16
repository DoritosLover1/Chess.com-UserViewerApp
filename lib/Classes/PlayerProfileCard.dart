import 'package:chess_viewer/Classes/PlayerProfile.dart';
import 'package:chess_viewer/Classes/PlayerProfilePage.dart';
import 'package:chess_viewer/Classes/PlayerStats.dart';
import 'package:chess_viewer/functions/apifunctions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfileCard extends StatefulWidget {
  final PlayerProfile profile;
  
  const ProfileCard({super.key, required this.profile});

  @override
  _ProfileCard createState() => _ProfileCard();
}

class _ProfileCard extends State<ProfileCard> {
  bool _isLoadingStats = false;

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

  Future<void> _navigateToDetails() async {
    setState(() {
      _isLoadingStats = true;
    });

    try {
      final stats = await ChessApiService().getPlayerStats(widget.profile.username);
      
      setState(() {
        _isLoadingStats = false;
      });
      
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerProfilePage(
              profile: widget.profile,
              stats: stats,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoadingStats = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading stats: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
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
                  widget.profile.username,
                  style: GoogleFonts.lato(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 98, 175, 67),
                  ),
                ),
                if (widget.profile.verified == true) ...[
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
            if (widget.profile.status != null && widget.profile.status!.isNotEmpty)
              _buildInfoRow(Icons.info_outline, 'Status', widget.profile.status!),
            if (widget.profile.followers != null)
              _buildInfoRow(
                Icons.people,
                'Followers',
                widget.profile.followers.toString(),
              ),
            if (widget.profile.joined != null)
              _buildInfoRow(
                Icons.calendar_today,
                'Joined',
                _formatTimestamp(widget.profile.joined),
              ),
            if (widget.profile.lastOnline != null)
              _buildInfoRow(
                Icons.access_time,
                'Last Online',
                _formatLastOnline(widget.profile.lastOnline),
              ),
            if (widget.profile.streamingPlatforms != null &&
                widget.profile.streamingPlatforms!.isNotEmpty) ...[
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
              ...widget.profile.streamingPlatforms!.map((platform) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: InkWell(
                  onTap: () async {
                    final url = platform["channel_url"];
                    if (await canLaunchUrlString(url)) {
                      await launchUrlString(url, mode: LaunchMode.externalApplication);
                    } else {
                      if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Could not launch URL')),
                        );
                      }
                    }
                  },
                  child: Text(
                    '• ${platform["channel_url"]}',
                    style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.blueAccent, // Link gibi görünsün
                      ),
                    ),
                  ) 
                );
              }).toList(),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoadingStats ? null : _navigateToDetails,
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  backgroundColor: const Color.fromARGB(255, 98, 175, 67),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: _isLoadingStats
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "See Details",
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
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
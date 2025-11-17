import 'package:chess_viewer/Classes/PlayerProfile.dart';
import 'package:chess_viewer/Classes/PlayerStats.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class PlayerProfilePage extends StatefulWidget {
  final PlayerProfile profile;
  final PlayerStats stats;

  const PlayerProfilePage({
    super.key,
    required this.profile,
    required this.stats,
  });

  @override
  _PlayerProfilePage createState() => _PlayerProfilePage();
}

class _PlayerProfilePage extends State<PlayerProfilePage> {

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
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "User Informations",
          style: GoogleFonts.lato(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 98, 175, 67)
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          }, 
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color.fromARGB(255, 133, 133, 133)
          )
        ),
      ),
      backgroundColor: const Color.fromARGB(242, 255, 255, 255),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.stats.fideRating != null)
                _buildStatCard(
                  title: "FIDE Rating",
                  value: widget.stats.fideRating.toString(),
                  icon: Icons.emoji_events,
                  color: const Color.fromARGB(255, 255, 193, 7),
                ),
              
              const SizedBox(height: 15),

              if (widget.stats.chessBullet != null)
                _buildChessModeCard(
                  title: "Bullet",
                  mode: widget.stats.chessBullet!,
                  color: const Color.fromARGB(255, 244, 67, 54),
                ),
              
              const SizedBox(height: 15),

              if (widget.stats.chessBlitz != null)
                _buildChessModeCard(
                  title: "Blitz",
                  mode: widget.stats.chessBlitz!,
                  color: const Color.fromARGB(255, 255, 152, 0),
                ),
              
              const SizedBox(height: 15),

              if (widget.stats.chessRapid != null)
                _buildChessModeCard(
                  title: "Rapid",
                  mode: widget.stats.chessRapid!,
                  color: const Color.fromARGB(255, 76, 175, 80),
                ),
              
              const SizedBox(height: 15),

              if (widget.stats.chessDaily != null)
                _buildChessModeCard(
                  title: "Daily",
                  mode: widget.stats.chessDaily!,
                  color: const Color.fromARGB(255, 33, 150, 243),
                ),
              
              const SizedBox(height: 15),

              if (widget.stats.tactics != null)
                _buildTacticsCard(widget.stats.tactics!),
              
              const SizedBox(height: 15),

              if (widget.stats.puzzleRush != null)
                _buildPuzzleRushCard(widget.stats.puzzleRush!),
              
              const SizedBox(height: 15),

              _buildShareButtons(widget.profile, widget.stats)
            ],
          ),
        )
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.lato(
                    fontSize: 28,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChessModeCard({
    required String title,
    required ChessMode mode,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    title,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            if (mode.last != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Current Rating",
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    mode.last!.rating.toString(),
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            
            const SizedBox(height: 10),
            
            if (mode.best != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Best Rating",
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    mode.best!.rating.toString(),
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            
            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 10),
            
            if (mode.record != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildRecordItem("Wins", mode.record!.win, Colors.green),
                  _buildRecordItem("Losses", mode.record!.loss, Colors.red),
                  _buildRecordItem("Draws", mode.record!.draw, Colors.orange),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: GoogleFonts.lato(
            fontSize: 20,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildTacticsCard(Tactics tactics) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tactics",
              style: GoogleFonts.lato(
                fontSize: 18,
                color: const Color.fromARGB(255, 98, 175, 67),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Highest",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      tactics.highest!.rating.toString(),
                      style: GoogleFonts.lato(
                        fontSize: 24,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Lowest",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      tactics.lowest!.rating.toString(),
                      style: GoogleFonts.lato(
                        fontSize: 24,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPuzzleRushCard(PuzzleRush puzzleRush) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Puzzle Rush",
              style: GoogleFonts.lato(
                fontSize: 18,
                color: const Color.fromARGB(255, 156, 39, 176),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Best Score",
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  puzzleRush.best!.score.toString(),
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Attempts",
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  puzzleRush.best!.totalAttempts.toString(),
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareButtons(PlayerProfile pp, PlayerStats ps) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        clipBehavior: Clip.antiAlias,
        color: const Color.fromARGB(255, 98, 175, 67),
        child:MaterialButton(
          elevation: 3.0,
          onPressed: () async {
            await SharePlus.instance.share(
              ShareParams(text: 
                Text("""
------------PLAYER INFORMATIONS------------
• ${pp.username},
• ${pp.status},
• ${_formatLastOnline(pp.lastOnline)},
------------PLAYER DETAILED INFORMATIONS------------
• FIDE:
  • ${ps.fideRating},
• Blitz:
  • ${ps.chessBlitz?.best?.rating},
  • ${ps.chessBlitz?.last?.rating},
• Bullet:
  • ${ps.chessBullet?.best?.rating},
  • ${ps.chessBullet?.last?.rating},
• Daily:
  • ${ps.chessDaily?.best?.rating},
  • ${ps.chessDaily?.last?.rating},
• Tactics:
  • ${ps.tactics?.highest?.rating},
  • ${ps.tactics?.lowest?.rating},
            """).data 
            )
          );
        },
        child: Text(
          "Share",
          style: GoogleFonts.lato(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      ), 
    );
  }
}
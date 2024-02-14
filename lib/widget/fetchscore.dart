import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardWidget extends StatelessWidget {
  const LeaderboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('userScores').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<DocumentSnapshot> documents = snapshot.data!.docs;

        // Sort the documents based on the best score (descending) and total time played (ascending)
        documents.sort((a, b) {
          int scoreA = a['bestScore'] as int? ?? 0;
          int scoreB = b['bestScore'] as int? ?? 0;
          int timeA = (a['minute'] as int? ?? 0) * 60 + (a['timePlayed'] as int? ?? 0);
          int timeB = (b['minute'] as int? ?? 0) * 60 + (b['timePlayed'] as int? ?? 0);

          if (scoreA != scoreB) {
            // Sort by best score (descending)
            return scoreB.compareTo(scoreA);
          } else {
            // If best scores are equal, sort by total time played (ascending)
            return timeA.compareTo(timeB);
          }
        });

        if (documents.isEmpty) {
          // Handle the case when the list is empty
          return const Center(
            child: Text('No leaderboard data available.'),
          );
        }

        return ListView.builder(
  itemCount: documents.length,
  itemBuilder: (context, index) {
    String playerName = documents[index]['playerName'] ?? 'Unknown';
    int bestScore = documents[index]['bestScore'] as int? ?? 0;
    int totalTimePlayed = (documents[index]['minute'] as int? ?? 0) * 60 + (documents[index]['timePlayed'] as int? ?? 0);

    int minutes = totalTimePlayed ~/ 60;
    int seconds = totalTimePlayed % 60;

    return Container(
      child: Card(
        elevation: 15,
        child: ListTile(
          leading: Text((index + 1).toString(),
            style: const TextStyle(
              color: Color.fromARGB(255, 17, 0, 0),
              fontSize: 20,
              fontWeight: FontWeight.bold)),
          title: Text('$playerName - Score: $bestScore, Time: $minutes:$seconds minutes',
            style: const TextStyle(color: Color.fromARGB(255, 17, 0, 0), fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  },
);

      },
    );
  }

  Future<String> getUsernameFromUid(String uid) async {
    String username = '';

    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userSnapshot.exists) {
      username = userSnapshot['username'];
    }

    return username;
  }
}

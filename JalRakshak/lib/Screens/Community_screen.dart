import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final List<Map<String, dynamic>> _leaderboard = [
    {
      'rank': 1,
      'name': 'Priya Sharma',
      'reports': 145,
      'liters': 18500,
      'avatar': '🏆',
    },
    {
      'rank': 2,
      'name': 'Rajesh Kumar',
      'reports': 132,
      'liters': 16800,
      'avatar': '🥈',
    },
    {
      'rank': 3,
      'name': 'Anita Singh',
      'reports': 118,
      'liters': 15200,
      'avatar': '🥉',
    },
    {
      'rank': 4,
      'name': 'Arjun Patel',
      'reports': 95,
      'liters': 12100,
      'avatar': '👤',
    },
    {
      'rank': 5,
      'name': 'Meera Reddy',
      'reports': 87,
      'liters': 11000,
      'avatar': '👤',
    },
  ];

  final List<Map<String, dynamic>> _communityPosts = [
    {
      'user': 'ASHA Worker - Sunita',
      'time': '2 hours ago',
      'location': 'Village Panchayat, Bihar',
      'content':
          'Successfully installed 5 rainwater harvesting systems in our village. The community is actively participating!',
      'likes': 234,
      'comments': 45,
      'image': true,
    },
    {
      'user': 'Local Volunteer - Amit',
      'time': '5 hours ago',
      'location': 'Urban Area, Delhi',
      'content':
          'Organized awareness session on water conservation. Over 100 residents attended and pledged to save water.',
      'likes': 189,
      'comments': 32,
      'image': false,
    },
    {
      'user': 'Community Leader - Ravi',
      'time': '1 day ago',
      'location': 'Rural District, Maharashtra',
      'content':
          'Fixed major leakage in village main pipeline. Estimated saving: 5000 liters per day!',
      'likes': 456,
      'comments': 78,
      'image': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCommunityStats(),
                  _buildSectionHeader('Leaderboard', Icons.emoji_events),
                  _buildLeaderboard(),
                  _buildSectionHeader('Community Feed', Icons.feed),
                  _buildCommunityFeed(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFFFF6B35), // Changed to orange
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Community',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B35), Color(0xFFF7931E)], // Orange gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCommunityStats() {
    return Container(
      margin: const EdgeInsets.all(16), // Reduced margin
      padding: const EdgeInsets.all(16), // Reduced padding
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Community Impact',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: _buildStatColumn(
                      '1,245', 'Active\nMembers', Icons.people)),
              Container(width: 1, height: 50, color: Colors.white30),
              Expanded(
                  child: _buildStatColumn(
                      '8,756', 'Total\nReports', Icons.report)),
              Container(width: 1, height: 50, color: Colors.white30),
              Expanded(
                  child: _buildStatColumn(
                      '120K L', 'Water\nSaved', Icons.water_drop)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20, // Slightly reduced
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        children: [
          Icon(icon,
              color: const Color(0xFFFF6B35), size: 24), // Changed to orange
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: _leaderboard.asMap().entries.map((entry) {
          final index = entry.key;
          final user = entry.value;
          final isLast = index == _leaderboard.length - 1;
          return _buildLeaderboardItem(user, isLast);
        }).toList(),
      ),
    );
  }

  Widget _buildLeaderboardItem(Map<String, dynamic> user, bool isLast) {
    Color rankColor;
    if (user['rank'] == 1) {
      rankColor = const Color(0xFFFFD700);
    } else if (user['rank'] == 2) {
      rankColor = const Color(0xFFC0C0C0);
    } else if (user['rank'] == 3) {
      rankColor = const Color(0xFFCD7F32);
    } else {
      rankColor = Colors.grey[400]!;
    }

    return Container(
      padding: const EdgeInsets.all(12), // Reduced padding
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: rankColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(user['avatar'], style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['name'],
                  style: const TextStyle(
                    fontSize: 15, // Slightly reduced
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.report, size: 13, color: Colors.grey[600]),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(
                        '${user['reports']} reports',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.water_drop, size: 13, color: Colors.grey[600]),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(
                        '${user['liters']} L',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: rankColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '#${user['rank']}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: rankColor.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityFeed() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _communityPosts.length,
      itemBuilder: (context, index) {
        return _buildPostCard(_communityPosts[index]);
      },
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFFF6B35), // Changed to orange
                  child: Text(
                    post['user'][0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['user'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 12,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${post['location']} • ${post['time']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              post['content'],
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF2C3E50),
                height: 1.5,
              ),
            ),
          ),
          if (post['image']) ...[
            const SizedBox(height: 12),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Icon(Icons.image, size: 60, color: Colors.grey[400]),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildPostAction(Icons.thumb_up_outlined, '${post['likes']}'),
                const SizedBox(width: 24),
                _buildPostAction(Icons.comment_outlined, '${post['comments']}'),
                const SizedBox(width: 24),
                _buildPostAction(Icons.share_outlined, 'Share'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostAction(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

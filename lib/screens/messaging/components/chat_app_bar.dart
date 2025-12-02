import 'package:flutter/material.dart';
import 'notification_badge.dart';
import 'agent_status_indicator.dart';

/// Custom AppBar for the chat screen
class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String agentName;
  final bool isAgentOnline;
  final int unreadCount;
  final VoidCallback onMenuPressed;
  final VoidCallback onSearchPressed;
  final VoidCallback onNotificationPressed;

  const ChatAppBar({
    super.key,
    required this.title,
    required this.agentName,
    this.isAgentOnline = true,
    this.unreadCount = 0,
    required this.onMenuPressed,
    required this.onSearchPressed,
    required this.onNotificationPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                // Menu button
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: onMenuPressed,
                ),
                // Title and subtitle
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      AgentStatusIndicator(
                        agentName: agentName,
                        isOnline: isAgentOnline,
                      ),
                    ],
                  ),
                ),
                // Search icon
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: onSearchPressed,
                ),
                // Bell icon with notification badge
                NotificationBadge(
                  count: unreadCount,
                  child: IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                    ),
                    onPressed: onNotificationPressed,
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

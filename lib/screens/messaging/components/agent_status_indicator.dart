import 'package:flutter/material.dart';

class AgentStatusIndicator extends StatelessWidget {
  final String agentName;
  final bool isOnline;

  const AgentStatusIndicator({
    super.key,
    required this.agentName,
    this.isOnline = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isOnline ? const Color(0xFF10B981) : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$agentName • ${isOnline ? 'Online' : 'Offline'}',
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }
}

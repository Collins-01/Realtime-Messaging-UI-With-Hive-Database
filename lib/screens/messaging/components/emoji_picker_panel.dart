import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

/// A panel that displays an emoji picker
class EmojiPickerPanel extends StatelessWidget {
  final bool isVisible;
  final Function(String) onEmojiSelected;

  const EmojiPickerPanel({
    super.key,
    required this.isVisible,
    required this.onEmojiSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return SizedBox(
      height: 250,
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          onEmojiSelected(emoji.emoji);
        },
        config: const Config(
          height: 256,
          checkPlatformCompatibility: true,
          emojiViewConfig: EmojiViewConfig(emojiSizeMax: 28),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyableText extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final String tooltip;
  final String snackBarMessage;

  const CopyableText({
    super.key,
    required this.text,
    this.textStyle,
    this.tooltip = 'Copy text',
    this.snackBarMessage = 'Copied to clipboard!',
  });

  @override
  State<CopyableText> createState() => _CopyableTextState();
}

class _CopyableTextState extends State<CopyableText> {
  bool _copied = false;

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.text));

    if (!mounted) return;

    setState(() => _copied = true);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(widget.snackBarMessage),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );

    // Reset the icon back to the copy icon after 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _copied = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              widget.text,
              style: widget.textStyle ?? Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            iconSize: 18,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: widget.tooltip,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
              child: _copied
                  ? const Icon(Icons.check, key: ValueKey('check'), color: Colors.green)
                  : const Icon(Icons.copy_rounded, key: ValueKey('copy')),
            ),
            onPressed: _copyToClipboard,
          ),
        ],
      ),
    );
  }
}
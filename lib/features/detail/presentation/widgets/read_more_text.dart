import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';

class ReadMoreText extends StatefulWidget {
  const ReadMoreText({
    super.key,
    required this.text,
    this.trimlines = 2,
    this.style,
  });

  /// text to display
  final String text;

  /// max lines
  final int trimlines;

  /// text style
  final TextStyle? style;
  @override
  State<ReadMoreText> createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_isExpanded) {
          return RichText(
            text: TextSpan(
              style: widget.style,
              children: [
                TextSpan(text: widget.text),
                TextSpan(
                  text: ' Read less',
                  style: AppTextStyle.bodyMedium(
                    context,
                    color: AppColors.primaryPressed,
                    fontSize: 12,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      setState(() => _isExpanded = false);
                    },
                ),
              ],
            ),
          );
        }

        final textPainter = TextPainter(
          text: TextSpan(text: widget.text),
          maxLines: widget.trimlines,
          textDirection: .ltr,
        )..layout(maxWidth: constraints.maxWidth);

        if (!textPainter.didExceedMaxLines) {
          return Text(widget.text, style: widget.style);
        }

        // Trim text manually
        String trimmedText = widget.text;
        while (true) {
          trimmedText = trimmedText.substring(0, trimmedText.length - 1);

          final painter = TextPainter(
            text: TextSpan(
              text: '$trimmedText... Read more',
              style: widget.style,
            ),
            maxLines: widget.trimlines,
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: constraints.maxWidth);

          if (!painter.didExceedMaxLines) break;
        }

        return RichText(
          text: TextSpan(
            style: widget.style,
            children: [
              TextSpan(text: '$trimmedText...'),
              TextSpan(
                text: ' Read more',
                style: AppTextStyle.bodyMedium(
                  context,
                  color: AppColors.primaryPressed,
                  fontSize: 12,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    setState(() => _isExpanded = true);
                  },
              ),
            ],
          ),
        );
      },
    );
  }
}

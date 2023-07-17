library prevent_orphan_text;

import 'package:flutter/material.dart';

class PreventOrphanText extends StatelessWidget {
  /// Creates a widget that attempts to prevent orphans in the given text.
  ///
  /// The [data] argument is the text to display and will be reordered if necessary.
  /// All other values are the same as [Text] and will be passed through.
  const PreventOrphanText(
    this.data, {
    Key? key,
    this.style,
    this.textAlign,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.strutStyle,
    this.textDirection,
    this.locale,
    this.textScaleFactor,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  }) : super(key: key);

  /// The text to display.
  final String data;

  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

  /// Calculates the width of the given text.
  static double getWidth(String? text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: style,
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    return textPainter.size.width;
  }

  static String getTextWithoutOrphans(String data, TextStyle style, BoxConstraints constraints) {
    final maxWidth = constraints.maxWidth;

    // return data if manually split in lines
    if (data.contains('\n')) {
      return data;
    }

    // return data if it fits in one line
    if (getWidth(data, style) < maxWidth) {
      return data;
    }

    final words = data.split(' ');

    List<List<String>> lines = [];

    List<String> currentLine = [];

    // split words into lines
    for (final word in words) {
      final currentLineText = [...currentLine, word].join(' ');

      if (getWidth(currentLineText, style) > maxWidth) {
        lines.add(currentLine);

        currentLine = [word];
      } else {
        currentLine.add(word);
      }
    }
    lines.add(currentLine);

    // if last line is an orphan, add last word of line above in front of last item

    if (lines.last.length == 1) {
      final lastLine = lines.last;
      final lastWord = lastLine.last;
      final secondLastLine = lines[lines.length - 2];

      final lastWordOfSecondLastLine = secondLastLine.last;

      final newLastLine = [lastWordOfSecondLastLine, lastWord];
      final newSecondLastLine = secondLastLine.sublist(0, secondLastLine.length - 1);

      lines[lines.length - 2] = newSecondLastLine;
      lines[lines.length - 1] = newLastLine;
    }

    // remove empty lines as a result of reordering
    lines = lines.where((element) => element.isNotEmpty).toList();

    // join lines to text
    final linesText = lines.where((element) => element.isNotEmpty).map((line) => line.join(' ')).join('\n');

    return linesText;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = DefaultTextStyle.of(context).style.merge(style);

    return LayoutBuilder(
      builder: (context, constraints) {
        /// Generates a balanced string by splitting the text into words.

        return Text(
          getTextWithoutOrphans(data, effectiveStyle, constraints),
          style: effectiveStyle,
          textAlign: textAlign,
          softWrap: softWrap,
          overflow: overflow,
          maxLines: maxLines,
          strutStyle: strutStyle,
          textDirection: textDirection,
          locale: locale,
          textScaleFactor: textScaleFactor,
          semanticsLabel: semanticsLabel,
          textWidthBasis: textWidthBasis,
          textHeightBehavior: textHeightBehavior,
          selectionColor: selectionColor,
        );
      },
    );
  }
}

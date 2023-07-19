import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prevent_orphan_text/prevent_orphan_text.dart';

main() {
  // widget test that checks if the text is split into two lines

  testWidgets('PreventOrphanText splits text into two lines', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 450,
              child: PreventOrphanText(
                'This is a long text that should be split into two lines',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('This is a long text that should\nbe split into two lines'), findsOneWidget);
  });

  testWidgets(
      'PreventOrphanText prevents the last word to be an orphan so accompanies it with the last word of the previous sentence',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 450,
              child: PreventOrphanText(
                'Enter text above to start adding items',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Enter text above to start\nadding items'), findsOneWidget);
  });

  testWidgets(
    'PreventOrphanText trims a trailing space correctly',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 450,
                child: PreventOrphanText(
                  'Enter text above to start adding items ',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Enter text above to start\nadding items'), findsOneWidget);
    },
  );

  testWidgets(
      'PreventOrphanText removes empty lines in between that are caused by the previous sentence being split into two lines',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 300,
              child: PreventOrphanText(
                'Enter text above to start adding supercalifragilasticlylarge items',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Enter text above to\nstart adding\nsupercalifragilasticlylarge items'), findsOneWidget);
  });

  testWidgets('PreventOrphanText does not split when manual splitting is already provided',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 450,
              child: PreventOrphanText(
                'This is a long text that should be split into\nthree lines that are very long. Normally this should be splitted into three lines but we are going to manually split it into two lines',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(
        find.text(
            'This is a long text that should be split into\nthree lines that are very long. Normally this should be splitted into three lines but we are going to manually split it into two lines'),
        findsOneWidget);
  });

  testWidgets('PreventOrphanText correctly passes all arguments', (WidgetTester tester) async {
    TextStyle style = const TextStyle(
      color: Colors.red,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );

    StrutStyle strutStyle = const StrutStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      height: 1.5,
      leading: 1.5,
      fontFamily: 'Roboto',
      fontFamilyFallback: ['Roboto'],
      debugLabel: 'strut',
      package: 'flutter',
    );

    late BuildContext ctx;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 450,
              child: Builder(builder: (context) {
                ctx = context;
                return PreventOrphanText(
                  'This is a nice text',
                  textAlign: TextAlign.center,
                  style: style,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textScaleFactor: 1.5,
                  textWidthBasis: TextWidthBasis.longestLine,
                  textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: true,
                    applyHeightToLastDescent: true,
                  ),
                  textDirection: TextDirection.ltr,
                  locale: const Locale('en', 'US'),
                  strutStyle: strutStyle,
                  selectionColor: Colors.red,
                  semanticsLabel: 'label',
                );
              }),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final effectiveStyle = DefaultTextStyle.of(ctx).style.merge(style);

    // find text
    Text widget = find.text('This is a nice text').evaluate().first.widget as Text;

    expect(widget.textAlign, TextAlign.center);
    expect(widget.style, effectiveStyle);
    expect(widget.softWrap, true);
    expect(widget.overflow, TextOverflow.ellipsis);
    expect(widget.maxLines, 2);
    expect(widget.textScaleFactor, 1.5);
    expect(widget.textWidthBasis, TextWidthBasis.longestLine);
    expect(
        widget.textHeightBehavior,
        const TextHeightBehavior(
          applyHeightToFirstAscent: true,
          applyHeightToLastDescent: true,
        ));
    expect(widget.textDirection, TextDirection.ltr);
    expect(widget.locale, const Locale('en', 'US'));
    expect(widget.strutStyle, strutStyle);
    expect(widget.selectionColor, Colors.red);
    expect(widget.semanticsLabel, 'label');
  });
}

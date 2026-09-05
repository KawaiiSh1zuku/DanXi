import 'package:dan_xi/page/home_page.dart';
import 'package:dan_xi/util/master_detail_utils.dart';
import 'package:dan_xi/util/master_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('desktop master pane expands without replacing detail navigator',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(() => mainNavigatorExpanded.value = false);

    final masterKey = GlobalKey<NavigatorState>();
    mainNavigatorExpanded.value = false;

    await tester.pumpWidget(PlatformProvider(
      initialPlatform: TargetPlatform.windows,
      builder: (context) => MaterialApp(
        home: PlatformMasterDetailApp(
          navigatorKey: masterKey,
          onGenerateRoute: (settings) => MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => const ColoredBox(color: Colors.white),
          ),
        ),
      ),
    ));

    final detailState = detailNavigatorKey.currentState;
    expect(tester.getSize(find.byKey(masterKey)).width,
        kDesktopMasterContainerWidth);
    expect(tester.getSize(find.byKey(detailNavigatorKey)).width,
        1200 - kDesktopMasterContainerWidth);

    mainNavigatorExpanded.value = true;
    await tester.pump();

    expect(tester.getSize(find.byKey(masterKey)).width, 1200);
    expect(tester.getSize(find.byKey(detailNavigatorKey)).width, 0);
    expect(detailNavigatorKey.currentState, same(detailState));

    mainNavigatorExpanded.value = false;
    await tester.pump();

    expect(tester.getSize(find.byKey(masterKey)).width,
        kDesktopMasterContainerWidth);
    expect(detailNavigatorKey.currentState, same(detailState));
  });
}

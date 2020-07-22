import 'dart:developer' show Timeline, Flow;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Flow;
import 'package:flutter/scheduler.dart';

import 'package:soil_moisture_app/utils/sizes.dart';

class Licenses extends StatefulWidget {
  @override
  _LicensesState createState() => _LicensesState();
}

class _LicensesState extends State<Licenses> {
  @override
  void initState() {
    super.initState();
    _initLicenses();
  }

  final List<Widget> _licenses = <Widget>[];
  bool _loaded = false;

  Future<void> _initLicenses() async {
    int debugFlowId = -1;
    assert(() {
      final Flow flow = Flow.begin();
      Timeline.timeSync('_initLicenses()', () {}, flow: flow);
      debugFlowId = flow.id;
      return true;
    }());
    await for (final LicenseEntry license in LicenseRegistry.licenses) {
      if (!mounted) {
        return;
      }
      assert(() {
        Timeline.timeSync('_initLicenses()', () {},
            flow: Flow.step(debugFlowId));
        return true;
      }());
      final List<LicenseParagraph> paragraphs =
          await SchedulerBinding.instance.scheduleTask<List<LicenseParagraph>>(
        license.paragraphs.toList,
        Priority.animation,
        debugLabel: 'License',
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _licenses.add(const Padding(
          padding: EdgeInsets.symmetric(vertical: 18.0),
          child: Text(
            '🍀‬', // That's U+1F340. Could also use U+2766 (❦) if U+1F340 doesn't work everywhere.
            textAlign: TextAlign.center,
          ),
        ));
        _licenses.add(Container(
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(width: 0.0))),
          child: Text(
            license.packages.join(', '),
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ));
        for (final LicenseParagraph paragraph in paragraphs) {
          if (paragraph.indent == LicenseParagraph.centeredIndent) {
            _licenses.add(Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                paragraph.text,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ));
          } else {
            assert(paragraph.indent >= 0);
            _licenses.add(Padding(
              padding: EdgeInsetsDirectional.only(
                  top: 8.0, start: 16.0 * paragraph.indent),
              child: Text(paragraph.text),
            ));
          }
        }
      });
    }
    setState(() {
      _loaded = true;
    });
    assert(() {
      Timeline.timeSync('Build scheduled', () {}, flow: Flow.end(debugFlowId));
      return true;
    }());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(
          'Licenses',
          style: Theme.of(context).textTheme.headline6.copyWith(
                fontSize: appWidth(context) * 0.055,
              ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Scrollbar(
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            children: <Widget>[
              ..._licenses,
              if (!_loaded)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

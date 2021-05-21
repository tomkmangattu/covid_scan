import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChanger extends StatefulWidget {
  final Widget Function(BuildContext context, Brightness brightness) builder;
  final Brightness defaultBrightness;

  ThemeChanger({this.builder, this.defaultBrightness});

  @override
  _ThemeChangerState createState() => _ThemeChangerState();
  static _ThemeChangerState of(BuildContext context) {
    return context.findAncestorStateOfType<_ThemeChangerState>();
  }
}

class _ThemeChangerState extends State<ThemeChanger> {
  Brightness _brightness;

  @override
  void initState() {
    super.initState();
    _brightness = widget.defaultBrightness;
    if (mounted) {
      setState(() {});
    }
  }

  void changeTheme() async {
    final bool dark = _brightness == Brightness.dark;
    setState(() {
      _brightness = dark ? Brightness.light : Brightness.dark;
    });
    _changeStoredTheme(dark);
  }

  void _changeStoredTheme(bool dark) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    shared.setBool('dark', dark);
  }

  Brightness getCurrentTheme() {
    return _brightness;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _brightness);
  }
}

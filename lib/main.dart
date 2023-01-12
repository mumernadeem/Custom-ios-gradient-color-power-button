// ignore: library_prefixes
import 'dart:math' as Math;

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: AdvancedSwitch(
          activeColor: Colors.red,
          activeColor1: Colors.green,
          value: _value,
          onChanged: (value) => setState(() {
            _value = value;
          }),
        ),
      ),
    );
  }
}

class AdvancedSwitch extends StatefulWidget {
  const AdvancedSwitch({
    Key? key,
    required this.value,
    this.activeColor = Colors.green,
    this.activeColor1 = Colors.red,
    this.inactiveColor = Colors.grey,
    this.borderRadius = const BorderRadius.all(Radius.circular(15)),
    this.width = 50.0,
    this.height = 30.0,
    required this.onChanged,
  }) : super(key: key);

  /// Determines current state.
  final bool value;

  /// Determines background color for the active state.
  final Color activeColor;
  final Color activeColor1;

  /// Determines background color for the inactive state.
  final Color inactiveColor;

  /// Determines border radius.
  final BorderRadius borderRadius;

  /// Determines width.
  final double width;

  /// Determines height.
  final double height;

  /// Called on interaction.
  final ValueChanged<bool> onChanged;

  @override
  // ignore: library_private_types_in_public_api
  _AdvancedSwitchState createState() => _AdvancedSwitchState();
}

class _AdvancedSwitchState extends State<AdvancedSwitch>
    with SingleTickerProviderStateMixin {
  final _duration = const Duration(milliseconds: 250);
  late AnimationController _animationController;
  // ignore: prefer_typing_uninitialized_variables
  var _colorAnimation;
  // ignore: prefer_typing_uninitialized_variables
  var _colorAnimation1;
  late Animation<Alignment> _slideAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: _duration,
      value: widget.value ? 1.0 : 0.0,
    );

    _slideAnimation = AlignmentTween(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(_animationController);

    _colorAnimation = ColorTween(
      begin: widget.inactiveColor,
      end: widget.activeColor,
    ).animate(_animationController);

    _colorAnimation1 = ColorTween(
      begin: widget.inactiveColor,
      end: widget.activeColor1,
    ).animate(_animationController);

    super.initState();
  }

  @override
  void didUpdateWidget(AdvancedSwitch oldWidget) {
    if (oldWidget.value == widget.value) {
      return super.didUpdateWidget(oldWidget);
    }

    if (widget.value) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          // ignore: unnecessary_null_comparison
          widget.onChanged != null ? widget.onChanged(!widget.value) : null,
      child: Opacity(
        // ignore: unnecessary_null_comparison
        opacity: widget.onChanged != null ? 1.0 : 0.5,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (_, child) {
            return Container(
              width: widget.width,
              height: widget.height,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius,
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    _colorAnimation.value,
                    _colorAnimation1.value,
                  ],
                ),
              ),
              child: child,
            );
          },
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Stack(
                children: [
                  Align(
                    alignment: _slideAnimation.value,
                    child: child,
                  ),
                ],
              );
            },
            child: _buildThumb(),
          ),
        ),
      ),
    );
  }

  Widget _buildThumb() {
    final size = Math.min(widget.width, widget.height * 0.6) - 4;

    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size / 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8.0,
          ),
        ],
      ),
    );
  }
}

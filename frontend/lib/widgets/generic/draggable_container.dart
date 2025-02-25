import 'package:flutter/material.dart';

class DraggableContainer extends StatefulWidget {
  final Widget child;
  const DraggableContainer({
    super.key,
    required this.child,
  });
  
  @override
  State<DraggableContainer> createState() => _DraggableContainerState();
}

class _DraggableContainerState extends State<DraggableContainer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _dragPosition = 0.0;
  double _targetPosition = 0.0; // The final target position

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300), // Adjust for smoothness
    )..addListener(() {
        setState(() {
          _dragPosition = _animation.value;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateToPosition(double newPosition) {
    _targetPosition = newPosition.clamp(0.0, MediaQuery.of(context).size.height - 100);
    // _animation = Tween<double>(begin: _dragPosition, end: _targetPosition)
    //     .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _animation = Tween<double>(begin: _dragPosition, end: _targetPosition)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.decelerate));
    _controller.forward(from: 0.0); // Restart animation
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: _dragPosition,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          setState(() {
            _dragPosition += details.delta.dy;
            _dragPosition = _dragPosition.clamp(0.0, MediaQuery.of(context).size.height - 100);
          });
        },
        onVerticalDragEnd: (details) {
          // Smoothly animate to the nearest resting position
          _animateToPosition(_dragPosition);
        },
        child: widget.child,
      ),
    );
  }
}

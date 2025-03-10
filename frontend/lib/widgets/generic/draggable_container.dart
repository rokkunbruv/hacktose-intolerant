import 'package:flutter/material.dart';
import 'package:tultul/theme/colors.dart';

import 'package:tultul/styles/widget/box_shadow_style.dart';

class DraggableContainer extends StatefulWidget {
  final Widget child;
  const DraggableContainer({
    super.key,
    required this.child,
  });

  @override
  State<DraggableContainer> createState() => _DraggableContainerState();
}

class _DraggableContainerState extends State<DraggableContainer> {
  final sheet = GlobalKey();
  final controller = DraggableScrollableController();

  // late AnimationController _controller;
  // late Animation<double> _animation;
  // double _dragPosition = 0.0;
  // double _targetPosition = 0.0; // The final target position

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = AnimationController(
  //     vsync: this,
  //     duration: Duration(milliseconds: 300), // Adjust for smoothness
  //   )..addListener(() {
  //       setState(() {
  //         _dragPosition = _animation.value;
  //       });
  //     });
  // }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  // void _animateToPosition(double newPosition) {
  //   _targetPosition =
  //       newPosition.clamp(0.0, MediaQuery.of(context).size.height - 100);
  //   // _animation = Tween<double>(begin: _dragPosition, end: _targetPosition)
  //   //     .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  //   _animation = Tween<double>(begin: _dragPosition, end: _targetPosition)
  //       .animate(
  //           CurvedAnimation(parent: _controller, curve: Curves.decelerate));
  //   _controller.forward(from: 0.0); // Restart animation
  // }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (builder, constraints) {
      // Calculate minimum size to show at least the handle and title
      final minSize = 120 / constraints.maxHeight;
      
      return DraggableScrollableSheet(
          key: sheet,
          initialChildSize: 0.5,
          maxChildSize: 0.95,
          minChildSize: minSize,
          expand: true,
          snap: true,
          snapSizes: [minSize, 0.5],
          builder: (BuildContext context, ScrollController scrollController) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.bg,
                boxShadow: [
                  createBoxShadow(),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  topButtonIndicator(),
                  SliverToBoxAdapter(
                    child: widget.child,
                  ),
                ],
              ),
            );
          });
    });
  }

  SliverToBoxAdapter topButtonIndicator() {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Wrap(
              children: [
                Container(
                  width: 80,
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  height: 5,
                  decoration: BoxDecoration(
                      color: AppColors.gray,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

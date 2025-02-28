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
      return DraggableScrollableSheet(
          key: sheet,
          initialChildSize: 0.5,
          maxChildSize: 0.95,
          minChildSize: 0,
          expand: true,
          snap: true,
          snapSizes: [60 / constraints.maxHeight, 0.5],
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
    // return Positioned(
    //   left: 0,
    //   right: 0,
    //   top: _dragPosition,
    //   child: GestureDetector(
    //     onVerticalDragUpdate: (details) {
    //       setState(() {
    //         _dragPosition += details.delta.dy;
    //         _dragPosition = _dragPosition.clamp(
    //             0.0, MediaQuery.of(context).size.height - 100);
    //       });
    //     },
    //     onVerticalDragEnd: (details) {
    //       // Smoothly animate to the nearest resting position          _animateToPosition(_dragPosition);
    //     },
    //     child: widget.child,
    //   ),
    // );
  }

  SliverToBoxAdapter topButtonIndicator() {
    return SliverToBoxAdapter(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Center(
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
            ),
          ],
        ),
      ),
    );
  }
}

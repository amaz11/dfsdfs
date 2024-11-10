import 'package:flutter/material.dart';

class ArroverBottonIconSkeleton extends StatelessWidget {
  const ArroverBottonIconSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildSkeletonLoader(),
    );
  }

  /// Builds the skeleton loader.
  Widget _buildSkeletonLoader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _skeletonBox(width: 30, height: 25), // Placeholder for the label
        const SizedBox(height: 2),
        _skeletonBox(width: 30, height: 10), // Placeholder for the dropdown
      ],
    );
  }

  /// Builds a rectangular skeleton box.
  Widget _skeletonBox({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300], // Light grey color for shimmer effect
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

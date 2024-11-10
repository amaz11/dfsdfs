import 'package:flutter/material.dart';

class LeaveTypeSkeletonLoader extends StatelessWidget {
  const LeaveTypeSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildSkeletonLoader(),
    );
  }

  /// Builds the skeleton loader.
  Widget _buildSkeletonLoader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _skeletonBox(width: 150, height: 20), // Placeholder for the label
        const SizedBox(height: 10),
        _skeletonBox(
            width: double.infinity, height: 56), // Placeholder for the dropdown
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

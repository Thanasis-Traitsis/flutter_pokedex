import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget ShimmerWidget({
  required double width,
  required double height,
}) {
  return SizedBox(
    height: height,
    width: width,
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}

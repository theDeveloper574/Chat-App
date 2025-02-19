import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final bool isExpand;
  const ShimmerWidget({
    super.key,
    this.isExpand = false,
  });

  @override
  Widget build(BuildContext context) {
    return (isExpand) ? shimmerWid() : Expanded(child: shimmerWid());
  }

  Widget shimmerWid() {
    return ListView.builder(
      reverse: true,
      itemCount: 20,
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Shimmer Profile Picture
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              // ✅ Shimmer Message Bubble
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 15,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 12,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

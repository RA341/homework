import 'package:flutter/material.dart';
import 'package:homework/components/theme/design_system.dart';
import 'package:homework/pages/home/widgets/shimmer_card.dart';

class SkeletonLoader extends StatelessWidget {
  final bool isGridView;
  final bool isDesktop;

  const SkeletonLoader({
    super.key,
    required this.isGridView,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final count = isDesktop ? 6 : 4;
    if (isGridView) {
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isDesktop
              ? 3
              : (MediaQuery.of(context).size.width >= 480 ? 2 : 1),
          crossAxisSpacing: AppSpacing.gutter,
          mainAxisSpacing: AppSpacing.gutter,
          childAspectRatio: 1.5,
        ),
        itemCount: count,
        itemBuilder: (context, index) => const ShimmerCard(),
      );
    } else {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: count,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.base * 2),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.level1,
              borderRadius: AppShapes.radiusDefault,
            ),
          ),
        ),
      );
    }
  }
}

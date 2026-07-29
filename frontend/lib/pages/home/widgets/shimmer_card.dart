import 'package:flutter/material.dart';
import 'package:homework/common/theme/design_system.dart';

class ShimmerCard extends StatefulWidget {
  const ShimmerCard({super.key});

  @override
  State<ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<ShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final opacity = 0.15 + (_controller.value * 0.35);
        return Container(
          decoration: BoxDecoration(
            color: AppColors.level1,
            borderRadius: AppShapes.radiusLg,
            border: Border.all(color: const Color(0xFF2C2928), width: 1.0),
          ),
          padding: const EdgeInsets.all(AppSpacing.gutter / 1.5),
          child: Opacity(
            opacity: opacity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: AppColors.onSurface,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.base * 1.5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 12,
                            width: 100,
                            decoration: BoxDecoration(
                              color: AppColors.onSurface,
                              borderRadius: AppShapes.radiusSm,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            height: 8,
                            width: 50,
                            decoration: BoxDecoration(
                              color: AppColors.onSurfaceVariant,
                              borderRadius: AppShapes.radiusSm,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.base * 2.5),
                Container(
                  height: 10,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.onSurfaceVariant,
                    borderRadius: AppShapes.radiusSm,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 10,
                  width: 130,
                  decoration: BoxDecoration(
                    color: AppColors.onSurfaceVariant,
                    borderRadius: AppShapes.radiusSm,
                  ),
                ),
                const Spacer(),
                const Divider(color: Color(0xFF2C2928), height: 1),
                const SizedBox(height: AppSpacing.base * 1.2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 10,
                      width: 70,
                      decoration: BoxDecoration(
                        color: AppColors.onSurfaceVariant,
                        borderRadius: AppShapes.radiusSm,
                      ),
                    ),
                    Container(
                      height: 14,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColors.onSurfaceVariant,
                        borderRadius: AppShapes.radiusSm,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

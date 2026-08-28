import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homework/components/theme/design_system.dart';
import 'package:homework/pages/home/content_browser_provider.dart';
import 'package:homework/pages/home/widgets/content_area.dart';
import 'package:homework/pages/home/widgets/home_header.dart';
import 'package:homework/pages/home/widgets/search_filter_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.level0,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.gutter,
            vertical: AppSpacing.base * 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HomeHeader(),
              const SizedBox(height: AppSpacing.base * 3),

              const SearchFilterBar(),
              const SizedBox(height: AppSpacing.base * 3),

              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    return RefreshIndicator(
                      color: AppColors.primary,
                      backgroundColor: AppColors.level2,
                      onRefresh: () => ref
                          .read(contentListProvider.notifier)
                          .loadNextPage(reset: true),
                      child: const ContentList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

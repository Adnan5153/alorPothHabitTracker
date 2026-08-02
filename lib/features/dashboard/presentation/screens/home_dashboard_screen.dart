import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/animations/app_animations.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/appbar/app_bar_extensions.dart';
import '../../../../core/widgets/appbar/custom_app_bar.dart';
import '../../../../core/widgets/scaffold/liquid_scaffold/liquid_scaffold_exports.dart';
import '../viewmodels/dashboard_viewmodel.dart';

class HomeDashboardScreen extends ConsumerWidget {
  const HomeDashboardScreen({super.key});

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(dashboardViewModelProvider);
    final user = viewModel.currentUser;
    final displayName = user?.displayName ?? 'Welcome';
    final photoUrl = user?.photoURL;

    return LiquidScaffold(
      appBar: CustomAppBar(
        title: 'Home',
        subtitle: displayName,
        variant: AppBarVariant.dashboard,
      ),
      padding: const EdgeInsets.all(AppSizes.space24),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: AppSizes.space48),
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundImage:
                  photoUrl != null && photoUrl.isNotEmpty
                      ? NetworkImage(photoUrl)
                      : null,
              child: photoUrl == null || photoUrl.isEmpty
                  ? const Icon(Icons.person_rounded, size: 48)
                  : null,
            ),
          ).scaleFadeEntrance(),
          const SizedBox(height: AppSizes.space24),
          Text(
            displayName,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ).fadeUpEntrance(delay: AppAnims.standard),
          const SizedBox(height: AppSizes.space8),
          Text(
            user?.email ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ).fadeUpEntrance(
            delay: AppAnims.standard + AppAnims.micro,
          ),
          const SizedBox(height: AppSizes.space48),
          FilledButton.icon(
            onPressed: viewModel.isLoading
                ? null
                : () async {
                    await viewModel.signOut();
                  },
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Sign out'),
          ).fadeUpEntrance(
            delay: AppAnims.standard + AppAnims.standard,
          ),
        ],
      ),
    );
  }
}

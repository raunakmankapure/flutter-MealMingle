import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
//import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/favorites_prooviders.dart';

class MealDeatailsScreen extends ConsumerWidget {
  const MealDeatailsScreen({
    super.key,
    required this.meal,
  });

  final Meal meal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteMeals = ref.watch(favoriteMealsProvider);
    final isFavorite = favoriteMeals.contains(meal);

    return Scaffold(
      appBar: AppBar(title: Text(meal.title), actions: [
        IconButton(
          onPressed: () {
            final wasAdded = ref
                .read(favoriteMealsProvider.notifier)
                .toggleMealFavoriteStatus(meal);
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  wasAdded ? 'Meal added as a favorite.' : 'Meal removed.',
                ),
              ),
            );
          },
          icon: AnimatedSwitcher(
            //to add animation on icon button
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return RotationTransition(
                //to control speed of rotation.
                turns: Tween(begin: 0.8, end: 1.0).animate(animation),
                child: child,
              );
            },
            child: Icon(
              isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
              key: ValueKey(isFavorite),
            ),
          ),
        ), //to add iconbutton on appbar.
      ]),
      body: SingleChildScrollView(
        // to make screen scrollable.
        child: Column(
          children: [
            Hero(
              // hero = class that animates cross screen widgets.
              tag: meal.id,
              child: Image.network(
                meal.imageUrl,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            Text(
              'Ingredients',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            for (final ingredient in meal.ingredients)
              Text(
                ingredient,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            const SizedBox(height: 24),
            Text(
              'Steps',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            for (final step in meal.steps)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  step,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

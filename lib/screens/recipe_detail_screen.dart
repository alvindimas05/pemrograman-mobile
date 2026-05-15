import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/meal.dart';
import '../providers/recipe_provider.dart';

const _bg = Color(0xFFFFFBF5);
const _surface = Colors.white;
const _accent = Color(0xFFF59E0B);
const _accentDark = Color(0xFFD97706);
const _textPrimary = Color(0xFF0F172A);
const _textSecondary = Color(0xFF64748B);
const _border = Color(0xFFF1F0EC);

class RecipeDetailScreen extends StatelessWidget {
  final Meal meal;

  const RecipeDetailScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeProvider>(
      builder: (context, provider, _) {
        final saved = provider.isSaved(meal.idMeal);

        return Scaffold(
          backgroundColor: _bg,
          body: CustomScrollView(
            slivers: [
              // ── Hero Image + AppBar ───────────────────────────────────────
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: _surface,
                elevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        meal.strMealThumb,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFF3F4F6),
                        ),
                      ),
                      // Bottom fade to bg
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: _bg,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(28),
                              topRight: Radius.circular(28),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _CircleButton(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(LucideIcons.chevronLeft,
                            size: 20, color: _textPrimary),
                      ),
                      _CircleButton(
                        onTap: () => provider.toggleSaveRecipe(meal),
                        child: Icon(
                          saved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                          size: 20,
                          color: saved ? _accent : _textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Content ───────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  color: _bg,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        meal.strMeal,
                        style: GoogleFonts.outfit(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: _textPrimary,
                          letterSpacing: -0.5,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Badges
                      Wrap(
                        spacing: 8,
                        children: [
                          _Badge(meal.strCategory, icon: LucideIcons.tag),
                          _Badge(meal.strArea, icon: LucideIcons.mapPin),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // ── Bahan-Bahan ────────────────────────────────────
                      _SectionHeader('Ingredients',
                          '${meal.ingredients.length} items'),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 106,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: meal.ingredients.length,
                          itemBuilder: (context, i) {
                            final ingredient = meal.ingredients[i];
                            final measure = meal.measures.length > i
                                ? meal.measures[i]
                                : '';
                            return Padding(
                              padding: EdgeInsets.only(
                                  right: i < meal.ingredients.length - 1
                                      ? 12
                                      : 0),
                              child: Container(
                                width: 80,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border:
                                      Border.all(color: _border, width: 1.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        'https://www.themealdb.com/images/ingredients/$ingredient-Small.png',
                                        width: 48,
                                        height: 48,
                                        fit: BoxFit.contain,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.fastfood,
                                                size: 28,
                                                color: _textSecondary),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      measure.isNotEmpty
                                          ? '$measure\n$ingredient'
                                          : ingredient,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.outfit(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                        color: _textSecondary,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Cara Memasak ───────────────────────────────────
                      _SectionHeader('Cooking Instructions', null),
                      const SizedBox(height: 14),

                      ...meal.strInstructions
                          .split(RegExp(r'\r?\n'))
                          .where((step) {
                        final s = step.trim();
                        return s.isNotEmpty &&
                            !RegExp(r'^(Step\s*\d+:?|\d+[\.)]?)$',
                                    caseSensitive: false)
                                .hasMatch(s);
                      })
                          .toList()
                          .asMap()
                          .entries
                          .map((entry) {
                        final stepNum = entry.key + 1;
                        var stepText = entry.value.trim();
                        stepText = stepText.replaceAll(
                            RegExp(r'^(Step\s*\d+:?|\d+[\.)]?)\s*',
                                caseSensitive: false),
                            '');
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: _accent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '$stepNum',
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    stepText,
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      color: _textPrimary,
                                      height: 1.6,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: 24),

                      // ── YouTube Button ─────────────────────────────────
                      if (meal.strYoutube.isNotEmpty)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final uri = Uri.parse(meal.strYoutube);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri,
                                    mode: LaunchMode.externalApplication);
                              }
                            },
                            icon: const Icon(LucideIcons.youtube, size: 20),
                            label: Text(
                              'Watch Tutorial',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDC2626),
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  const _SectionHeader(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: _textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: _textSecondary,
            ),
          ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const _CircleButton({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _surface,
          shape: BoxShape.circle,
          border: Border.all(color: _border, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final IconData icon;
  const _Badge(this.text, {required this.icon});

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _accent.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: _accentDark),
          const SizedBox(width: 5),
          Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _accentDark,
            ),
          ),
        ],
      ),
    );
  }
}

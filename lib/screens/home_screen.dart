import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import 'recipe_detail_screen.dart';

// ── Palette ──────────────────────────────────────────────────────────────────
const _bg = Color(0xFFFFFBF5);
const _surface = Colors.white;
const _accent = Color(0xFFF59E0B);
const _accentDark = Color(0xFFD97706);
const _textPrimary = Color(0xFF0F172A);
const _textSecondary = Color(0xFF64748B);
const _border = Color(0xFFF1F0EC);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _randomRecipeIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  void _handleSurpriseMe(int max) {
    if (max <= 1) return;
    setState(() {
      int next;
      do {
        next = Random().nextInt(max);
      } while (next == _randomRecipeIndex);
      _randomRecipeIndex = next;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeProvider>(
      builder: (context, provider, child) {
        final categories = provider.categories;
        final meals = provider.exploreMeals;
        final randomMeals = provider.randomMeals;

        if (randomMeals.isNotEmpty && _randomRecipeIndex >= randomMeals.length) {
          _randomRecipeIndex = 0;
        }
        final randomRecipe =
            randomMeals.isNotEmpty ? randomMeals[_randomRecipeIndex] : null;

        return Container(
          color: _bg,
          child: CustomScrollView(
            slivers: [
              // ── App Bar ──────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gourmet Debut',
                                  style: GoogleFonts.outfit(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: _textPrimary,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                Text(
                                  'Temukan resep favoritmu',
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    color: _textSecondary,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: _accent,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                LucideIcons.chefHat,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // ── Search Bar ───────────────────────────────────
                        Container(
                          decoration: BoxDecoration(
                            color: _surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: _border, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              color: _textPrimary,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              hintText: 'Cari resep...',
                              hintStyle: GoogleFonts.outfit(
                                fontSize: 14,
                                color: _textSecondary,
                              ),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 14, right: 8),
                                child: Icon(LucideIcons.search,
                                    color: _textSecondary, size: 18),
                              ),
                              prefixIconConstraints: const BoxConstraints(),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: TextButton(
                                  onPressed: () {
                                    provider.searchMeals(
                                        _searchController.text);
                                    FocusScope.of(context).unfocus();
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: _accent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    minimumSize: const Size(56, 36),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                  ),
                                  child: Text(
                                    'Cari',
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            onSubmitted: (v) => provider.searchMeals(v),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Kategori ─────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                  child: _SectionTitle('Kategori'),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 110,
                  child: categories.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(color: _accent))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final cat = categories[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                  right: index < categories.length - 1 ? 14 : 0),
                              child: GestureDetector(
                                onTap: () =>
                                    provider.searchMeals(cat.strCategory),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 68,
                                      height: 68,
                                      decoration: BoxDecoration(
                                        color: _surface,
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(
                                            color: _border, width: 1.5),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.05),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          cat.strCategoryThumb,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(Icons.fastfood,
                                                  color: _textSecondary),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    SizedBox(
                                      width: 68,
                                      child: Text(
                                        cat.strCategory,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.outfit(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: _textSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),

              // ── Resep Acak ───────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                  child: _SectionTitle('Resep Acak'),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: provider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: _accent))
                      : randomRecipe != null
                          ? GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      RecipeDetailScreen(meal: randomRecipe),
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _surface,
                                  borderRadius: BorderRadius.circular(20),
                                  border:
                                      Border.all(color: _border, width: 1.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Stack(
                                      children: [
                                        Image.network(
                                          randomRecipe.strMealThumb,
                                          height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              Container(
                                            height: 200,
                                            color: const Color(0xFFF3F4F6),
                                          ),
                                        ),
                                        // Surprise Me pill
                                        Positioned(
                                          top: 12,
                                          right: 12,
                                          child: GestureDetector(
                                            onTap: () => _handleSurpriseMe(
                                                randomMeals.length),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 7),
                                              decoration: BoxDecoration(
                                                color: _surface,
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                                border: Border.all(
                                                    color: _border, width: 1),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.08),
                                                    blurRadius: 8,
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                      LucideIcons.refreshCw,
                                                      size: 14,
                                                      color: _accentDark),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    'Surprise Me',
                                                    style: GoogleFonts.outfit(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: _accentDark,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  randomRecipe.strMeal,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.outfit(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 17,
                                                    color: _textPrimary,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                        LucideIcons.mapPin,
                                                        size: 12,
                                                        color: _textSecondary),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      randomRecipe.strArea,
                                                      style: GoogleFonts.outfit(
                                                        fontSize: 12,
                                                        color: _textSecondary,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    const Icon(
                                                        LucideIcons.tag,
                                                        size: 12,
                                                        color: _textSecondary),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      randomRecipe.strCategory,
                                                      style: GoogleFonts.outfit(
                                                        fontSize: 12,
                                                        color: _textSecondary,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color:
                                                  _accent.withOpacity(0.12),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const Icon(
                                                LucideIcons.chevronRight,
                                                size: 18,
                                                color: _accentDark),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                'Tidak ada resep ditemukan.',
                                style: GoogleFonts.outfit(color: _textSecondary),
                              ),
                            ),
                ),
              ),

              // ── Explore ──────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
                  child: _SectionTitle('Explore'),
                ),
              ),

              if (provider.isLoading)
                const SliverToBoxAdapter(
                  child: Center(
                      child: CircularProgressIndicator(color: _accent)),
                )
              else if (meals.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                        'Tidak ada resep.',
                        style: GoogleFonts.outfit(color: _textSecondary),
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding:
                      const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.72,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final recipe = meals[index];
                        return GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  RecipeDetailScreen(meal: recipe),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _surface,
                              borderRadius: BorderRadius.circular(18),
                              border:
                                  Border.all(color: _border, width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  recipe.strMealThumb,
                                  width: double.infinity,
                                  height: 130,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    height: 130,
                                    color: const Color(0xFFF3F4F6),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          recipe.strMeal,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.outfit(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                            color: _textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Container(
                                          padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: _accent.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            recipe.strCategory,
                                            style: GoogleFonts.outfit(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: _accentDark,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: meals.length,
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

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        fontSize: 19,
        fontWeight: FontWeight.w800,
        color: _textPrimary,
        letterSpacing: -0.3,
      ),
    );
  }
}

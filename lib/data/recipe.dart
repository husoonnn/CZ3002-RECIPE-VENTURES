class Recipe {
  final int id;
  final bool vegetarian;
  final bool vegan;
  final bool glutenFree;
  final bool dairyFree;
  final int preparationMinutes;
  final int cookingMinutes;
  final int readyInMinutes;
  final int servings;
  final List<dynamic> ingredients;
  final String title;
  final String image;
  final String imageType;
  final List<dynamic> nutrients;
  final String summary;
  final String instructions;
  // the summary and instructions gotta remove the line breaks etc.

  Recipe(
      {this.vegetarian,
      this.image,
      this.id,
      this.title,
      this.cookingMinutes,
      this.dairyFree,
      this.glutenFree,
      this.imageType,
      this.ingredients,
      this.instructions,
      this.nutrients,
      this.preparationMinutes,
      this.readyInMinutes,
      this.servings,
      this.summary,
      this.vegan});

  factory Recipe.createRecipeFromRes(Map<String, dynamic> res) {
    Recipe x = Recipe(
      vegetarian: res['vegetarian'] ?? null,
      vegan: res['vegan'] ?? null,
      glutenFree: res['glutenFree'] ?? null,
      dairyFree: res['dairyFree'] ?? null,
      id: res['id'] ?? null,
      title: res['title'] ?? null,
      preparationMinutes: res["preparationMinutes"] ?? null,
      cookingMinutes: res["cookingMinutes"] ?? null,
      readyInMinutes: res['readyInMinutes'] ?? null,
      servings: res['servings'] ?? null,
      image: res['image'] ?? null,
      imageType: res['imageType'] ?? null,
      nutrients: res['nutrition']['nutrients'] ?? [],
      ingredients: res['extendedIngredients']
              .map((ingredient) => ingredient["original"])
              .toList() ??
          [],
      summary: res['summary'] ?? null,
      instructions: res['instructions'] ?? null,
    );
    return x;
  }
}

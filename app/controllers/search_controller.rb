class SearchController < ApplicationController
  layout 'wall'
  def recipes
    @search = params[:q]
    @recipes = Recipe.find_with_index(@search)
    @ingredientsFound = Ingredient.find_with_index(@search)
    @ingredientsFound.each do |i|
      newRecipes = i.recipes
      @recipes = (@recipes + newRecipes).uniq
    end
  end

end

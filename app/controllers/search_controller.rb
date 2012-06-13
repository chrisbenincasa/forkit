class SearchController < ApplicationController
  layout 'recipes'
  def recipes
    @search = params[:q]
    @recipes = Recipe.where('name LIKE ?', '%'+params[:q]+'%').page(params[:page]).per(12)
  end

end

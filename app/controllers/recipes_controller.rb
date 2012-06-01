 class RecipesController < ApplicationController
  layout 'recipes'
  # GET /recipes
  # GET /recipes.json
  def index
    @recipes = Recipe.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @recipes }
    end
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
    @recipe = Recipe.find_by_url_slug(params[:id])
    @created_by = User.find(@recipe.created_by)
    @users = @recipe.users
    @personal_rating = current_user.personalRecipeInfo.where("recipe_id=#{@recipe.id}").first
    if @personal_rating.nil?
      @personal_rating = nil
    else
      @personal_rating = @personal_rating.rating
    end
    #is this my recipe?
    @myRecipe = true if @recipe.users.first == current_user
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @recipe }
    end
  end

  # GET /recipes/new
  # GET /recipes/new.json
  def new
    @recipe = Recipe.new
    @availableIngredients = Ingredient.all
    respond_to do |format|
      if current_user
        format.html # new.html.erb
        format.json { render json: @recipe }
      else
        format.html { redirect_to recipes_url, notice: 'You must be logged in to create a recipe!'}
      end
    end
  end

  # GET /recipes/1/edit
  def edit
    @recipe = Recipe.find_by_url_slug(params[:id])
  end

  # POST /recipes
  # POST /recipes.json
  def create
    #create url_slug for recipe
    params[:recipe]['url_slug'] = get_slug(params[:recipe]['name'])
    params[:recipe]['created_by'] = current_user.id
    @recipe = Recipe.new(params[:recipe])
    @ingredients = params[:ingredients]
    @ingredients.each do |i|
      if i.empty?
        break
      end
      i = i.gsub(/\b\w/){$&.upcase}
      ingredient = Ingredient.find_by_name(i)
      if ingredient.nil?
        ingredient = Ingredient.new({"name" => i})
      end
      @recipe.ingredients << ingredient
    end
    @recipe.users << current_user
    respond_to do |format|
      if @recipe.save
        format.html { redirect_to @recipe, notice: 'Recipe was successfully created.' }
        format.json { render json: @recipe, status: :created, location: @recipe }
      else
        format.html { render action: "new" }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /recipes/1
  # PUT /recipes/1.json
  def update
    @recipe = Recipe.find_by_url_slug(params[:id])
    respond_to do |format|
      if @recipe.update_attributes(params[:recipe])
        format.html { redirect_to @recipe, notice: 'Recipe was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.json
  def destroy
    @recipe = Recipe.find_by_url_slug(params[:id])
    @personal_rating = @recipe.personalRecipeInfo.where("recipe_id=#{@recipe.id}")
    @recipe.destroy
    @personal_rating.each do |rating|
      rating.destroy
    end
    respond_to do |format|
      format.html { redirect_to recipes_url }
      format.json { head :no_content }
    end
  end

  # POST /recipes/:id/update_rating
  def update_rating
    @recipe = Recipe.find_by_url_slug(params[:id])
    @personal_rating = current_user.personalRecipeInfo.where("recipe_id=#{@recipe.id}").first
    if @personal_rating.nil?
      @recipe.users << current_user
      if @recipe.save
        #do nothing
      else
        redirect_to recipes_url, :notice => 'Something went wrong.'
      end
    end
    @personal_rating.rating = Integer(params[:rating])
    respond_to do |format|
      if @personal_rating.save
        @recipe.rating = @recipe.personalRecipeInfo.average(:rating)
        @recipe.total_ratings = @recipe.personalRecipeInfo.where("rating IS NOT NULL").count
        if @recipe.save
          format.json {render json: @recipe}
          format.xml {render xml: @recipe}
        else
          format.json {render json: @recipe.errors, status: :unprocessable_entity}
          format.xml {render xml: @recipe.errors}
        end
      else
        format.json {render json: @recipe.errors, status: :unprocessable_entity}
        format.xml {render xml: @recipe.errors}
      end
    end
  end

  def get_url_format(slug)
    return slug.gsub(/\s/, '-')
  end

  def get_slug(name)
    return name.downcase.gsub(/\s/,'-')
  end

end

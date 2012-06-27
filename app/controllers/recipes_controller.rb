 class RecipesController < ApplicationController
  layout 'recipes'
  helper_method :sort_type, :sort_direction
  # GET /recipes
  # GET /recipes.json
  def index
    @recipes = Recipe.includes(:ingredients).order(sort_type + " " + sort_direction).page(params[:page]).per(9)
    respond_to do |format|
      format.html { render :layout => 'wall'}
      format.json { render json: @recipes }
      format.js
    end
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
    @page = true
    @recipe = Recipe.includes(:ingredients, :personalRecipeInfo, :users).find_by_url_slug(params[:id])    
    if @recipe.nil?
      @recipe = Recipe.includes(:ingredients, :personalRecipeInfo, :users).find_by_url_slug(params[:name])
    end
    @ingredients = []
    @recipe.amounts.each do |amount|
      temp = {}
      temp['ingredient'] = @recipe.ingredients.select{|i| i.id == amount.ingredient_id}.first
      temp['amount'] = amount.amount
      temp['units'] = amount.units
      @ingredients << temp
    end

    @cook_time = hash_from_cook_time_string(@recipe.cook_time)
    @created_by = @recipe.users.first
    @created_by_name = name_to_use(@created_by)[0]

    if current_user
      @usersRecipeInfo = @recipe.personalRecipeInfo.select{|info| info.user_id == current_user.id}.first
      if @usersRecipeInfo
        if @usersRecipeInfo.favorite == true
          @favorite = true
        else
          @favorite = false
        end
        if @usersRecipeInfo.rating
          @personal_rating = @usersRecipeInfo.rating
        else
          @personal_rating = nil
        end
      else
        @favorite = false
        @personal_rating = nil
      end
      if session[:recent_recipes].index(@recipe.id) == nil
        if session[:recent_recipes].count > 3
          session[:recent_recipes].shift
        end
        session[:recent_recipes].push(@recipe.id)
      end
    end

    @users = @recipe.users
    @forks = @recipe.favorites
    #is this my recipe?
    @myRecipe = true if @recipe.users.first == current_user

    respond_to do |format|
      format.html
      format.json { render json: @recipe }
      format.js
    end
  end

  def search
    @recipes = Recipe.order('name ASC')
    render :action => 'show'
  end

  # GET /recipes/new
  # GET /recipes/new.json
  def new
    @recipe = Recipe.new
    @recipe.ingredients.build
    @availableIngredients = Ingredient.order('name ASC')
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
    @recipe = Recipe.includes(:ingredients).find_by_url_slug(params[:id])
    amounts = @recipe.amounts
    @ingredients = []
    amounts.each do |amount|
      temp = {}
      temp['name'] = @recipe.ingredients.select{|i| i.id == amount.ingredient_id}.first.name
      temp['amount'] = amount.amount
      temp['units'] = amount.units
      @ingredients << temp
    end
    logger.debug @ingredients
    @availableIngredients = Ingredient.order('name ASC')
  end

  # POST /recipes
  # POST /recipes.json
  def create
    params[:recipe]['url_slug'] = get_slug(params[:recipe]['name'])
    params[:recipe]['created_by'] = current_user.id
    params[:recipe]['cook_time'] = "#{params[:cook_time][0]}d#{params[:cook_time][1]}h#{params[:cook_time][2]}m"
    @recipe = Recipe.new(params[:recipe])
    @ingredients = params[:ingredients]
    @ingredients.delete_if {|i| i['name'].blank? or i['amount'].blank?}
    if @ingredients.empty?
      logger.info @ingredients.inspect
      @recipe.errors[:base] << 'You must add some ingredients!'
    end
    @ingredients.each do |i|
      if i['name'].empty?
        break
      end
      i['name'] = i['name'].gsub(/\b\w/){$&.upcase}
      ingredient = Ingredient.find_by_name(i['name'])
      if ingredient.nil?
        ingredient = Ingredient.new({"name" => i['name']})
      end
      if !@recipe.ingredients.include?(ingredient)
        @recipe.ingredients << ingredient
      end
    end
    @recipe.users << current_user
    respond_to do |format|
      if @recipe.errors.any?
        format.html {render action: 'new'}
        format.json {render json: @recipe.errors}
      else
        if @recipe.save
          add_amounts(@recipe, @ingredients)
          format.html { redirect_to @recipe, notice: 'Recipe was successfully created.' }
          format.json { render json: @recipe, status: :created, location: @recipe }
        else
          format.html { render action: 'new' }
          format.json { render json: @recipe.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /recipes/1
  # PUT /recipes/1.json
  def update
    @recipe = Recipe.includes(:ingredients).find_by_url_slug(params[:id])
    @ingredients = params[:ingredients]
    @ingredients.each do |i|
      if i['name'].empty?
        break
      end
      i['name'] = i['name'].gsub(/\b\w/){$&.upcase}
      ingredient = Ingredient.find_by_name(i['name'])
      if ingredient.nil?
        ingredient = Ingredient.new({"name" => i})
      end
      if !@recipe.ingredients.include?(ingredient)
        @recipe.ingredients << ingredient
      end
    end
    params[:recipe]['url_slug'] = get_slug(params[:recipe]['name'])
    params[:recipe]['cook_time'] = "#{params[:cook_time][0]}d#{params[:cook_time][1]}h#{params[:cook_time][2]}m"
    respond_to do |format|
      if @recipe.update_attributes(params[:recipe])
        add_amounts(@recipe, @ingredients)
        format.html { redirect_to @recipe }
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
    @recipes = Recipe.all
    respond_to do |format|
      format.html {redirect_to recipes_url, :status => 401}
      format.json {redirect_to recipes_url, :status => 401}
    end
  end

  # POST /recipes/:id/update_rating
  def update_rating
    @recipe = Recipe.includes(:users).find_by_url_slug(params[:id])
    @personal_rating = PersonalRecipeInfo.find_by_user_id_and_recipe_id(current_user.id, @recipe.id)
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

  def favorite
    recipe = Recipe.find_by_url_slug(params[:recipe_id])
    user = current_user
    render :json => recipe
  end

  def render_ingredients_input
    respond_to do |format|
      format.js {render 'index.js'}
    end
  end

  def get_url_format(slug)
    return slug.gsub(/\s/, '-')
  end

  def get_slug(name)
    return name.downcase.gsub(/\s/,'-')
  end

  private

  def sort_type
    Recipe.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  def name_to_use(user)
    if user.display_name
      return [user.display_name, user.display_name]
    elsif user.name
      return [user.name, user.name.split(' ')[0]]
    else
      return [user.email, user.email]
    end
  end

  def add_amounts(recipe, amounts)
    recipe.ingredients.each_with_index do |ingredient, index|
      amount = recipe.amounts.find_by_ingredient_id(ingredient.id)
      amount.amount = amounts[index]['amount'].to_i
      amount.units = amounts[index]['units'] unless amounts[index]['units'].nil?
      amount.save
    end
  end

  def hash_from_cook_time_string(cook_string = '')
    if cook_string.nil? or cook_string.blank?
      return {'d' => '', 'h' => '', 'm' => ''}
    else
    times = cook_string.split(/\D/)
    return {'d' => times[0], 'h' => times[1], 'm' => times[2]}
    end
  end
end

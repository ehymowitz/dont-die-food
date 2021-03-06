class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :search]

  def index
    @title = "Popular recipes - Don't Die Food"
    @recipes = policy_scope(Recipe)
    # @recipes = Recipe.all
    if user_signed_in?
      @recipes = current_user.sort_by_pantry_items(@recipes)
    end
    skip_authorization

  end

  def show
    @recipe = Recipe.find(params[:id])
    @title = "#{@recipe.title} - Don't Die Food"
    skip_authorization
    @save_recipe = SavedRecipe.new
    @user_saved_recipe = SavedRecipe.where(user: current_user, recipe: @recipe)

    if user_signed_in?
      @user_owned_ingredients_name = current_user.ingredients.pluck(:name)
    else
      @user_owned_ingredients_name = []
    end
  end

  def search
    skip_authorization
    @title = "Recipes results - Don't Die Food"

    if params[:ingredients]
      @results = Recipe.all.to_a.select do |recipe|
        params[:ingredients].all? { |id| recipe.ingredient_ids.map { |id| id.to_s }
                            .include?(id) }
      end

      if user_signed_in?
        @results = current_user.sort_by_pantry_items(@results)
        @search_terms_count = params[:ingredients].length
        pantry_item_match = false
        current_user.pantry_items.each do |item|
          if params[:ingredients].include?(item.ingredient_id.to_s)
            pantry_item_match = true
          end
        end
      end

      if pantry_item_match
        matches = params[:ingredients].select do |ingredient|
          PantryItem.where(ingredient_id: ingredient.to_i, user_id: current_user.id)
        end
        @search_terms_count -= matches.count
      end
    end
  end
end

class RecipesController < ApplicationController
  def new

  end

  def create

  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def index
    @recipes = current_user.recipes
    @recipes = @recipes.where("name ILIKE ?", "%#{params[:query]}%") if params[:query].present?
  end
end

class CategoriesController < ApplicationController

  def index
    @category = Category.all
    json_response(@category)
  end
end

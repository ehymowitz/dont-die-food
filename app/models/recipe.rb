class Recipe < ApplicationRecord
  has_many :ingredients, through: :recipe_ingredients

  validates :title, presence: true, uniqueness: true
  validates :ingredients_data, presence: true
  validates :steps_data, presence: true

end

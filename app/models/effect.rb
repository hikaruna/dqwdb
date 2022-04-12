class Effect < ApplicationRecord
  self.table_name = '効果'
  self.primary_key = '効果'

  has_many :mind_effects, foreign_key: '効果', primary_key: '効果'
  has_many :minds, through: :mind_effects
end

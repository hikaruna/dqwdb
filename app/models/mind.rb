class Mind < ApplicationRecord
  self.table_name = 'こころ'
  self.primary_key = 'こころ_no'

  has_many :mind_effects, foreign_key: 'こころ_no', primary_key: 'こころ_no'
  has_many :effects, through: :mind_effects
end

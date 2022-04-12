class MindEffect < ApplicationRecord
  self.table_name = 'こころ効果'

  belongs_to :mind, foreign_key: 'こころ_no', primary_key: 'こころ_no', inverse_of: :mind_effects
  belongs_to :effect, foreign_key: '効果', primary_key: '効果', inverse_of: :mind_effects
end

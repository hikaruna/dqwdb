class CreateMinds < ActiveRecord::Migration[7.0]
  def change
    create_table 'こころ', primary_key: 'こころ_no' do |t|
      t.string :name
      t.integer 'ちから'
    end

    create_table '効果', id: :string, primary_key: '効果' do |t|
    end

    create_table 'こころ効果', primary_key: 'こころ効果' do |t|
      t.integer 'こころ_no'
      t.string '効果'
    end
    add_index 'こころ効果', ['こころ_no', '効果'], unique: true
    add_foreign_key 'こころ効果', 'こころ', column: 'こころ_no', primary_key: 'こころ_no'
    add_foreign_key 'こころ効果', '効果', column: '効果', primary_key: '効果'
  end
end

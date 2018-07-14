class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.integer :categorizable_id
      t.string  :categorizable_type
      t.integer :hashtag_id
    end
    add_index :categories, [:categorizable_type, :categorizable_id]
  end
end

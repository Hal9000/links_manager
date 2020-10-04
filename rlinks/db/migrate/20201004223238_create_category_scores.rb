class CreateCategoryScores < ActiveRecord::Migration[6.0]
  def change
    create_table :category_scores do |t|
      t.integer :category_id
      t.integer :link_id
      t.integer :score

      t.timestamps
    end
  end
end

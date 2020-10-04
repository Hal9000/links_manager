class CreateTagScores < ActiveRecord::Migration[6.0]
  def change
    create_table :tag_scores do |t|
      t.integer :tag_id
      t.integer :link_id
      t.integer :score

      t.timestamps
    end
  end
end

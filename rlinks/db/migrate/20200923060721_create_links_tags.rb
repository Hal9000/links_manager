class CreateLinksTags < ActiveRecord::Migration[6.0]
  def change
    create_table :links_tags do |t|
      t.integer :tag_id
      t.integer :link_id
      t.integer :score

      t.timestamps
    end
  end
end

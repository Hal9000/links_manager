class CreateLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :links do |t|
      t.string :link
      t.string :title
      t.string :desc
      t.integer :score
      t.boolean :timeout
      t.boolean :badcert

      t.timestamps
    end
  end
end

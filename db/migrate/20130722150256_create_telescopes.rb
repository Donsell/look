class CreateTelescopes < ActiveRecord::Migration
  def change
    create_table :telescopes do |t|
      t.integer :user_id
      t.string :name
      t.string :manufacturer
      t.integer :focal_length
      t.integer :aperature

      t.timestamps
    end
  end
end

class CreateRedlines < ActiveRecord::Migration
  def change
    create_table :redlines do |t|
      t.string  :key
      t.integer :user_id
      t.integer :document_id

      t.timestamps null: false
    end
    add_index :redlines, :key, unique: true
    add_index :redlines, :user_id
    add_index :redlines, :document_id
  end
end

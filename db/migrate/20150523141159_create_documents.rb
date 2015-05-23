class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer :repository_id
      t.string :path

      t.timestamps null: false
    end
    add_index :documents, :repository_id
  end
end

class AddRefToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :ref, :string, :default => "master"
  end
end

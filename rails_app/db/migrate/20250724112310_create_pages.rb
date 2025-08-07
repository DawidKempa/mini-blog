class CreatePages < ActiveRecord::Migration[6.1]
  def change
    create_table :pages do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :content
      t.references :parent, foreign_key: { to_table: :pages }
      t.references :user, null: false, foreign_key: true
      t.boolean :published, default: false
      t.integer :position

      t.timestamps
    end

    add_index :pages, :slug, unique: true
  end
end
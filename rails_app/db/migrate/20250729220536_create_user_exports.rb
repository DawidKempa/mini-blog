class CreateUserExports < ActiveRecord::Migration[8.0]
  def change
    create_table :user_exports do |t|
      t.references :user, null: false, foreign_key: true
      t.string :filename
      t.string :file_path

      t.timestamps
    end
  end
end

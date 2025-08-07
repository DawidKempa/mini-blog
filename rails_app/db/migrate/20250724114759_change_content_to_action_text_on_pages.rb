class ChangeContentToActionTextOnPages < ActiveRecord::Migration[8.0]
  def change
    remove_column :pages, :content
  end
end
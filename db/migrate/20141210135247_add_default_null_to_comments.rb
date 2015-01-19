class AddDefaultNullToComments < ActiveRecord::Migration
  def change
    change_column_default :comments, :parent_comment_id, nil
  end
end

class AddDefaultToStatus < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :status, from: nil, to: 'active'
  end
end

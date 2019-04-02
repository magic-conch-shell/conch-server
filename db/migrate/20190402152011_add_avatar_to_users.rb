class AddAvatarToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :avatar, :string, :default => 'https://www.wittenberg.edu/sites/default/files/2017-11/nouser_0.jpg'
  end
end

class AddIsDirtyToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :is_dirty, :boolean, default: false
  end
end

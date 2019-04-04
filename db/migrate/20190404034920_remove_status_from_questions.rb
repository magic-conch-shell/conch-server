class RemoveStatusFromQuestions < ActiveRecord::Migration[5.2]
  def change
    remove_column :questions, :status, :string
  end
end

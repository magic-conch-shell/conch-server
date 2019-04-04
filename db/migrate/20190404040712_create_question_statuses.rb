class CreateQuestionStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :question_statuses do |t|
      t.references :question, foreign_key: true
      t.string :status
      t.integer :mentor_id

      t.timestamps
    end
  end
end

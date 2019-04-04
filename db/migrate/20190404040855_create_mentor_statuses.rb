class CreateMentorStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :mentor_statuses do |t|
      t.references :user, foreign_key: true
      t.boolean :status

      t.timestamps
    end
  end
end

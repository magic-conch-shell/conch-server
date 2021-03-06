class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.string :title
      t.text :content
      t.references :user, foreign_key: true
      t.boolean :solved

      t.timestamps
    end
  end
end

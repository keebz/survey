class FixAnswers < ActiveRecord::Migration
  def change
    remove_column :answers, :survey_id

    add_column :answers, :question_id, :integer
  end
end

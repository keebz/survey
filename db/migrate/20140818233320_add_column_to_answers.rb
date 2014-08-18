class AddColumnToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :other, :boolean
  end
end

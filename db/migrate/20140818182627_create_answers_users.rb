class CreateAnswersUsers < ActiveRecord::Migration
  def change
    create_table :answers_users do |t|
      t.belongs_to :answer
      t.belongs_to :user
    end
  end
end

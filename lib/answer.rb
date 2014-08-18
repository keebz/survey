class Answer < ActiveRecord::Base
  belongs_to :question
  has_and_belongs_to_many :users

  before_save :option_false

private

  def option_false
    self.option == false
  end
end

class Question < ActiveRecord::Base
  validates :question, :presence => true
  belongs_to :survey
  has_many :answers
end


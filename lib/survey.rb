class Survey < ActiveRecord::Base
  validates :name, :presence => true

  has_many :questions
end

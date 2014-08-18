require 'spec_helper'
require 'pry'

describe Survey do
  it "should validate presence of name" do
    new_survey = Survey.create({name: ""})
    expect(new_survey.save).to eq false
  end

  it "has many questions" do
    new_survey = Survey.create({name: "New Bike"})
    new_question = Question.create({question: "What kind?"})
    new_question1 = Question.create({question: "How much?"})
    new_survey.questions << new_question
    new_survey.questions << new_question1
    expect(new_survey.questions).to eq [new_question, new_question1]
  end
end

require 'spec_helper'
require 'pry'

describe Survey do
  it "should validate presence of name" do
    new_survey = Survey.create({name: ""})
    expect(new_survey.save).to eq false
  end

  it "has many questions" do
    new_survey = Survey.create({name: "New Bike"})
    new_question = new_survey.questions.create({question: "What kind?"})
    new_question1 = new_survey.questions.create({question: "How much?"})
    expect(new_survey.questions).to eq [new_question, new_question1]
  end
end

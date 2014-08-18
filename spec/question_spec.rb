require 'spec_helper'
require 'pry'

describe Question do

  it "should validate with a question" do
    new_question = Question.create({question: ""})
    expect(new_question.save).to eq false
  end

  it "has many answers" do
    new_question = Question.create({question: "what kind?"})
    new_answer = new_question.answers.create({answer: "Huffy"})
    expect(new_question.answers).to eq [new_answer]
  end
end

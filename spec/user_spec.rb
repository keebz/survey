require 'spec_helper'

describe User do
  it "has and belongs to many answers" do
    bob = User.create()
    new_question = Question.create({question: "what kind?"})
    new_answer = new_question.answers.create({answer: "Huffy"})
    bob.answers << new_answer
    expect(bob.answers).to eq [new_answer]
  end
end

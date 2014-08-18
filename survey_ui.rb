require 'bundler/setup'
Bundler.require(:default)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }
ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["development"])
DB = PG.connect({:dbname => 'survey_development'})

def main
  puts "Welcome"
  puts "If you are a surveyor press [1]"
  puts "If you are a survey taker press [2]"
  puts "Press [x] to exit"
  selection = gets.chomp.to_s
  if selection == '1'
    surveyor_menu
  elsif selection == '2'
    survey_menu
  elsif selection == 'x'
    exit
  else
    puts "Invalid selection"
    main
  end
end

def survey_menu
 puts "to select a survey to take press [1]"
 puts "to exit press [x]"

 selection = gets.chomp.to_s

  if selection == '1'
    select_survey
    puts "Thank you for your feedback!"
    survey_menu
  elsif selection == 'x'
    exit
  else
    puts "invalid input!"
    survey_menu
  end
end

def select_survey
  list_surveys
  puts "please select a survey by number:"
  selection = gets.chomp.to_i - 1
  new_user = User.create()

  @user_survey = Survey.all[selection]
  @user_survey.questions.each do |question|
    puts question.question

    puts "Select from the following answers:"

    question.answers.each do |answer|
      puts answer.answer
    end
    answer = gets.chomp
    selected_answer = question.answers.find_by({answer: answer})
    new_user.answers << selected_answer
  end

end


def surveyor_menu

  puts "to create a new survey press [1]"
  puts "to select a survey to modify press [2]"
  # puts "to see a survey takers results press [3]"
  puts "to see all of the results for a survey press [3]"
  puts "to exit to main menu press [m]"
  selection = gets.chomp.to_s

  until selection == 'm'
    case selection
    when '1'
      create_survey
    when '2'
      edit_survey
      surveyor_menu
    # when '3'
    #   select_user
    when '3'
      survey_results
      puts "\n\n"
      surveyor_menu
    end
  end
  main
end

# def select_user
#   list_users
#   puts "Enter a user ID to view the surveys the user has taken:"
#   @current_user = User.find(gets.chomp)
#   puts ""
# end

def survey_results
  list_surveys
  puts "Enter the survey name to see its results:"
  current_survey = Survey.find_by(name: gets.chomp)
  current_survey.questions.each do |question|
    puts "\n\nFor People Asked " + question.question
    question.answers.each do |answer|
      puts answer.users.count.to_s + " answered with: " + answer.answer

    end
  end
end

def create_survey
  puts "please name your new survey"
  name = gets.chomp
  @new_survey = Survey.create({name: name})
  puts @new_survey.name + " has been created!"
  loop do
    puts "to add a question to this survey press [a]"
    puts "to complete this survey and return to main menu press [m]"
    selection = gets.chomp.to_s
    if selection == 'a'
      add_question
    elsif selection == 'm'
      main
      break
    else
      puts "invaild entry"
    end
  end
end

def add_question
  puts "Create a new question to add to #{@new_survey.name}:"
  @new_question = Question.create({question: gets.chomp})
  @new_survey.questions << @new_question
  puts "New question added to '#{@new_survey.name}'!"
  add_answers
end

def delete_question
  puts "Select a question from #{@new_survey.name} to delete:"
  list_questions
  input = gets.chomp.to_i - 1
  @new_question = Question.where(survey_id: @new_survey.id)[input]
  @new_question.destroy
  puts "Question deleted!"
end

def add_answers
  puts "Create a new answer to add to #{@new_question.question}:"
  @new_answer = Answer.create({answer: gets.chomp})
  @new_question.answers << @new_answer
  puts "New answer added to '#{@new_question.question}'!"
  puts "Add another answer? (y/n)"
  if gets.chomp.upcase == 'Y'
    add_answers
  end
end

def edit_survey
  puts "Enter the name of the survey you want to modify:"
  list_surveys
  @new_survey = Survey.find_by(name: gets.chomp)
  puts "to delete a survey, press [1]"
  puts "to add a question, press [2]"
  puts "to delete a question, press [3]"


  case gets.chomp
  when '1' then @new_survey.destroy; puts "Survey deleted!"
  when '2' then add_question
  when '3' then delete_question
  end
end

def list_surveys
  Survey.all.each_with_index { |survey, i| puts "#{i + 1}. #{survey.name}"}
end

def list_questions
  Question.where(survey_id: @new_survey.id).each_with_index do |question, i|
    puts "#{i + 1}. #{question.question}"
  end
end

def list_users
  User.all.each { |user| puts "User ID: #{'user.id'}"}
end

main

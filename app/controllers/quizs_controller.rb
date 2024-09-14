class QuizsController < ApplicationController
  before_action :find_quiz, except: %i[create]
  before_action :authenticate_user

  def show 
    q = @quiz.questions
    render json: {
      "quiz title": @quiz.title,
      "questions": q.as_json(only: [:que], methods: [:options])
    }
  end

  def take_quiz
    count = 0
    ca = []
    ua = []
    @quiz.questions.each do |q|
      ca << q.answer
    end
    params.require(:questions).permit!
    params[:questions].each do |_, value|
      ua << value[:user_answer]
      @quiz.questions.each do |question|
        if question.answer == value[:user_answer].to_s.downcase
          count += 1
        end
      end
    end
    render json: {
      "score": "#{count} out of #{@quiz.questions.count}",
      "correct answers": ca,
      "user answers": ua
    }
  end

  def create
    @quiz = Quiz.new(quiz_params)
    params.require(:questions).permit!
    params[:questions].each do |_, value|
      @quiz.questions.build(que: value[:que], options: value[:options].to_h, answer: value[:answer])
    end
    if @quiz.save
      render json: {message: 'quiz game created'}
    else
      render json: @quiz.errors
    end
  end

  def update
    if @quiz.update(quiz_params)
      render json: {message: 'quiz game updated'}
    else
      render json: @quiz.errors
    end
  end

  def update_questions
    params.require(:questions).permit!
    message = false
    params[:questions].each do |_, value|
      unless value[:id].nil?
        question = Question.find(value[:id])
        attributes = {}
        attributes[:que] = value[:que] if value[:que].present?
        attributes[:options] = value[:options].to_h if value[:options].present?
        attributes[:answer] = value[:answer] if value[:answer].present?
        if question.update(attributes)
          message = true
        end
      else
        if @quiz.questions.create(que: value[:que], options: value[:options].to_h, answer: value[:answer])
          message = true
        end
      end
    end
    if message
      render json: {message: 'questions updated for quiz'}
    else
      render json: {message: 'errors in questions, please check.'}
    end
  end

  def destroy_questions
    @question = Question.find(params[:question_id])
    @question.destroy!
    render json: {message: 'question removed from quiz.'}
  end

  def destroy
    @quiz.destroy!
    render json: {message: 'quiz game deleted'}
  end

  private
  def find_quiz
    @quiz = Quiz.find(params[:id])
  end

  def quiz_params
    params.require(:quiz).permit(:title)
  end
end
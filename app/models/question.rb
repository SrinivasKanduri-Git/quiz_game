class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :quiz
  field :que, type: String
  field :options, type: Hash, default: {}
  field :answer, type: String
  field :user_answer, type: String

  validates_presence_of(:que, :options, :answer)
end
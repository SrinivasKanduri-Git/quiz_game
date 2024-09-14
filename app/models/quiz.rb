class Quiz
  include Mongoid::Document
  include Mongoid::Timestamps
  has_many :questions, dependent: :destroy
  field :title, type:String
  accepts_nested_attributes_for :questions
  validates :title, presence: true, uniqueness: true
end
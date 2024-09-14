class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  field :first_name, type: String
  field :last_name, type: String
  field :email, type: String
  field :password_digest, type: String
  field :dob, type: Date
  field :status, type: Boolean, default: false
  field :phone_numbers, type: Array, default: []

  validates_presence_of(:first_name, :last_name)
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, uniqueness: true
  validate :dob_type
  validate :phone_number
  has_secure_password

  private
  def dob_type
    errors.add(:dob, "enter a valid date") unless dob.is_a?(Date)
  end

  def phone_number
    phone_numbers.each do |number|
      errors.add(:phone_number, 'is invalid') unless number =~ /\A([6-9]{1}[0-9]{9})\z/
    end
  end
end

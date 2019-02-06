class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
       
  include DeviseTokenAuth::Concerns::User

  validates_uniqueness_of :auth_token
  before_create :generate_authentication_token!

  has_many :businesses, dependent: :destroy
  has_many :campaigns, dependent: :destroy
  has_many :offers, dependent: :destroy
  has_many :stores, dependent: :destroy
  has_many :store_campaigns, dependent: :destroy
  has_many :shopping_lists, dependent: :destroy
  has_many :shopping_list_offers, dependent: :destroy
  has_many :business_accounts, dependent: :destroy
  has_many :billings, dependent: :destroy

  def info
    "#{email} - #{created_at} - Token: #{Devise.friendly_token}"
  end

  def admin?
    self.user_type==="A"
  end

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token

    end while User.exists?(auth_token: auth_token)
  end
end

# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  extend Devise::Models
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :columns, dependent: :destroy

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 
  validates :password, :presence => true,
            :confirmation => true,
            :length => {:within => 6..40},
            :on => :create
  validates :password, :confirmation => true,
            :length => {:within => 6..40},
            :allow_blank => true,
            :on => :update
  validates :name, presence: true
  validates :nickname, presence: true
end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_one :address
  accepts_nested_attributes_for :address
  has_one :card, dependent: :destroy, inverse_of: :user
  has_many :comments
  has_many :likes
  has_many :items, foreign_key: "saler_id", class_name: "Item"
  has_many :items, foreign_key: "buyer_id", class_name: "Item"
  has_many :orders

  validates :nickname, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8}
  validates :password_confirmation, presence: true, length: { minimum: 8}
  validates :family_name, format: { with: /\A[ぁ-んァ-ン一-龥]+\z/, message: 'は全角で入力してください'}, presence: true
  validates :first_name, format: { with: /\A[ぁ-んァ-ン一-龥]+\z/, message: 'は全角で入力してください'}, presence: true
  validates :family_name_kana, format: { with: /\A[ぁ-んァ-ン一-龥]+\z/, message: 'は全角で入力してください'}, presence: true
  validates :first_name_kana, format: { with: /\A[ぁ-んァ-ン一-龥]+\z/, message: 'は全角で入力してください'}, presence: true
  validates :birthday, presence: true
  validates :phone_authy, presence: true, length: { is: 11}
end

class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture
  has_many :comment
  has_many :likes, dependent: :destroy
  has_many :images, dependent: :destroy
  belongs_to :buyer, class_name: "User", optional: true
  belongs_to :seller, class_name: "User", optional: true
  belongs_to :category
  belongs_to :brand, optional: true
  accepts_nested_attributes_for :images, allow_destroy: true

  # カテゴリidとブランドidは機能ができたらoptionalを外す
end

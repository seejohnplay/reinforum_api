class Post < ApplicationRecord
  belongs_to :category
  has_many :comments, dependent: :destroy

  validates_presence_of :author, :category_id, :title
end
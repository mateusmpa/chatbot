class Hashtag < ActiveRecord::Base
  validates_presence_of :name

  has_many :faqs_hashtag
  has_many :faqs, through: :faqs_hashtags
  belongs_to :company
end

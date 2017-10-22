class Company < ActiveRecord::Base
  validates_presence_of :name

  has_many :faq
  has_many :hashtags
end

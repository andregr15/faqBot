class Hashtag < ActiveRecord::Base
  validates_presence_of :name
  has_many :faq_hashtags
  has_many :faqs, through: :faq_hashtags
  belongs_to :company

  has_many :categories
  has_many :categorizables, through: :categories
  has_many :links, through: :categories, source: 'Link'
end
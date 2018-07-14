class Hashtag < ActiveRecord::Base
  validates_presence_of :name
  belongs_to :company

  has_many :categories
  has_many :links, through: :categories, source: :categorizable, source_type: 'Link'
  has_many :faqs, through: :categories, source: :categorizable, source_type: 'Faq'
end
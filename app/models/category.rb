class Category < ActiveRecord::Base
  validates_presence_of :hashtag_id
  
  belongs_to :categorizable, polymorphic: true
  belongs_to :hashtag

  has_many :hashtags, through: [:link, :faq]
end
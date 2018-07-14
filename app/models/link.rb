require 'pg_search'
include PgSearch

class Link < ActiveRecord::Base
  validates_presence_of :name, :description, :url
  belongs_to :company

  has_many :categories, as: :categorizable
  has_many :hashtags, through: :categories, source: :hashtag

  pg_search_scope :search, :against => [:name, :description, :url]
end
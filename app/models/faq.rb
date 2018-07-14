require 'pg_search'
include PgSearch

class Faq < ActiveRecord::Base
  validates_presence_of :question, :answer
  belongs_to :company

  has_many :categories, as: :categorizable
  has_many :hashtags, through: :categories, source: :hashtag

  # include PgSearch
  pg_search_scope :search, :against => [:question, :answer]
end
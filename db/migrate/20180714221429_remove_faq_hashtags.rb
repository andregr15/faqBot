class RemoveFaqHashtags < ActiveRecord::Migration[5.2]
  def change
    drop_table :faq_hashtags
  end
end

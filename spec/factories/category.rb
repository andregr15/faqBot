FactoryBot.define do
  factory :category_link, class: 'Category' do
    hashtag
    association :categorizable, factory: :link
  end

  factory :category_faq, class: 'Category' do
    hashtag
    association :categorizable, factory: :faq
  end
end
FactoryBot.define do
  factory :link do
    name FFaker::Lorem.word
    description FFaker::Lorem.sentence
    url FFaker::Internet.http_url
    company
  end
end
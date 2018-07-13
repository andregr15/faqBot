class QuoteService
  def self.call
    quotes = JSON.parse(File.read('app/assets/quotes.json'))
    sample = quotes['citacao'].sample
    "_#{sample['quote']}_ \n\n >Autor: _#{sample['author']}_"
  end
end
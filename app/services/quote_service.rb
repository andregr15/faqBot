class QuoteService
  def self.call
    quotes = JSON.parse(File.read('app/assets/quotes.json'))
    sample = quotes['citacao'].sample
    
    response = "_#{sample['quote']}_ \n\n"
    response += ">Autor: _#{sample['author']}_"
  end
end
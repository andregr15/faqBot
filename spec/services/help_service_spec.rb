require_relative './../spec_helper.rb'

describe HelpService do
  descrive '#call' do
    it 'should return a list of main commands' do
      response = HelpService.call
      
      # expect(response).to match('help')
      # expect(response).to match('Add a Faq')
      # expect(response).to match('Remove a Faq by his id')
      # expect(response).to match('What you know about x')
      # expect(response).to match('Search by the hashtag')
      # expect(response).to match('Questions and Answers')
      
      expect(response).to match('help')
      expect(response).to match('Adicione ao Faq')
      expect(response).to match('Remova ID')
      expect(response).to match('O que você sabe sobre X')
      expect(response).to match('Pesquise a hashtag X')
      expect(response).to match('Perguntas e Respostas')
    end
  end
end
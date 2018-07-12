require_relative './../spec_helper.rb'

describe InterpretService do
  before :each do
    @company = create(:company)
  end

  describe '#list' do
    it 'should return the message of nothing found when no faqs in database' do
      response = InterpretService.call('list', {})
      #expect(response).to match('Nothing found')
      expect(response).to match('Nada encontrado')
    end

    it 'should return the questions and answers when are faqs in database' do
      faq1 = create(:faq, company: @company)
      faq2 = create(:faq, company: @company)

      response = InterpretService.call('list', {})

      expect(response).to match(faq1.question)
      expect(response).to match(faq1.answer)

      expect(response).to match(faq2.question)
      expect(response).to match(faq2.answer)
    end
  end

  describe '#search' do
    it 'should return the message of nothing found when an empty query is used' do
      response = InterpretService.call('search', { 'query' => '' })
      #expect(response).to match('Nothing found')
      expect(response).to match('Nada encontrado')
    end

    it 'should return questions and answers when a valid query is used' do
      faq = create(:faq, company: @company)

      response = InterpretService.call('search', { 'query' => faq.question.split(" ").sample })
      
      expect(response).to match(faq.question)
      expect(response).to match(faq.answer)
    end
  end

  describe '#search by category' do
    it 'should return the message of nothing found when an empty query is used' do
      response = InterpretService.call('search_by_hashtag', { 'query' => '' })
      #expect(response).to match('Nothing found')
      expect(response).to match('Nada encontrado')
    end

    it 'should return question and answers when a valid query is used' do
      faq = create(:faq, company: @company)
      hashtag = create(:hashtag, company: @company)
      create(:faq_hashtag, faq: faq, hashtag: hashtag)

      response = InterpretService.call('search_by_hashtag', { 'query' => hashtag.name })

      expect(response).to match(faq.question)
      expect(response).to match(faq.answer)
    end
  end

  describe '#create' do
    before do
      @question = FFaker::Lorem.sentence
      @answer = FFaker::Lorem.sentence
      @hashtags = "#{FFaker::Lorem.word}, #{FFaker::Lorem.word}"
    end

    it 'should return the message of hashtag is missing when no hashtag param is used' do
      response = InterpretService.call('create', {
        'question-original' => @question,
        'answer-original' => @answer
      })

      #expect(response).to match('Hashtag is missing')
      expect(response).to match('Hashtag obrigatória')
    end

    context 'With hashtag params' do
      before :each do 
        @response = InterpretService.call('create', {
          'question-original' => @question,
          'answer-original' => @answer,
          'hashtags-original' => @hashtags
        })
      end

      it 'should return the message of created with success' do
        #expect(@response).to match('Created with success')
        expect(@response).to match('Criado com sucesso')
      end

      it 'should find question and answer in database' do
        expect(Faq.last.question).to match(@question)
        expect(Faq.last.answer).to match(@answer)
      end

      it 'should find hashtags in database' do 
          expect(@hashtags.split(/[\s,]+/).first).to match(Hashtag.first.name)
          expect(@hashtags.split(/[\s,]+/).last).to match(Hashtag.last.name)
      end
    end
  end

  describe '#remove' do

    context 'With an invalid id' do
      it 'should return the message of invalid id' do
        response = InterpretService.call('remove', { 'id' => rand(1..9999) })
        #expect(response).to match('Invalid id')
        expect(response).to match('Questão inválida, verifique o ID')
      end
    end

    context 'With a valid id' do
      before :each do
        faq = create(:faq, company: @company)
        @response = InterpretService.call('remove', { 'id' => faq.id })
      end

      it 'should return the message of removed with success' do
        #expect(@response).to match('Removed with success')
        expect(@response).to match('Removido com sucesso')
      end

      it 'should remove the faq' do
        expect(Faq.all.count).to eql(0)
      end

    end

  end
  
end
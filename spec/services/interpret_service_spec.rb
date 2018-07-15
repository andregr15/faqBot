require_relative './../spec_helper.rb'

describe InterpretService do
  before :each do
    @company = create(:company)
  end

  it 'should return the message of didn\'t understand your wish' do
    response = InterpretService.call('teste', {})
    expect(response).to eql('Não compreendi o seu desejo')
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
      create(:category_faq, hashtag: hashtag, categorizable: faq)

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

      it 'should have created the relationship between faq and hashtag in the database' do
        expect(@hashtags.split(/[\s,]+/).first).to match(Faq.first.hashtags.first.name)
        expect(@hashtags.split(/[\s,]+/).last).to match(Faq.first.hashtags.last.name)
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

  describe '#quote' do
    it 'should return a quote' do
      response = InterpretService.call('quote', { })
      expect(response).to match('Autor')
    end
  end

  describe '#list_links' do
    it 'should return the message of nothing found when no links in the database' do
      response = InterpretService.call('list_links', { 'query' => '' })
      expect(response).to eql('Nada encontrado')
    end

    it 'should return the links when are links in the database' do
      link = create(:link, company: @company)
      link2 = create(:link, company: @company)
      hashtag = create(:hashtag, company: @company)
      create(:category_link, hashtag: hashtag, categorizable: link)
      create(:category_link, hashtag: hashtag, categorizable: link2)
      response = InterpretService.call('list_links', { 'query' => link.description.split(' ').sample })

      expect(response).to match(link.name)
      expect(response).to match(link.description)
      expect(response).to match(link.url)
      
      expect(response).to match(link2.name)
      expect(response).to match(link2.description)
      expect(response).to match(link2.url)

      expect(response).to match(hashtag.name)
    end
  end

  describe '#search_links' do
    it 'should return the message of nothing found when an empty query is used' do
      response = InterpretService.call('search_links', { 'query' => '' })
      expect(response).to eql('Nada encontrado')
    end

    it 'should return the link when a valid query is used' do
      link = create(:link, company: @company)
      response = InterpretService.call('search_links', { 'query' => link.name.split(' ').sample })

      expect(response).to match(link.name)
      expect(response).to match(link.description)
      expect(response).to match(link.url)
    end
  end

  describe '#search_by_hashtags_links' do
    it 'should return the message of nothing found when an empty query is used' do
      response = InterpretService.call('search_by_hashtag_links', { 'query' => '' })
      expect(response).to eql('Nada encontrado')
    end

    it 'should return the links when a valid query is used' do
      link = create(:link, company: @company)
      link2 = create(:link, company: @company)
      hashtag = create(:hashtag, company: @company)

      create(:category_link, hashtag: hashtag, categorizable: link)
      create(:category_link, hashtag: hashtag, categorizable: link2)

      response = InterpretService.call('search_by_hashtag_links', { 'query' => hashtag.name })

      expect(response).to match(link.name)
      expect(response).to match(link.description)
      expect(response).to match(link.url)

      expect(response).to match(link2.name)
      expect(response).to match(link2.description)
      expect(response).to match(link2.url)

      expect(response).to match(hashtag.name)
    end
  end

  describe '#create_links' do
    before :each do
      @name = FFaker::Lorem.word
      @description = FFaker::Lorem.sentence
      @url = FFaker::Internet.http_url
    end
    
    it 'should return the message of missing hashtags when no hashtags params is used' do
      response = InterpretService.call('create_links', {
        'name-original' => @name,
        'description-original' => @description,
        'url-original' => @url
      })

      expect(response).to eql('Hashtag obrigatória')
    end

    context 'when used the hashtags params' do
      before :each do
        @hashtags = "#{FFaker::Lorem.word}, #{FFaker::Lorem.word}"
        @response = InterpretService.call('create_links', {
          'name-original' => @name,
          'description-original' => @description,
          'url-original' => @url,
          'hashtags-original' => @hashtags
        })
      end

      it 'should return the message of created with success' do
        expect(@response).to eql('Criado com sucesso')
      end

      it 'should have created the link in the database' do
        expect(Link.last.name).to eql(@name)
        expect(Link.last.description).to eql(@description)
        expect(Link.last.url).to eql(@url)
      end

      it 'should have created the hashtags in the database' do
        expect(@hashtags.split(/[\s,]+/).first).to eql(Hashtag.first.name)
        expect(@hashtags.split(/[\s,]+/).last).to eql(Hashtag.last.name)
      end

      it 'should have created the relationship between link and hashtag in the database' do
        expect(@hashtags.split(/[\s,]+/).first).to eql(Link.first.hashtags.first.name)
        expect(@hashtags.split(/[\s,]+/).last).to eql(Link.first.hashtags.last.name)
      end
    end

  end

  describe '#remove_links' do
    it 'should return the message of invalid ID' do
      response = InterpretService.call('remove_links', { 'id' => rand(0..9999) })
      expect(response).to eql('Link inválido, verifique o ID')
    end

    context 'when a valid id is used' do
      before :each do
        link = create(:link, company: @company)
        @response = InterpretService.call('remove_links', { 'id'=> link.id })
      end

      it 'should return the message of removed with success' do
        expect(@response).to eql('Removido com sucesso')
      end

      it 'should have removed the link from the database' do
        expect(Link.all.count).to eq(0)
      end
    end
  end
  
end
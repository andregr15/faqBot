require_relative './../../spec_helper.rb'

describe FaqModule::ListService do
  before do
    @company = create(:company)
  end

  describe '#call' do

    context 'using list command' do
      before :each do
        @service = FaqModule::ListService.new({}, 'list')
      end

      it 'should return message of nothing found when no faqs in database' do
        response = @service.call
        #expect(response).to match('nothing found')
        expect(response).to match('Nada encontrado')
      end

      it 'should return questions and answers when are faqs in database' do
        faq1 = create(:faq, company: @company)
        faq2 = create(:faq, company: @company)

        response = @service.call

        expect(response).to match(faq1.question)
        expect(response).to match(faq1.answer)

        expect(response).to match(faq2.question)
        expect(response).to match(faq2.answer)
      end
    end

    context 'using search command' do
      it 'should return message of nothing found when an empty query is used' do
        service = FaqModule::ListService.new({ query: '' }, 'search')

        response = service.call
        #expect(response).to match('nothing found')
        expect(response).to match('Nada encontrado')
      end

      it 'should return questions and answers when a valid query is used' do
        faq = create(:faq, company: @company)
        service = FaqModule::ListService.new({ query: faq.question.split(' ').sample}, 'search')

        response = service.call

        expect(response).to match(faq.question)
        expect(response).to match(faq.answer)
      end
    end

    context 'using search_by_hashtag command' do
      it 'should return message of nothing found when an empty query is used' do
        service = FaqModule::ListService.new({ query: '' }, 'search_by_hashtag')
        
        response = service.call
        #expect(response).to match('nothing found')
        expect(response).to match('Nada encontrado')
      end

      it 'should return question and answers when a valid query is used' do
        faq = create(:faq, company: @company)
        hastag = create(:hashtag, company: @company)
        create(:faq_hashtag, faq: faq, hashtag: hashtag)

        service = FaqModule::ListService.new({ query: hashtag.name }, 'search_by_hashtag')

        response = service.call

        expect(response).to match(faq.question)
        expect(response).to match(faq.answer)
      end
    end

  end

end
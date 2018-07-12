require_relative './../../spec_helper.rb'

describe FaqModule::CreateService do
  before do
    @company = create(:company)

    @question = FFaker::Lorem.sentence
    @answer = FFaker::Lorem.sentence
    @hashtags = "#{FFaker::Lorem.word}, #{FFaker::Lorem.word}"
  end

  describe '#call' do

    context 'With hashtags params' do
      before :each do
        service = FaqModule::CreateService.new({
          'question-original' => @question,
          'answer-original' => @answer,
          'hashtags-original' => @hashtags
        })

        @response = service.call
      end

      it 'should return the message of created with success' do
        #expect(@response).to match('created with success')
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

    context 'Without hashtags params' do
      it 'should return the message of hashtag is missing' do
        service = FaqModule::CreateService.new({
          'question-original' => @question, 
          'answer-original' => @answer 
        })
        
        response = service.call
        #expect(response).to match("Hashtag is missing")
        expect(response).to match("Hashtag obrigatória")
      end
    end

  end

end
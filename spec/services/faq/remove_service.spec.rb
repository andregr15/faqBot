require_relative './../../spec_helper.rb'

describe FaqModule::RemoveService do
  before do 
    @company = create(:company)
  end

  describe '#call' do
    context 'with a valid ID' do
      context 'should remove all data from the database' do
        before :each do 
          hashtag = create(:hashtag, company: @company)
          faq = create(:faq, company: @company)
          create(:category_faq, hashtag: hashtag, categorizable: faq)
          service = FaqModule::RemoveService.new({ 'id' => faq.id })
          @response = service.call
        end

        it 'should return the message of removed with success' do
          #expect(@response).to match('removed with success')
          expect(@response).to match('Removido com sucesso')
        end

        it 'should remove the Faq from the database' do
          expect(Faq.all.count).to eq(0)
        end

        it 'should remove the hashtag from the database' do
          expect(Hashtag.all.count).to eq(0)
        end
      end

      context 'should not remove the hashtag from the database' do
        before :each do
          @hashtag = create(:hashtag, company: @company)
          faq1 = create(:faq, company: @company)
          create(:category_faq, hashtag: @hashtag, categorizable: faq1)
          @service = FaqModule::RemoveService.new({ 'id' => faq1.id })
        end

        it 'should not remove the hashtag from the database when the hashtag is related to more than one faq' do
          faq2 = create(:faq, company: @company)
          create(:category_faq, hashtag: @hashtag, categorizable: faq2)

          response = @service.call

          expect(response).to eql('Removido com sucesso')
          expect(Hashtag.all.count).to eq(1)
          expect(Hashtag.first.name).to eql(@hashtag.name)
        end

        it 'should not remove the hashtag from the database when the hashtag is related to at least one faq and at least one link' do
          link = create(:link, company: @company)
          create(:category_link, hashtag: @hashtag, categorizable: link)

          response = @service.call
          
          expect(response).to eql('Removido com sucesso')
          expect(Hashtag.all.count).to eq(1)
          expect(Hashtag.first.name).to eql(@hashtag.name)
        end
      end
    end

    context 'with an invalid ID' do
      it 'should return the message of invalid id' do
        service = FaqModule::RemoveService.new({ 'id' => rand(1..9999) })
        response = service.call
        
        #expect(response).to match('invalid ID')
        expect(response).to match('Questão inválida, verifique o ID')
      end
    end

  end

end
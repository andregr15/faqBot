require_relative './../../spec_helper.rb'

describe FaqModule::RemoveService do
  before do 
    @company = create(:company)
  end

  describe '#call' do
    context 'with a valid ID' do
      before :each do 
        faq = create(:faq, company: @company)
        service = FaqModule::RemoveService.new({ id: faq.id })
        @response = service.call
      end

      it 'should return the message of removed with success' do
        #expect(@response).to match('removed with success')
        expect(@response).to match('Removido com sucesso')
      end

      it 'should remove the Faq' do
        expect(Faq.all.count).to eq(0)
      end
    end

    context 'with an invalid ID' do
      it 'should return the message of invalid id' do
        service = FaqModule::RemoveService.new({ id: rand(1..9999) })
        response = service.call
        
        #expect(response).to match('invalid id')
        expect(response).to match('Questão inválida, verifique o id')
      end
    end

  end

end
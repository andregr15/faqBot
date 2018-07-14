require_relative './../../spec_helper.rb'

describe LinkModule::RemoveService do
  before do
    @company = create(:company)
  end
  describe '#call' do
    context 'With a valid ID' do
      before :each do
        @hashtag = create(:hashtag, company: @company)
        link = create(:link, company: @company)
        create(:category_link, hashtag: @hashtag, categorizable: link)

        service = LinkModule::RemoveService.new({ 'id' => link.id })
        @response = service.call
      end

      it 'should return the message of remove with success' do
        expect(@response).to eql('Removido com sucesso')
      end

      it 'should have removed the link from database' do
        expect(Link.all.count).to eq(0)
      end

      it 'should have removed the hashtag from database' do
        expect(Hashtag.all.count).to eq(0)
      end

    end

    context 'With a invalid ID' do
      it 'should return the message of invalid ID' do
        service = LinkModule::RemoveService.new({ 'id' => rand(0..9999) })
        response = service.call
        expect(response).to eql('Link inválido, verifique o ID')
      end
    end
  end
end
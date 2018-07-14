require_relative './../../spec_helper.rb'

describe LinkModule::ListService do
  before do
    @company = create(:company)
  end

  describe '#call' do
    context 'Using list command' do
      before :each do
        @service = LinkModule::ListService.new({}, 'list')
      end

      it 'should return message of nothing found' do
        expect(@service.call).to eql('Nada encontrado')
      end

      it 'should return the links' do
        link1 = create(:link, company: @company)
        link2 = create(:link, company: @company)

        response = @service.call
        
        expect(link1.name).to match(Link.first.name)
        expect(link1.description).to match(Link.first.name)
        expect(link1.url).to match(Link.first.name)

        expect(link2.name).to match(Link.last.name)
        expect(link2.description).to match(Link.last.description)
        exepct(link2.url).to match(Link.last.url)
      end
    end

    context 'Using search command' do
      it 'should return the message of nothing found when an empty query is used' do
        service = LinkModule::ListService.new({ 'query'=> '' }, 'search')

        response = service.call
        expect(response).to eql('Nada encontrado')
      end

      it 'should return the links when used a valid query' do
        link = create(:link, company: @company)

        service = LinkModule::ListService.new({
          'query' => link.description.split('').sample
        }, 'search')

        response = service.call
        
        expect(link.name).to match(response)
        expect(link.description).to match(response)
        expect(link.url).to match(response)
      end
    end

    context 'Using search_by_hashtag command' do
      it 'should return the message of nothing found when an empty query is used' do
        service = LinkModule::ListService.new({ 'query' => ' '}, 'search_by_hashtag')
        
        response = service.call
        expect(response).to eql('Nada encontrado')
      end

      it 'should return the links when used a valid query' do
        hashtag = create(:hashtag)
        link = create(:link, company: @company)
        link.hashtags << hashtag

        service = LinkModule::ListService.new({ 'query' => 'hashtag' }, 'search_by_hashtag')

        response = service.call
        
        expect(link.name).to match(response)
        expect(link.description).to match(response)
        expect(link.url).to match(response)
        expect(hashtag.name).to match(response)
      end
    end
  end
end
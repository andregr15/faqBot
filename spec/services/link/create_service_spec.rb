require_relative './../../spec_helper.rb'

describe LinkModule::CreateService do
  before do
    @company = create(:company)
    @name = FFaker::Lorem.word
    @description = FFaker::Lorem.sentence
    @url = FFaker::Internet.http_url
    @hashtags = "#{FFaker::Lorem.word}, #{FFaker::Lorem.word}"
  end

  describe '#call' do
    context 'With hashtags parameter' do
      before :each do
        service = LinkModule.CreateService.new({
          'name' => @name,
          'description' => @description,
          'url' => @url,
          'hashtags' => @hashtags
        })
        @response = service.call
      end

      it 'should return message of create with success' do
        expect(@response).to eql('Criado com sucesso')
      end

      it 'should have created the link in the database' do
        expect(Link.last.name).to eql(@name)
        expect(Link.last.description).to eql(@description)
        expect(Link.last.url).to eql(@url)
      end

      it 'should have created the hashtags in the database' do
        expect(Hashtag.first.name).to eql(@hashtags.split(/[\s,]+/).first)
        expect(Hashtag.last.name).to eql(@hashtags.split(/[\s,]+/).last)
      end
    end

    context 'Without hashtags parameter' do
      service = LinkModule.CreateService.new({
        'name' => @name,
        'description' => @description,
        'url' => @url
      })
      response = service.call
      expect(response).to eql('Hashtag obrigatória')
    end
  end
end
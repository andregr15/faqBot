module LinkModule
  class CreateService
    def initialize(params)
      @company = Company.last
      @name = params['name']
      @description = params['description']
      @url = params['url']
      @hashtags = params['hashtags']
    end

    def call
      return 'Hashtag obrigatória' if @hashtags.nil?

      Link.transaction do
        link = Link.create(name: @name, description: @description, url: @url, company: @company)
        @hashtags.split(/[\s,]+/).each do |hashtag|
          link.hashtags << Hashtag.create(name: hashtag)
        end
        'Criado com sucesso'
      end
    end
  end
end
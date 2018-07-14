module LinkModule
  class RemoveService
    def initialize(params)
      @company = Company.last
      @id = params['id']
    end

    def call
      link = @company.links.where(id: @id).last
      return 'Link inválido, verifique o ID' if link.nil?

      Link.transaction do
        # removendo as hashtags
        link.hashtags.each do |hashtag|
          if hashtag.links.count <= 1 && hashtag.faqs.count == 0
            hashtag.delete
          end
        end
        link.delete
        'Removido com sucesso'
      end
    end
  end
end
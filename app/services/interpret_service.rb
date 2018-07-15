class InterpretService
  def self.call action, params
    case action
      when 'list', 'search', 'search_by_hashtag'
        FaqModule::ListService.new(params, action).call
      when 'create'
        FaqModule::CreateService.new(params).call
      when 'remove'
        FaqModule::RemoveService.new(params).call
      
      when 'list_links', 'search_links', 'search_by_hashtag_links'
        LinkModule::ListService.new(params, action).call
      when 'create_links'
        LinkModule::CreateService.new(params).call
      when 'remove_links'
        LinkModule::RemoveService.new(params).call
      
      when 'help'
        HelpService.call
      when 'quote'
        QuoteService.call
      else
        'Não compreendi o seu desejo'
    end
  end
end
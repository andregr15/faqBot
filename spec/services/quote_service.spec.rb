require_relative '../spec_helper.rb'

describe QuoteService do
  it 'should return a quote' do
    quote = QuoteService::call
    expect(quote).to be_kind_of(String)
    expect(quote).to match('Autor')
  end
end
require_relative '../spec_helper.rb'

describe QuoteService do
  it 'should return a quote' do
    quote = QuoteService::quote
    expect(quote).to be_kind_of(String)
  end
end
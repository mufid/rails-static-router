require 'rails_helper'

RSpec.describe 'Integration Test', type: :request do
  it 'can respond to static routes' do
    get '/lucu.txt'
    expect(response).to have_http_status(:ok)
    expect(response.body.strip).to eq('hi!')
  end

  it 'cant response via non-defined static routes' do
    expect { get '/mantap.txt' }.to raise_exception
  end
end

require 'rails_helper'

RSpec.describe 'Integration Test', type: :request do
  it 'can respond to static routes' do
    get '/lucu.txt'
    expect(response).to have_http_status(:ok)
    expect(response.body.strip).to eq('hi!')
    expect(response.headers['Cache-Control']).to eq('my-cache-control')
  end

  it 'cant response via non-defined static routes' do
    expect { get '/mantap.txt' }.to raise_exception
  end

  it 'works with normal controller' do
    get '/aroute'
    expect(response).to have_http_status(:ok)
    expect(response.body.strip).to eq('hi2!')
  end
end

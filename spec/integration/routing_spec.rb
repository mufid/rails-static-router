require 'rails_helper'

RSpec.describe 'Integration Test', type: :request do
  it "can respond to static routes" do
    get "/lucu.txt"
    expect(response.body.strip).to eq('hi!')
  end
end

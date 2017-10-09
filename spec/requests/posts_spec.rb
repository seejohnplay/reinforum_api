require 'rails_helper'

RSpec.describe 'Posts API', type: :request do
  let!(:posts) { create_list(:post, 10) }
  let(:post_id) { posts.first.id }

  describe 'GET /posts' do
    before { get '/posts' }

    it 'returns posts' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /:category/posts' do
    let(:category) { posts.first.category}

    before { get "/#{category.name}/posts" }

    it 'returns posts' do
      expect(json).not_to be_empty
      post_ids = json.map { |post| post['id'] }
      expect(post_ids).to include(posts.first.id)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end

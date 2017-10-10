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
    let(:category) { posts.first.category }

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

  describe 'GET /posts/:id' do
    before { get "/posts/#{post_id}" }

    context 'when the record exists' do
      it 'returns the post' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(post_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:post_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Post/)
      end
    end
  end

  describe 'POST /posts' do
    let(:category) { create(:category) }
    let(:valid_attributes) do
      {
        title: 'Learn Elm',
        body: 'Here are some of my favorite Elm resources!',
        author: 'Evan Czaplicki',
        category_id: category.id
      }
    end

    context 'when the request is valid' do
      before { post '/posts', params: valid_attributes }

      it 'creates a todo' do
        expect(json['title']).to eq('Learn Elm')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/posts', params: { title: 'Foobar' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Category must exist/)
      end
    end
  end

  describe 'POST /posts/:id' do
    let(:first_post) { posts.first }
    let!(:original_vote_score) { first_post.vote_score }

    context 'when the option is upvote' do
      before { post "/posts/#{first_post.id}", params: { option: 'upvote'} }

      it 'increase the vote count by 1' do
        first_post.reload

        expect(first_post.vote_score).to eq(original_vote_score + 1)
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the option is downvote' do
      before { post "/posts/#{first_post.id}", params: { option: 'downvote'} }

      it 'decrease the vote count by 1' do
        first_post.reload

        expect(first_post.vote_score).to eq(original_vote_score - 1)
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the option is neither upvote or downvote' do
      before { post "/posts/#{first_post.id}", params: { option: 'invalidvote'} }

      it 'vote count is unchanged' do
        first_post.reload

        expect(first_post.vote_score).to eq(original_vote_score)
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

  end

  describe 'PUT /posts/:id' do
    let(:valid_attributes) { { title: 'Learn Elm 2.0' } }

    context 'when the record exists' do
      before { put "/posts/#{post_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /posts/:id' do
    before { delete "/posts/#{post_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
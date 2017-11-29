require 'rails_helper'

RSpec.describe 'Comments API', type: :request do
  let(:comments) { create_list(:comment, 10) }
  let(:comment_id) { comments.first.id }

  describe 'GET /comments/:id' do
    before { get "/comments/#{comment_id}" }

    context 'when the record exists' do
      it 'returns the comment' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(comment_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:comment_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Comment/)
      end
    end
  end

   describe 'POST /comments' do
    let(:existing_post) { create(:post) }
    let(:valid_attributes) do
      {
        body: 'Valuable content - I learned a lot!',
        author: 'Evan Czaplicki',
        post_id: existing_post.id
      }
    end

    context 'when the request is valid' do
      before { post '/comments', params: valid_attributes }

      it 'creates a comment' do
        expect(json['body']).to eq('Valuable content - I learned a lot!')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/comments', params: { body: 'Foobar' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Post must exist/)
      end
    end
  end

   describe 'POST /comments/:id' do
    let(:first_comment) { comments.first }
    let!(:original_vote_score) { first_comment.vote_score }

    context 'when the option is upvote' do
      before { post "/comments/#{first_comment.id}", params: { option: 'upvote'} }

      it 'increase the vote count by 1' do
        first_comment.reload

        expect(first_comment.vote_score).to eq(original_vote_score + 1)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the option is downvote' do
      before { post "/comments/#{first_comment.id}", params: { option: 'downvote'} }

      it 'decrease the vote count by 1' do
        first_comment.reload

        expect(first_comment.vote_score).to eq(original_vote_score - 1)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the option is neither upvote or downvote' do
      before { post "/comments/#{first_comment.id}", params: { option: 'invalidvote'} }

      it 'vote count is unchanged' do
        first_comment.reload

        expect(first_comment.vote_score).to eq(original_vote_score)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

   describe 'PUT /comments/:id' do
    let(:valid_attributes) { { body: 'Totally agree!' } }

    context 'when the comment exists' do
      before { put "/comments/#{comment_id}", params: valid_attributes }

      it 'updates the record' do
        expect(json['body']).to eq('Totally agree!')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'DELETE /comments/:id' do
    before { delete "/comments/#{comment_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
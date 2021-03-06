require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should belong_to(:category) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:author) }
end
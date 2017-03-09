require 'rails_helper'

RSpec.describe Piece, type: :model do
  context "associations" do
    it { should belong_to(:game) }
    it { should have_many(:moves) }
  end
end

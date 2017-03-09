require 'rails_helper'

RSpec.describe Move, type: :model do
  context "associations" do
    it { should belong_to(:game) }
    it { should belong_to(:piece) }
  end
end

require 'rails_helper'

RSpec.describe Participation, type: :model do
  context "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:game) }
  end
end

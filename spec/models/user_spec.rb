require 'rails_helper'

RSpec.describe User, type: :model do
  context "associations" do
    it { should have_many(:participations) }
    it { should have_many(:games).through(:participations) }
  end

  context "validations" do
    it { should validate_presence_of(:screen_name) }
    it { should validate_length_of(:screen_name).is_at_least(3) }
    it { should validate_length_of(:screen_name).is_at_most(16) }
    it { should allow_value('ABCDefg123').for(:screen_name) }
    it { should_not allow_value('ABCDefg123!@#').for(:screen_name) }
  end
end

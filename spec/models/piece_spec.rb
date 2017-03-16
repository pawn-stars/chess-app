require 'rails_helper'

RSpec.describe Piece, type: :model do
  context "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:game) }
    it { should have_many(:moves) }
  end
  
  describe "#move_to!" do
    before(:all) do
      User.delete_all
      Game.delete_all

      @user = User.create(
        email: 'foobar@foobar.com',
        screen_name: 'foobar',
        password: 'foobar',
        password_confirmation: 'foobar'
      )
      
      @game = @user.games.create(white_player_id: @user);
    end
    
    before(:each) do
      Piece.delete_all
    end
    
    it "should update row and col attributes" do
      piece = @game.pieces.create(
        row: 0, col: 0, is_captured: false, user: @user
      )
      piece.move_to!(7, 7)
      
      expect(piece.row).to eq(7)
      expect(piece.col).to eq(7)
    end
    
    it "should raise an error if the arguments are out of bounds" do
      piece = @game.pieces.create(
        row: 0, col: 0, is_captured: false, user: @user
      )
      
      expect { piece.move_to!(8, 0) }.to raise_error(RuntimeError)
    end
  end
end

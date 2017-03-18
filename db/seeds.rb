User.delete_all
Participation.delete_all
Game.delete_all
Piece.delete_all
Move.delete_all


2.times do |n|
  User.create(
    email: "foobar-#{n}@foobar.com",
    password: 'foobar',
    password_confirmation: 'foobar',
    screen_name: "foobar#{n}"
  )
end

# Proper game creation and joining has not been implemented yet,
# the code below manually creates the records needed to test the front end

user1 = User.first
user2 = User.last

game = user1.games.create(white_player_id: user1, black_player_id: user2)
user2.games << game

user1.pieces.create(
  type: 'Rook',   row: 0, col: 0, is_black: false, game_id: game.id)
user1.pieces.create(
  type: 'Knight', row: 0, col: 1, is_black: false, game_id: game.id)
user1.pieces.create(
  type: 'Bishop', row: 0, col: 2, is_black: false, game_id: game.id)
user1.pieces.create(
  type: 'Queen',  row: 0, col: 3, is_black: false, game_id: game.id)
user1.pieces.create(
  type: 'King',   row: 0, col: 4, is_black: false, game_id: game.id)
user1.pieces.create(
  type: 'Bishop', row: 0, col: 5, is_black: false, game_id: game.id)
user1.pieces.create(
  type: 'Knight', row: 0, col: 6, is_black: false, game_id: game.id)
user1.pieces.create(
  type: 'Rook',   row: 0, col: 7, is_black: false, game_id: game.id)
(0..7).each do |i|
  user1.pieces.create(
    type: 'Pawn', row: 1, col: i, is_black: false, game_id: game.id)
end

user2.pieces.create(
  type: 'Rook',   row: 7, col: 0, is_black: true, game_id: game.id)
user2.pieces.create(
  type: 'Knight', row: 7, col: 1, is_black: true, game_id: game.id)
user2.pieces.create(
  type: 'Bishop', row: 7, col: 2, is_black: true, game_id: game.id)
user2.pieces.create(
  type: 'Queen',  row: 7, col: 3, is_black: true, game_id: game.id)
user2.pieces.create(
  type: 'King',   row: 7, col: 4, is_black: true, game_id: game.id)
user2.pieces.create(
  type: 'Bishop', row: 7, col: 5, is_black: true, game_id: game.id)
user2.pieces.create(
  type: 'Knight', row: 7, col: 6, is_black: true, game_id: game.id)
user2.pieces.create(
  type: 'Rook',   row: 7, col: 7, is_black: true, game_id: game.id)
(0..7).each do |i|
  user2.pieces.create(
    type: 'Pawn', row: 6, col: i, is_black: true, game_id: game.id)
end

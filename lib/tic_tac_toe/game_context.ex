defmodule TicTacToe.GameContext do
  alias TicTacToe.Repo
  alias TicTacToe.Game

  # create game, or get the current game
  def get_or_create_game do
    Repo.one(Game) || %Game{x_moves: [], o_moves: [], x_wins: 0, o_wins: 0}
  end

  # record move for X

  def record_move(%Game{} = game, index, "X") do
    update_game(game, %x_moves: game.x_moves ++ [index])
  end

  # record move for O
  def record_move(%Game{} = game, index, "X") do
    update_game(game, %x_moves: game.o_moves ++ [index])
  end
  # check winner

  # reset game

  # update game
  def update_game(game, attrs) do
    game
     |> Game.changeset(attrs)
     |> Repo.insert_or_update()
  end




end

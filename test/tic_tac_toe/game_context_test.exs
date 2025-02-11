defmodule TicTacToe.GameContextTest do
  # testing utilities
  use TicTacToe.DataCase
  # convenience aliases
  alias TicTacToe.GameContext
  alias TicTacToe.Game
  alias TicTacToe.Repo
#
  test "get_or_create_game returns an existing game if present" do
    # Insert a game into the database with some values
    game = %Game{x_moves: [1], o_moves: [2], x_wins: 1, o_wins: 0} |> Repo.insert!()
    # Fetch the game, when get or create game is called, it should return ^game^
    assert GameContext.get_or_create_game() == game
  end

  test "get_or_create_game returns a new struct if no game exists" do
    # Ensure database is empty
    Repo.delete_all(Game)
    # Fetch the game
    game = GameContext.get_or_create_game()
    # all cols in the db should be empty when a new game is created
    assert game.x_moves == []
    assert game.o_moves == []
    assert game.x_wins == 0
    assert game.o_wins == 0
    assert game.__struct__ == Game
  end
end

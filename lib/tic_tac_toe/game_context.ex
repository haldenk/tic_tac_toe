defmodule TicTacToe.GameContext do
  alias TicTacToe.Repo
  alias TicTacToe.Game
  # create game, or get the current game
  def get_or_create_game do
    Repo.one(Game) || %Game{x_moves: [], o_moves: [], x_wins: 0, o_wins: 0}
  end
  # record move for X
  def record_move(%Game{} = game, index, "X") do
    update_game(game, %{x_moves: game.x_moves ++ [index]})
  end
  # record move for O
  def record_move(%Game{} = game, index, "O") do
    update_game(game, %{o_moves: game.o_moves ++ [index]})
  end
  # update game
  def update_game(game, attrs) do
    game
     |> Game.changeset(attrs)
     |> Repo.insert_or_update()
  end

  # all winning combinations of indexes
  @winning_combinations [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
  def check_winner(game) do
    cond do
      # x winner (reset board, and add one to x wins)
      Enum.any?(@winning_combinations, fn combo -> Enum.all?(combo, &(&1 in game.x_moves)) end) ->
        {:winner, "X", update_game(game, %{x_moves: [], o_moves: [], x_wins: game.x_wins + 1})}
      # O winner (reset board, and add one to o wins)
      Enum.any?(@winning_combinations, fn combo -> Enum.all?(combo, &(&1 in game.o_moves)) end) ->
        {:winner, "O", update_game(game, %{x_moves: [], o_moves: [], o_wins: game.o_wins + 1})}
      # Draw (leave wins and clear board")
      length(game.x_moves ++ game.o_moves) == 9 ->
        {:draw, update_game(game, %{x_moves: [], o_moves: []})}
      true -> :no_winner
    end
  end

  # reset game
  def reset_game(game) do
    update_game(game, %{x_moves: [], o_moves: [], x_wins: 0, o_wins: 0})
  end

end

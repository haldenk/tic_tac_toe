defmodule TicTacToeWeb.TicTacToeLive do
  use TicTacToeWeb, :live_view
  alias TicTacToe.Repo
  alias TicTacToe.Game

  def mount(_params, _session, socket) do
    game = TicTacToe.Repo.one(TicTacToe.Game) || %TicTacToe.Game{x_moves: [], o_moves: [], x_wins: 0, o_wins: 0}
    {:ok, assign(socket, board: List.duplicate("", 9), turn: "X", x_wins: game.x_wins, o_wins: game.o_wins)}
  end

  # handle event for moving, passes the index of the tile clicked as params
  def handle_event("move", %{"index" => index}, socket) do
    IO.inspect(index, label: "index of button clicked")
    # converts the index of the tile to an integer
    index = String.to_integer(index)
    #the board, from assign
    board = socket.assigns.board
    # the turn, from assign
    turn = socket.assigns.turn
    # if the selected tile is an empty string
    if Enum.at(board, index) == "" do
      # updates the board by placing an x or o in the selected index
      updated_board = List.replace_at(board, index, turn)
      # switch turns
      next_turn = if turn == "X", do: "O", else: "X"
      # fetch the latest game
      game = TicTacToe.Repo.one(TicTacToe.Game) || %TicTacToe.Game{x_moves: [], o_moves: [], x_wins: 0, o_wins: 0}
      IO.inspect(game, label: "game object")
      # updated game, if turn is X, add the index of the move to the x_moves field, if turn is O, add index to o_moves field
      updated_game =
        case turn do
          "X" -> %{x_moves: game.x_moves ++ [index], o_moves: game.o_moves, x_wins: game.x_wins, o_wins: game.o_wins}
          "O" -> %{o_moves: game.o_moves ++ [index], x_moves: game.x_moves, x_wins: game.x_wins, o_wins: game.o_wins}
        end
      # changeset to update the DB with the players move
      changeset = TicTacToe.Game.changeset(game, updated_game)
      # push changes to the DB
      TicTacToe.Repo.insert_or_update(changeset)
      # ********* need to call the check winner function here
      {:noreply, assign(socket, board: updated_board, turn: next_turn)}
    else
      {:noreply, socket}
    end
  end

  def check_winner() do
    winning_combinations = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
    game = TicTacToe.Repo.one(TicTacToe.Game) || %TicTacToe.Game{x_moves: [], o_moves: [], x_wins: 0, o_wins: 0}
    winner =
      cond do
        Enum.any?(winning_combinations, fn combo -> Enum.all?(combo, &(&1 in game.x_moves)) end) -> "X"
        Enum.any?(winning_combinations, fn combo -> Enum.all?(combo, &(&1 in game.o_moves)) end) -> "O"
        true -> nil
      end
      case winner do
        "X" ->
          updated_game = %{x_moves: game.x_moves, o_moves: game.o_moves, x_wins: game.x_wins ++ 1, o_wins: game.o_wins}
          changeset = TicTacToe.Game.changeset(game, updated_game)
          TicTacToe.Repo.insert_or_update(changeset)
        "O" ->
          updated_game = %{x_moves: game.x_moves, o_moves: game.o_moves, x_wins: game.x_wins, o_wins: game.o_wins ++ 1}
          changeset = TicTacToe.Game.changeset(game, updated_game)
          TicTacToe.Repo.insert_or_update(changeset)
      end
  end



  # need check winner func, wich will check both players coordinates against the winning combinations. Called in the move handle event
    # If winner, increment o_wins, or x_wins. Call clear board function. Clear x_moves and o_moves array in DB
    # if no winner, return

  # need clear board func, to be called when someone wins

  # need reset score function

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center">
      <h2 class="text-3xl text-center mb-3">Welcome to tic tac toe!</h2>
      <h3 class="text-xl">Current turn: <%= @turn %> </h3>
      <div class="grid grid-cols-3 mt-5">
        <%= for {value, index} <- Enum.with_index(@board) do %>
        <button phx-click="move" phx-value-index={index} class="border border-black h-20 w-20">
          <%= value %>
        </button>
        <% end %>
        <p> x wins: <%= @x_wins %></p>
        <p> y wins: <%= @o_wins %></p>
      </div>
    </div>
    """
  end
end

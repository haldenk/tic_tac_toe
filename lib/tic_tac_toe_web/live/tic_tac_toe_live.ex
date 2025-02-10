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
    # the board, from assign
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
      # after a move is made, check if there is a winner, draw, or if the game should keep going
      case check_winner(updated_game) do
        # if winner, reset board and update winner list
        {:winner, winner, updated_game} ->
          {:noreply, assign(socket, board: List.duplicate("", 9), turn: "X", x_wins: updated_game.x_wins, o_wins: updated_game.o_wins)}
        # if draw, keep win count, and reset board
        {:draw, updated_game} ->
          {:noreply, assign(socket, board: List.duplicate("", 9), turn: "X", x_wins: updated_game.x_wins, o_wins: updated_game.o_wins)}
        # if no winner, and no draw, continue playing
        :no_winner ->
          {:noreply, assign(socket, board: updated_board, turn: next_turn)}
      end
    else
      {:noreply, socket}
    end
  end

  def check_winner(updated_game) do
    # all winning combinations
    winning_combinations = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
    # fetch the latest game state from DB
    game = TicTacToe.Repo.one(TicTacToe.Game) || %TicTacToe.Game{x_moves: [], o_moves: [], x_wins: 0, o_wins: 0}
    # check stored moves against winning combinations to see if there is a winner
    winner =
      cond do
        # check against x moves
        Enum.any?(winning_combinations, fn combo -> Enum.all?(combo, &(&1 in game.x_moves)) end) -> "X"
        # check against o moves
        Enum.any?(winning_combinations, fn combo -> Enum.all?(combo, &(&1 in game.o_moves)) end) -> "O"
        true -> nil
      end
      # handle result based on winner
      case winner do
        # if x wins, reset the board and update x_wins
        "X" ->
          updated_game = %{x_moves: [], o_moves: [], x_wins: game.x_wins + 1, o_wins: game.o_wins}
          changeset = TicTacToe.Game.changeset(game, updated_game)
          TicTacToe.Repo.insert_or_update(changeset)
          {:winner, "X", updated_game}
        # if o wins, reset board, and update o_wins
        "O" ->
          updated_game = %{x_moves: [], o_moves: [], x_wins: game.x_wins, o_wins: game.o_wins + 1}
          changeset = TicTacToe.Game.changeset(game, updated_game)
          TicTacToe.Repo.insert_or_update(changeset)
          {:winner, "O", updated_game}
        # if no winner
        nil ->
          # get number of moves
          all_moves = game.x_moves ++ game.o_moves
          # if the number of moves == the total number of tiles, reset the board
          if length(all_moves) == 9 do
            updated_game = %{x_moves: [], o_moves: [], x_wins: game.x_wins, o_wins: game.o_wins}
            changeset = TicTacToe.Game.changeset(game, updated_game)
            TicTacToe.Repo.insert_or_update(changeset)
            {:draw, updated_game}
          else
            # continue the game if there is no winner and not all of the tiles are filled
            :no_winner
          end
      end
  end

  def handle_event("reset", _params, socket) do
    # fetch latest game state from DB
    game = TicTacToe.Repo.one(TicTacToe.Game) || %TicTacToe.Game{x_moves: [], o_moves: [], x_wins: 0, o_wins: 0}
    # reset all DB tables to create updated game
    updated_game = %{x_moves: [], o_moves: [], x_wins: 0, o_wins: 0}
    # create changeset and update the DB
    changeset = TicTacToe.Game.changeset(game, updated_game)
    TicTacToe.Repo.insert_or_update(changeset)
    # update assigns with new game
    {:noreply, assign(socket, board: List.duplicate("", 9), turn: "X", x_wins: 0, o_wins: 0)}
  end
  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center">
      <h2 class="text-3xl text-center mb-3">Welcome to tic tac toe!</h2>
      <h3 class="text-xl">Current turn: <%= @turn %> </h3>
      <div class="flex mt-2 space-x-2">
        <p class="border border-gray-200 rounded-md p-2 "> X wins: <%= @x_wins %></p>
        <p class="border border-gray-200 rounded-md p-2"> O wins: <%= @o_wins %></p>
      </div>
      <div class="grid grid-cols-3 mt-5">
        <%= for {value, index} <- Enum.with_index(@board) do %>
        <button phx-click="move" phx-value-index={index} class="border border-black h-20 w-20 hover:bg-gray-200">
          <%= value %>
        </button>
        <% end %>
      </div>

      <button phx-click="reset" class="mt-2 border border-gray-200 rounded-md hover:bg-red-100 p-2" > Reset Game </button>
    </div>
    """
  end
end

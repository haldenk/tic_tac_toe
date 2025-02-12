defmodule TicTacToeWeb.TicTacToeLive do
  use TicTacToeWeb, :live_view
  alias TicTacToe.GameContext

  def mount(_params, _session, socket) do
    game = GameContext.get_or_create_game()
    {:ok, assign(socket, board: List.duplicate("", 9), turn: "X", x_wins: game.x_wins, o_wins: game.o_wins)}
  end

  # handle event for moving, passes the index of the tile clicked as params
  def handle_event("move", %{"index" => index}, socket) do
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
      game = GameContext.get_or_create_game()
      # update game
      case GameContext.record_move(game, index, turn) do
        # when the move is recorded, it comes back as a tuple
        {:ok, updated_game} ->
          # check winner, with the updated game
            case GameContext.check_winner(updated_game) do
              # if winner, update score, and reset board
              {:winner, winner, {:ok, updated_game}} ->
                {:noreply, assign(socket, board: List.duplicate("", 9), turn: "X", x_wins: updated_game.x_wins, o_wins: updated_game.o_wins)}
              # if draw, reset board
              {:draw, {:ok, updated_game}} ->
                {:noreply, assign(socket, board: List.duplicate("", 9), turn: "X", x_wins: updated_game.x_wins, o_wins: updated_game.o_wins)}
              # if no winner, update board and continue game
              :no_winner ->
                {:noreply, assign(socket, board: updated_board, turn: next_turn)}
            end
      end
    else
      {:noreply, socket}
    end
  end
  # reset the game
  def handle_event("reset", _params, socket) do
    # get current game state
    game = GameContext.get_or_create_game()
    # pass current game into reset game
    GameContext.reset_game(game)
    # reset the socket
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

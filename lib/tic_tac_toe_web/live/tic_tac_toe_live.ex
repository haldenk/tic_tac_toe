defmodule TicTacToeWeb.TicTacToeLive do
  use TicTacToeWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, board: List.duplicate("", 9), turn: "X")}
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
      updated_board = List.replace_at(board, index, turn)
      next_turn = if turn == "X", do: "0", else: "X"
      {:noreply, assign(socket, board: updated_board, turn: next_turn)}
    else
      {:noreply, socket}
    end
  end

  # need check winner func, wich will check both players coordinates against the winning combinations. Called in the move handle event

# winning combinations:
# horizintal:
# (1, 2, 3)
# (4, 5, 6)
# (7, 8, 9)
# vertical:
# (1, 4, 7)
# (2, 5, 8)
# (3, 6, 9)
# diagonal:
# (1, 5, 9)
# (3, 5, 7)

  # need clear board func, to be called when someone wins


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
      </div>
    </div>
    """
  end
end

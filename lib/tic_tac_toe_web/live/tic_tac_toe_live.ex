defmodule TicTacToeWeb.TicTacToeLive do
  use TicTacToeWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, board: List.duplicate("", 9), turn: "X")}
  end

  def handle_event("move", %{"index" => index}, socket) do
    IO.inspect(index, label: "index of button clicked")
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center">
      <h2 class="text-3xl text-center">Welcome to tic tac toe!</h2>
      <div class="grid grid-cols-3 mt-5">
        <%= for index <- 0..8 do %>
        <button phx-click="move" phx-value-index={index} class="border border-black h-20 w-20"><%=index%></button>
        <% end %>
      </div>
    </div>
    """
  end
end

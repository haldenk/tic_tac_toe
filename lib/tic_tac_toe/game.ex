defmodule TicTacToe.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :o_moves, {:array, :integer}
    field :o_wins, :integer
    field :x_moves, {:array, :integer}
    field :x_wins, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:x_moves, :o_moves, :x_wins, :o_wins])
    |> validate_required([:x_moves, :o_moves, :x_wins, :o_wins])
  end
end

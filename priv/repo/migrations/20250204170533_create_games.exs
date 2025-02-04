defmodule TicTacToe.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :x_moves, {:array, :integer}
      add :o_moves, {:array, :integer}
      add :turn, :string
      add :winner, :string

      timestamps(type: :utc_datetime)
    end
  end
end

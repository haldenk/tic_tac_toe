defmodule TicTacToe.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :x_moves, {:array, :integer}
      add :o_moves, {:array, :integer}
      add :x_wins, :integer
      add :o_wins, :integer

      timestamps(type: :utc_datetime)
    end
  end
end

defmodule SeatSaver.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :post_no, :integer
      add :occupied, :boolean, default: false

      timestamps
    end

  end
end

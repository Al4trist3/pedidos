defmodule Pedidos.Repo.Migrations.CreateCarritos do
  use Ecto.Migration

  def change do
    create table(:carritos) do
      add :user_uuid, :uuid

      timestamps(type: :utc_datetime)
    end

    create unique_index(:carritos, [:user_uuid])
  end
end

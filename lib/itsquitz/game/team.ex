defmodule Itsquitz.Game.Team do
  use Ash.Resource,
    domain: Itsquitz.Game,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "teams"
    repo Itsquitz.Repo
  end

  actions do
    defaults [:create, :read, :update, :destroy]
    default_accept [:name, :code]
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :string, allow_nil?: false
    attribute :code, :string, allow_nil?: false, default: "69420"

    timestamps()
  end

  relationships do
    has_many :players, Itsquitz.Game.Player
    has_many :results, Itsquitz.Game.Result
    has_many :plays, Itsquitz.Game.Play
  end
end

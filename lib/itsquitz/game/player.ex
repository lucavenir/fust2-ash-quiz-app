defmodule Itsquitz.Game.Player do
  use Ash.Resource,
    domain: Itsquitz.Game,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "players"
    repo Itsquitz.Repo
  end

  actions do
    defaults [:create, :read, :update, :destroy]
    default_accept [:username, :code]
  end

  attributes do
    uuid_primary_key :id

    attribute :username, :string, allow_nil?: false
    attribute :code, :string, allow_nil?: false, default: "42069"

    timestamps()
  end

  relationships do
    belongs_to :team, Itsquitz.Game.Team
    has_many :results, Itsquitz.Game.Results
  end
end

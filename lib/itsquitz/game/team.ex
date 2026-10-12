defmodule Itsquitz.Game.Team do
  use Ash.Resource,
    domain: Itsquitz.Game,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "teams"
    repo Itsquitz.Repo
  end

  actions do
    defaults [:read, :update, :destroy]
    default_accept [:name]

    create :create do
      accept [:name]
    end
  end

  validations do
    validate string_length(:name, min: 3, max: 30),
      message: "must be between 3 and 30 characters"
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :string, allow_nil?: false

    timestamps()
  end

  relationships do
    has_many :players, Itsquitz.Game.Player
    has_many :results, Itsquitz.Game.Result
    has_many :plays, Itsquitz.Game.Play
  end
end

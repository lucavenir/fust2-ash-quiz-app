defmodule Itsquitz.Game.Player do
  use Ash.Resource,
    domain: Itsquitz.Game,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "players"
    repo Itsquitz.Repo
  end

  actions do
    defaults [:read, :update, :destroy]
    default_accept [:username]

    create :join_lobby do
      accept [:username]
      argument :code, :string, allow_nil?: false

      validate Itsquitz.Game.Validations.PlayerCodeValidation do
        before_action? true
        only_when_valid? true
      end
    end
  end

  validations do
    validate string_length(:username, min: 3, max: 30),
      message: "must be between 3 and 30 characters"
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :username, :string, allow_nil?: false

    timestamps()
  end

  relationships do
    belongs_to :team, Itsquitz.Game.Team

    has_many :results, Itsquitz.Game.Result
  end
end

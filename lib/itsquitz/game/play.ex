defmodule Itsquitz.Game.Play do
  use Ash.Resource,
    domain: Itsquitz.Game,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "games"
    repo Itsquitz.Repo
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :code, :string, allow_nil?: false

    attribute :status, :atom do
      constraints one_of: [:lobby, :in_progress, :completed, :abandoned]
      default :lobby
    end

    timestamps()
  end

  relationships do
    belongs_to :team, Itsquitz.Game.Team, allow_nil?: false
    has_many :player_answers, Itsquitz.Game.PlayerAnswer
    has_many :results, Itsquitz.Data.Result
  end
end

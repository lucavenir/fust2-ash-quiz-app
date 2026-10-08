defmodule Itsquitz.Game.Results do
  use Ash.Resource,
    domain: Itsquitz.Game,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "results"
    repo Itsquitz.Repo
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :question, :string, allow_nil?: false
    attribute :image_url, :string, allow_nil?: true
    attribute :answer, :string, allow_nil?: false
    attribute :points, :integer, allow_nil?: false
    attribute :started_at, :utc_datetime_usec, allow_nil?: false
    attribute :ended_at, :utc_datetime_usec, allow_nil?: false
  end

  relationships do
    belongs_to :play, Itsquitz.Game.Play
    belongs_to :player, Itsquitz.Game.Player
    belongs_to :team, Itsquitz.Game.Team
  end
end

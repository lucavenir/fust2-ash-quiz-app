defmodule Itsquitz.Game.PlayerAnswer do
  use Ash.Resource,
    domain: Itsquitz.Game,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "player_answers"
    repo Itsquitz.Repo
  end

  attributes do
    uuid_v7_primary_key :id
  end

  relationships do
    belongs_to :play, Itsquitz.Game.Play, allow_nil?: false
    belongs_to :player, Itsquitz.Game.Player, allow_nil?: false
    belongs_to :question, Itsquitz.Content.Question, allow_nil?: false
  end

  identities do
    identity :unique_player_answer, [:play_id, :player_id, :question_id]
  end
end

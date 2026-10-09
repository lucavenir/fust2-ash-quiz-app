defmodule Itsquitz.Game.PlayerAnswer do
  use Ash.Resource,
    domain: Itsquitz.Game

  attributes do
    uuid_v7_primary_key :id
  end

  relationships do
    belongs_to :play, Itsquitz.Game.Play, allow_nil?: false
    belongs_to :player, Itsquitz.Game.Player, allow_nil?: false
    belongs_to :question, Itsquitz.Content.Question, allow_nil?: false
    belongs_to :selected_answer, Itsquitz.Content.Answer, allow_nil?: true
  end

  identities do
    identity :unique_player_answer, [:play_id, :player_id, :question_id]
  end
end

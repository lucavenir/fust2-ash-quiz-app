defmodule Itsquitz.Game.Answer do
  use Ash.Resource,
    domain: Itsquitz.Game,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "answer"
    repo Itsquitz.Repo
  end

  actions do
    defaults [:create, :read, :update]
  end

  attributes do
    attribute :answer, :string, allow_nil?: false
  end

  relationships do
    belongs_to :quiz, Itsquitz.Game.Quiz, primary_key?: true, allow_nil?: false
    belongs_to :partecipant, Itsquitz.Game.Partecipant, primary_key?: true, allow_nil?: false
  end
end

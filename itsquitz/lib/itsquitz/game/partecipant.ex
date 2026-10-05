defmodule Itsquitz.Game.Partecipant do
  use Ash.Resource,
    domain: Itsquitz.Game,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "partecipant"
    repo Itsquitz.Repo
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end

  attributes do
    uuid_primary_key :id

    attribute :username, :string, allow_nil?: false
  end

  relationships do
    many_to_many :quizzes, Itsquitz.Game.Quiz do
      through Itsquitz.Game.Answer
      source_attribute :id
      source_attribute_on_join_resource :partecipant_id
      destination_attribute :id
      destination_attribute_on_join_resource :quiz_id
    end
  end
end

defmodule Itsquitz.Game.Quiz do
  use Ash.Resource,
    domain: Itsquitz.Game,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "quiz"
    repo Itsquitz.Repo
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end

  attributes do
    uuid_primary_key :id

    attribute :text, :string, allow_nil?: false
    attribute :question1, :string, allow_nil?: false
    attribute :question2, :string, allow_nil?: false
    attribute :question3, :string, allow_nil?: false
    attribute :question4, :string, allow_nil?: false
    attribute :correct_answer, :string, allow_nil?: false

    attribute :argument, :atom,
      allow_nil?: false,
      constraints: [
        one_of: [
          :computer_science,
          :cybersecurity,
          :business,
          :databases,
          :backend,
          :frontend,
          :sysadmin,
          :ai,
          :agro,
          :energy
        ]
      ]

    attribute :points, :integer, allow_nil?: false
  end

  relationships do
    many_to_many :partecipants, Itsquitz.Game.Partecipant do
      through Itsquitz.Game.Answer
      source_attribute :id
      source_attribute_on_join_resource :quiz_id
      destination_attribute :id
      destination_attribute_on_join_resource :partecipant_id
    end
  end
end

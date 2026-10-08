defmodule Itsquitz.Content.Question do
  use Ash.Resource,
    domain: Itsquitz.Content,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "questions"
    repo Itsquitz.Repo
  end

  actions do
    defaults [:create, :read, :update, :destroy]
    default_accept [:text, :image_url]
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :text, :string, allow_nil?: false
    attribute :image_url, :string, allow_nil?: true

    timestamps()
  end

  relationships do
    belongs_to :topic, Itsquitz.Content.Topic
    has_many :answers, Itsquitz.Content.Answer
  end
end

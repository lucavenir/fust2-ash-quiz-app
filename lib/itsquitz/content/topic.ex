defmodule Itsquitz.Content.Topic do
  use Ash.Resource,
    domain: Itsquitz.Content,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "topics"
    repo Itsquitz.Repo
  end

  actions do
    defaults [:create, :read, :update, :destroy]
    default_accept [:name]
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :string, allow_nil?: false

    timestamps()
  end

  relationships do
    has_many :questions, Itsquitz.Content.Question
  end
end

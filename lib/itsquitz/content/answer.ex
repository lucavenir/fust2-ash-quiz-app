defmodule Itsquitz.Content.Answer do
  use Ash.Resource,
    domain: Itsquitz.Content,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "answers"
    repo Itsquitz.Repo
  end

  actions do
    defaults [:create, :read, :update, :destroy]
    default_accept [:answer, :points]
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :answer, :string, allow_nil?: false
    attribute :points, :integer, allow_nil?: false, default: 0

    timestamps()
  end

  relationships do
    belongs_to :question, Itsquitz.Content.Question, allow_nil?: false
  end
end

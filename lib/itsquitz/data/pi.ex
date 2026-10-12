defmodule Itsquitz.Data.PersonalInformation do
  use Ash.Resource,
    domain: Itsquitz.Data,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "personal_informations"
    repo Itsquitz.Repo
  end

  validations do
    validate match(:email, ~r/^[^\s]+@[^\s]+\.[^\s]+$/)

    validate string_length(:first_name, min: 2, max: 30),
      message: "must be between 2 and 30 characters"

    validate string_length(:last_name, min: 2, max: 30),
      message: "must be between 2 and 30 characters"

    validate string_length(:school, min: 7, max: 69),
      message: "must be between 7 and 69 characters"
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :email, :string, allow_nil?: false, sensitive?: true
    attribute :first_name, :string, allow_nil?: false, sensitive?: true
    attribute :last_name, :string, allow_nil?: false, sensitive?: true
    attribute :school, :string, allow_nil?: false
  end

  relationships do
    belongs_to :player, Itsquitz.Game.Player
  end
end

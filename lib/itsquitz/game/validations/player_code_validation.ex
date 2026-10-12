defmodule Itsquitz.Game.Validations.PlayerCodeValidation do
  use Ash.Resource.Validation

  @impl true
  def validate(changeset, _opts, _context) do
    submitted = Ash.Changeset.get_argument(changeset, :code)

    current_code = Itsquitz.Game.Lobby.get_code()

    if submitted == current_code do
      :ok
    else
      {:error, field: :code, message: "invalid code"}
    end
  end
end

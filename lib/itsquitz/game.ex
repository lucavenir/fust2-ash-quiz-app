defmodule Itsquitz.Game do
  use Ash.Domain

  resources do
    resource Itsquitz.Game.Play
    resource Itsquitz.Game.PlayerAnswer
    resource Itsquitz.Game.Player
    resource Itsquitz.Game.Results
    resource Itsquitz.Game.Team
  end
end

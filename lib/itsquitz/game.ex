defmodule Itsquitz.Game do
  use Ash.Domain

  resources do
    resource Itsquitz.Game.Play
    resource Itsquitz.Game.PlayerAnswer

    resource Itsquitz.Game.Player do
      define :join_lobby, action: :join_lobby
    end

    resource Itsquitz.Game.Result

    resource Itsquitz.Game.Team do
      define :new_team, action: :create
    end
  end
end

defmodule Itsquitz.Game do
  use Ash.Domain

  resources do
    resource Itsquitz.Game.Quiz
    resource Itsquitz.Game.Partecipant
    resource Itsquitz.Game.Answer
  end
end

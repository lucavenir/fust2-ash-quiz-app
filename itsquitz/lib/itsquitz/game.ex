defmodule Itsquitz.Game do
  use Ash.Domain

  resources do
    resource Itsquitz.Game.Quiz
  end
end

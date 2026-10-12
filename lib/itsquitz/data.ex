defmodule Itsquitz.Data do
  use Ash.Domain

  resources do
    resource Itsquitz.Data.Result
  end
end

defmodule Itsquitz.Data do
  use Ash.Domain

  resources do
    resource Itsquitz.Data.Result
    resource Itsquitz.Data.PersonalInformation
  end
end

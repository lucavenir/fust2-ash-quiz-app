defmodule Itsquitz.Content do
  use Ash.Domain

  resources do
    resource Itsquitz.Content.Topic
    resource Itsquitz.Content.Question
    resource Itsquitz.Content.Answer
  end
end

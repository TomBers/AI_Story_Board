defmodule Aistorybook.Chapter.Domain do
  use Ash.Domain, extensions: [AshAdmin.Domain]

  admin do
    show?(true)
  end

  resources do
    resource Aistorybook.Chapter.Resources.Chapter
  end
end

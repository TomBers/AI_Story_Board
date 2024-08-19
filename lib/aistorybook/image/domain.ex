defmodule Aistorybook.Image.Domain do
  use Ash.Domain, extensions: [AshAdmin.Domain]

  admin do
    show?(true)
  end

  resources do
    resource Aistorybook.Image.Resources.Image
  end
end

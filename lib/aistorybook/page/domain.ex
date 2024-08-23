defmodule Aistorybook.Page.Domain do
  use Ash.Domain, extensions: [AshAdmin.Domain]

  admin do
    show?(true)
  end

  resources do
    resource Aistorybook.Page.Resources.Page
    resource Aistorybook.Page.Resources.Panel
  end
end

defmodule Aistorybook.Project.Domain do
  use Ash.Domain, extensions: [AshAdmin.Domain]

  admin do
    show?(true)
  end

  resources do
    resource Aistorybook.Project.Resources.Project
  end
end

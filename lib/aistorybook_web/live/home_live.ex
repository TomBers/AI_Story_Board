defmodule AistorybookWeb.HomeLive do
  use Phoenix.LiveView
  alias Phoenix.LiveView.JS
  alias Aistorybook.Project.Access
  import AistorybookWeb.CoreComponents

  def mount(_params, _session, socket) do
    projects = Aistorybook.Project.Access.all_projects()

    form =
      Aistorybook.Project.Resources.Project
      |> AshPhoenix.Form.for_create(:create,
        forms: [auto?: true]
      )
      |> to_form()

    {:ok, assign(socket, projects: projects, form: form)}
  end
end

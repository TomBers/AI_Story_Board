defmodule AistorybookWeb.HomeLive do
  use Phoenix.LiveView
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

  def handle_event("create_project", %{"form" => params}, socket) do
    {:ok, project} = AshPhoenix.Form.submit(socket.assigns.form, params: params)
    Project.Data.create_related(project)

    {:noreply, socket |> push_navigate(to: "/board/#{project.name}")}
  end
end

defmodule AistorybookWeb.BoardLive do
  use Phoenix.LiveView
  # import AistorybookWeb.CoreComponents

  def mount(_params, _session, socket) do
    project = Aistorybook.Project.Access.get_project_by_name("Test1") |> IO.inspect()

    {:ok, assign(socket, project: project)}
  end
end

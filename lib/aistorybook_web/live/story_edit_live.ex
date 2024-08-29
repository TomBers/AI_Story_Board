defmodule AistorybookWeb.StoryEditLive do
  use Phoenix.LiveView
  alias Aistorybook.Project.Access

  def mount(%{"project_name" => project_name}, _session, socket) do
    project = Access.get_project_by_name(project_name)
    {:ok, assign(socket, project: project)}
  end

  def handle_event("store-text", contents, socket) do
    Access.update_notes(socket.assigns.project, contents)
    {:noreply, socket |> put_flash(:info, "Saved")}
  end
end

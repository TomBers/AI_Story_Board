defmodule AistorybookWeb.BoardLive do
  use Phoenix.LiveView
  alias Aistorybook.Project.Access
  # import AistorybookWeb.CoreComponents

  def mount(params, _session, socket) do
    chapter_name = Map.get(params, "chapter")
    project = Access.get_project_by_name("Test1")

    chapter = Access.find_chapter_by_name(project, chapter_name)

    {:ok, assign(socket, project: project, chapter: chapter, chapter_name: chapter_name)}
  end

  def handle_event("add-page", _params, socket) do
    Access.add_page_to_chapter(socket.assigns.chapter)

    project = Access.get_project_by_name("Test1")

    chapter = Access.find_chapter_by_name(project, socket.assigns.chapter_name)

    {:noreply, assign(socket, project: project, chapter: chapter)}
  end
end

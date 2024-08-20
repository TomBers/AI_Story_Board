defmodule AistorybookWeb.BoardLive do
  use Phoenix.LiveView
  alias Aistorybook.Project.Access
  import AistorybookWeb.CoreComponents

  def mount(params, _session, socket) do
    chapter_name = Map.get(params, "chapter")
    project = Access.get_project_by_name("Test1")

    chapter = Access.find_chapter_by_name(project, chapter_name)

    new_chapter_form =
      Aistorybook.Chapter.Resources.Chapter
      |> AshPhoenix.Form.for_create(:create, forms: [auto?: true])
      |> to_form()

    {:ok,
     assign(socket,
       project: project,
       chapter: chapter,
       chapter_name: chapter_name,
       new_chapter_form: new_chapter_form
     )}
  end

  def handle_event("add-page", _params, socket) do
    Access.add_page_to_chapter(socket.assigns.chapter)

    project = Access.get_project_by_name("Test1")

    chapter = Access.find_chapter_by_name(project, socket.assigns.chapter_name)

    {:noreply, assign(socket, project: project, chapter: chapter)}
  end

  def handle_event("create_new_chapter", %{"form" => params}, socket) do
    AshPhoenix.Form.submit(socket.assigns.new_chapter_form,
      params: Map.put(params, "project_id", socket.assigns.project.id)
    )

    project = Access.get_project_by_name("Test1")

    chapter = Access.find_chapter_by_name(project, socket.assigns.chapter_name)

    new_chapter_form =
      Aistorybook.Chapter.Resources.Chapter
      |> AshPhoenix.Form.for_create(:create, forms: [auto?: true])
      |> to_form()

    {:noreply,
     assign(socket, project: project, chapter: chapter, new_chapter_form: new_chapter_form)}
  end
end

defmodule AistorybookWeb.BoardLive do
  use Phoenix.LiveView
  alias Phoenix.LiveView.JS
  alias Aistorybook.Project.Access
  import AistorybookWeb.CoreComponents

  def mount(%{"name" => name} = params, _args, socket) do
    Phoenix.PubSub.subscribe(Aistorybook.PubSub, "updated_panel")

    chapter_name = Map.get(params, "chapter")
    project = Access.get_project_by_name(name)

    chapter = Access.find_chapter_by_name(project, chapter_name)

    new_chapter_form =
      Aistorybook.Chapter.Resources.Chapter
      |> AshPhoenix.Form.for_create(:create,
        id: Enum.random(1..10000) |> Integer.to_string(),
        forms: [auto?: true]
      )
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
    chapter = Access.add_page_to_chapter(socket.assigns.chapter)

    # project = Access.get_project_by_name("Test1")

    # chapter = Access.find_chapter_by_name(project, socket.assigns.chapter_name)

    {:noreply, assign(socket, chapter: chapter)}
  end

  def handle_event("create_new_chapter", %{"form" => params}, socket) do
    {:ok, new_chapter} =
      AshPhoenix.Form.submit(socket.assigns.new_chapter_form,
        params: Map.put(params, "project_id", socket.assigns.project.id)
      )

    updated_project = %{
      socket.assigns.project
      | chapters: [new_chapter] ++ socket.assigns.project.chapters
    }

    new_chapter_form =
      Aistorybook.Chapter.Resources.Chapter
      |> AshPhoenix.Form.for_create(:create,
        id: Enum.random(1..10000) |> Integer.to_string(),
        forms: [auto?: true]
      )
      |> to_form()

    {:noreply, assign(socket, project: updated_project, new_chapter_form: new_chapter_form)}
  end

  def handle_info(%{page_id: updated_page_id}, socket) do
    chapter = Enum.find(socket.assigns.project.chapters, &(&1.id == socket.assigns.chapter.id))

    if Enum.any?(chapter.pages, &(&1.id == updated_page_id)) do
      project = Access.get_project_by_name(socket.assigns.project.name)
      chapter = Access.find_chapter_by_name(project, socket.assigns.chapter_name)
      {:noreply, assign(socket, project: project, chapter: chapter)}
    else
      {:noreply, socket}
    end
  end
end

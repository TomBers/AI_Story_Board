defmodule AistorybookWeb.Comps.ChapterComp do
  use Phoenix.LiveComponent
  import AistorybookWeb.CoreComponents
  alias Phoenix.LiveView.JS

  def update(assigns, socket) do
    form =
      assigns.chapter
      |> AshPhoenix.Form.for_update(:update, forms: [auto?: true])
      |> to_form()

    form_div_id = "rename_chapter_form_id_#{assigns.chapter.id}"

    {:ok,
     assign(socket,
       chapter: assigns.chapter,
       form: form,
       form_div_id: form_div_id,
       project_name: assigns.project_name
     )}
  end

  def handle_event("rename_chapter", %{"form" => params}, socket) do
    {:ok, chapter} = AshPhoenix.Form.submit(socket.assigns.form, params: params)

    form =
      chapter
      |> AshPhoenix.Form.for_update(:update, forms: [auto?: true])
      |> to_form()

    {:noreply, assign(socket, chapter: chapter, form: form)}
  end

  def handle_event("navToChapter", _p, socket) do
    {:noreply,
     socket
     |> push_navigate(
       to: "/board/#{socket.assigns.project_name}?chapter=#{socket.assigns.chapter.name}"
     )}
  end
end

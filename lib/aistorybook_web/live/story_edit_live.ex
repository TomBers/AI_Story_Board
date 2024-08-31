defmodule AistorybookWeb.StoryEditLive do
  use Phoenix.LiveView
  import AistorybookWeb.CoreComponents

  alias Aistorybook.Project.Access

  def mount(%{"project_name" => project_name}, _session, socket) do
    project = Access.get_project_by_name(project_name)

    form =
      Aistorybook.Page.Resources.Panel
      |> AshPhoenix.Form.for_create(:create,
        forms: [auto?: true],
        prepare_source: fn params ->
          update_in(params.data.text, fn _v -> "A Sample" end)
        end
      )
      |> to_form()

    {:ok, assign(socket, project: project, form: form)}
  end

  def panel_options(project) do
    project.chapters
    |> Enum.flat_map(fn chapter ->
      Aistorybook.Page.Utils.order_pages_with_index(chapter.pages)
      |> Enum.map(fn {page, indx} -> {"#{chapter.name} Page #{indx}", page.id} end)
    end)
  end

  def handle_event("store-text", contents, socket) do
    project = Access.update_notes(socket.assigns.project, contents)
    {:noreply, assign(socket, project: project) |> put_flash(:info, "Saved")}
  end

  def handle_event("create-panel", %{"selection" => selection}, socket) do
    form =
      Aistorybook.Page.Resources.Panel
      |> AshPhoenix.Form.for_create(:create,
        forms: [auto?: true],
        prepare_source: fn params ->
          update_in(params.data.text, fn _v -> selection end)
        end
      )
      |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("create_new_panel", %{"form" => params}, socket) do
    AshPhoenix.Form.submit(socket.assigns.form,
      params: params
    )

    {:noreply, socket |> put_flash(:info, "Panel Created")}
  end

  def handle_event("navToBoard", _p, socket) do
    {:noreply, socket |> push_navigate(to: "/board/#{socket.assigns.project.name}")}
  end
end

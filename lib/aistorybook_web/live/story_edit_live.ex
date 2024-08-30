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
      get_pages(chapter.pages)
      |> Enum.map(fn {page, indx} -> {"#{chapter.name}_Page_#{indx}", page.id} end)
    end)
  end

  def get_pages(pages) do
    # TODO - put this function somewhere
    pages
    |> Enum.sort(&DateTime.before?(&1.created_at, &2.created_at))
    |> then(&Enum.with_index(&1))
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
end

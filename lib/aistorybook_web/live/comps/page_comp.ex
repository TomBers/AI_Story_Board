defmodule AistorybookWeb.Comps.PageComp do
  use Phoenix.LiveComponent
  import AistorybookWeb.CoreComponents

  def update(assigns, socket) do
    new_panel_form =
      Aistorybook.Page.Resources.Panel
      |> AshPhoenix.Form.for_create(:create, forms: [auto?: true])
      |> to_form()

    {:ok,
     assign(socket,
       page: assigns.page,
       indx: assigns.indx,
       new_panel_form: new_panel_form,
       layout: :row,
       project_name: assigns.project_name
     )}
  end

  def handle_event("create_new_panel", %{"form" => params}, socket) do
    {:ok, new_panel} =
      AshPhoenix.Form.submit(socket.assigns.new_panel_form,
        params: Map.put(params, "page_id", socket.assigns.page.id)
      )

    created_panel = Aistorybook.Page.Access.get_panel_by_id(new_panel.id)

    updated_page = %{
      socket.assigns.page
      | panels: socket.assigns.page.panels ++ [Aistorybook.Page.GenPanel.gen_image(created_panel)]
    }

    {:noreply,
     assign(socket,
       page: updated_page
     )}
  end

  def handle_event("toggle-output", _params, socket) do
    layout =
      if socket.assigns.layout == :row do
        :col
      else
        :row
      end

    {:noreply,
     assign(socket,
       layout: layout
     )}
  end

  def handle_event("navToPreview", _unsigned_params, socket) do
    {:noreply,
     socket
     |> push_navigate(to: "/page/#{socket.assigns.page.id}/#{socket.assigns.project_name}")}
  end
end

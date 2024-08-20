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
       new_panel_form: new_panel_form
     )}
  end

  def handle_event("create_new_panel", %{"form" => params}, socket) do
    {:ok, new_panel} =
      AshPhoenix.Form.submit(socket.assigns.new_panel_form,
        params: Map.put(params, "page_id", socket.assigns.page.id)
      )

    updated_page = %{socket.assigns.page | panels: socket.assigns.page.panels ++ [new_panel]}

    {:noreply,
     assign(socket,
       page: updated_page
     )}
  end
end

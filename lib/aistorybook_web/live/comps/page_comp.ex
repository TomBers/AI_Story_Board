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
       layout: :row
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

  def get_panel_class(panels, layout) do
    case length(panels) do
      1 -> "grid grid-cols-1"
      2 -> two_col_layout(layout)
      4 -> "grid grid-cols-2 gap-4"
      6 -> "grid grid-cols-3 gap-4"
      _ -> "grid grid-cols-1"
    end
  end

  def two_col_layout(layout) do
    case layout do
      :row -> "flex flex-row"
      :col -> "flex flex-col"
    end
  end
end

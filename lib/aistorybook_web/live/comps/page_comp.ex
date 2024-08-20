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

    IO.inspect(new_panel, label: "new panel")

    # TODO - this is not working (UndefinedFunctionError) function Aistorybook.Page.Resources.Page.get_and_update/3 is undefined (Aistorybook.Page.Resources.Page does not implement the Access behaviour
    updated_page = update_in(socket.assigns.page, [:panels], &(&1 ++ [new_panel]))

    {:noreply,
     assign(socket,
       page: updated_page
     )}
  end
end

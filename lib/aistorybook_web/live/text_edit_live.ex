defmodule AistorybookWeb.TextEditLive do
  use Phoenix.LiveView
  alias Aistorybook.Page.Access
  import AistorybookWeb.CoreComponents

  def mount(%{"panel_id" => panel_id}, _p, socket) do
    panel = Access.get_panel_by_id(panel_id)

    form =
      panel.text_config
      |> AshPhoenix.Form.for_update(:update, forms: [auto?: true])
      |> to_form()

    {:ok, assign(socket, panel: panel, form: form)}
  end

  def handle_event("update_text_config", %{"form" => params}, socket) do
    {:ok, updated_panel} =
      AshPhoenix.Form.submit(socket.assigns.form,
        params: params
      )

    panel = Access.get_panel_by_id(updated_panel.panel_id)

    form =
      panel.text_config
      |> AshPhoenix.Form.for_update(:update, forms: [auto?: true])
      |> to_form()

    {:noreply, assign(socket, panel: panel, form: form)}
  end
end

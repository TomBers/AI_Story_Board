defmodule AistorybookWeb.Comps.PanelComp do
  use Phoenix.LiveComponent
  import AistorybookWeb.CoreComponents
  alias Phoenix.LiveView.JS
  alias Aistorybook.Page.GenPanel

  def update(assigns, socket) do
    form =
      assigns.panel
      |> AshPhoenix.Form.for_update(:update, forms: [auto?: true])
      |> to_form()

    form_div_id = "update_panel_form_id_#{assigns.panel.id}"

    {:ok, assign(socket, panel: assigns.panel, form: form, form_div_id: form_div_id)}
  end

  def handle_event("change_panel", %{"form" => params}, socket) do
    {:ok, panel} = AshPhoenix.Form.submit(socket.assigns.form, params: params)

    form =
      panel
      |> AshPhoenix.Form.for_update(:update, forms: [auto?: true])
      |> to_form()

    {:noreply, assign(socket, panel: panel, form: form)}
  end

  def handle_event("generate", _params, socket) do
    updated_panel = GenPanel.gen_image(socket.assigns.panel)

    {:noreply, assign(socket, panel: updated_panel)}
  end

  def get_panel_img(panel) do
    panel.images
    |> Enum.sort(&DateTime.after?(&1.created_at, &2.created_at))
    |> List.first()
    |> then(& &1.url)
  end
end

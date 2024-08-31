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

    {:ok,
     assign(socket,
       panel: assigns.panel,
       form: form,
       form_div_id: form_div_id,
       project_name: assigns.project_name
     )}
  end

  def handle_event("change_panel", %{"form" => params}, socket) do
    {:ok, panel} = AshPhoenix.Form.submit(socket.assigns.form, params: params)

    updated_panel = GenPanel.gen_image(Aistorybook.Page.Access.get_panel_by_id(panel.id))

    form =
      panel
      |> AshPhoenix.Form.for_update(:update, forms: [auto?: true])
      |> to_form()

    {:noreply, assign(socket, panel: updated_panel, form: form)}
  end

  def handle_event("next_image", _params, socket) do
    updated_panel = Aistorybook.Page.Access.cycle_image(socket.assigns.panel, :next)
    {:noreply, assign(socket, panel: updated_panel)}
  end

  def handle_event("previous_image", _params, socket) do
    updated_panel = Aistorybook.Page.Access.cycle_image(socket.assigns.panel, :previous)
    {:noreply, assign(socket, panel: updated_panel)}
  end

  def handle_event("navToTextEdit", _p, socket) do
    {:noreply,
     socket
     |> push_navigate(to: "/edit/#{socket.assigns.project_name}/#{socket.assigns.panel.id}")}
  end
end

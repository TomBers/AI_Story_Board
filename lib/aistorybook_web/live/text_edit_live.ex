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

    text_config = Access.get_text_config(panel.text_config)

    {:ok, assign(socket, panel: panel, form: form, text_config: text_config)}
  end

  def handle_event("change_text_config", %{"form" => params}, socket) do
    new_tc = %{
      font: params["font"],
      font_size: params["font_size"] |> String.to_integer(),
      text_col: params["text_col"],
      background_col: params["background_col"],
      x: params["x"] |> String.to_integer(),
      y: params["y"] |> String.to_integer()
    }

    {:noreply, assign(socket, text_config: new_tc)}
  end

  def handle_event("save_text_config", %{"form" => params}, socket) do
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

  def get_panel_img(panel) do
    panel.images
    |> Enum.find(&(&1.id == panel.image_id))
    |> then(& &1.url)
  end
end

defmodule AistorybookWeb.TextEditLive do
  use Phoenix.LiveView
  alias Aistorybook.Page.Access
  import AistorybookWeb.CoreComponents

  def mount(
        %{"board_name" => board_name, "panel_id" => panel_id, "chapter_name" => chapter_name},
        _p,
        socket
      ) do
    panel = Access.get_panel_by_id(panel_id)

    form =
      panel
      |> AshPhoenix.Form.for_update(:update_text, forms: [auto?: true])
      |> to_form()

    text_config = Access.get_text_config(panel)

    {:ok,
     assign(socket,
       panel: panel,
       form: form,
       text_config: text_config,
       txt: panel.text,
       board_name: board_name,
       chapter_name: chapter_name
     )}
  end

  def handle_event("change_text_config", %{"form" => params}, socket) do
    new_tc = %{
      font: params["font"],
      font_size: params["font_size"] |> String.to_integer(),
      text_col: params["text_col"],
      background_col: params["background_col"],
      text_width: params["text_width"],
      x: params["x"] |> String.to_integer(),
      y: params["y"] |> String.to_integer()
    }

    {:noreply, assign(socket, text_config: new_tc, txt: params["text"])}
  end

  def handle_event("save_text_config", %{"form" => params}, socket) do
    {:ok, updated_panel} =
      AshPhoenix.Form.submit(socket.assigns.form,
        params: params
      )

    panel = Access.get_panel_by_id(updated_panel.id)

    form =
      panel
      |> AshPhoenix.Form.for_update(:update_text, forms: [auto?: true])
      |> to_form()

    {:noreply,
     assign(socket, panel: panel, form: form, txt: panel.text) |> put_flash(:info, "Saved")}
  end

  def handle_event("navToBoard", _unsigned_params, socket) do
    {:noreply,
     socket
     |> push_navigate(
       to: "/board/#{socket.assigns.board_name}?chapter=#{socket.assigns.chapter_name}"
     )}
  end

  def get_panel_img(panel) do
    panel.images
    |> Enum.find(%{url: "/images/placeholder.png"}, &(&1.id == panel.image_id))
    |> then(& &1.url)
  end

  def font_options do
    fonts = [
      "Times New Roman",
      "Georgia",
      "Garamond",
      "Arial",
      "Verdana",
      "Helvetica",
      "Courier New",
      "Lucida Console",
      "Monaco",
      "Brush Script MT",
      "Lucida Handwriting",
      "Copperplate",
      "Papyrus"
    ]

    fonts |> Enum.map(&{&1, &1})
  end
end

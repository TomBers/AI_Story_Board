defmodule AistorybookWeb.Comps.ImgComp do
  use Phoenix.LiveComponent

  def update(assigns, socket) do
    text_config =
      Map.take(assigns.panel.text_config, [:font, :font_size, :text_col, :background_col, :x, :y])

    {:ok, assign(socket, panel: assigns.panel, text_config: text_config)}
  end

  def get_panel_img(panel) do
    panel.images
    |> Enum.find(&(&1.id == panel.image_id))
    |> then(& &1.url)
  end
end

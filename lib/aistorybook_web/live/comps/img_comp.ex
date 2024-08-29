defmodule AistorybookWeb.Comps.ImgComp do
  use Phoenix.LiveComponent

  def update(assigns, socket) do
    text_config =
      Aistorybook.Page.Access.get_text_config(assigns.panel)

    {:ok, assign(socket, panel: assigns.panel, text_config: text_config)}
  end

  def get_panel_img(panel) do
    panel.images
    |> Enum.find(%{url: "/images/placeholder.jpg"}, &(&1.id == panel.image_id))
    |> then(& &1.url)
  end
end

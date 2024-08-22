defmodule AistorybookWeb.Comps.ImgComp do
  use Phoenix.LiveComponent
  import AistorybookWeb.CoreComponents
  alias Phoenix.LiveView.JS
  alias Aistorybook.Page.GenPanel

  def update(assigns, socket) do
    {:ok, assign(socket, panel: assigns.panel)}
  end

  def get_panel_img(panel) do
    panel.images
    |> Enum.find(&(&1.id == panel.image_id))
    |> then(& &1.url)
  end
end

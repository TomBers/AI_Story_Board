defmodule AistorybookWeb.Comps.PanelComp do
  use Phoenix.LiveComponent

  def update(assigns, socket) do
    {:ok,
     assign(socket,
       panel: assigns.panel
     )}
  end
end

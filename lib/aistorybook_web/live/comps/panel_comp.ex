defmodule AistorybookWeb.Comps.PanelComp do
  use Phoenix.LiveComponent

  def update(assigns, socket) do
    # IO.inspect(assigns.panel, label: "Panel")
    # img = assigns.panel.images |> List.first() |> then(& &1.url)

    {:ok,
     assign(socket,
       panel: assigns.panel
     )}
  end
end

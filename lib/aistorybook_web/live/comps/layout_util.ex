defmodule AistorybookWeb.Comps.LayoutUtil do
  def get_panel_class(panels, layout \\ :row) do
    case length(panels) do
      1 -> "grid grid-cols-1"
      2 -> two_col_layout(layout)
      4 -> "grid grid-cols-2 gap-4"
      6 -> "grid grid-cols-3 gap-4"
      _ -> "grid grid-cols-2 gap-4"
    end
  end

  def two_col_layout(layout) do
    case layout do
      :row -> "flex flex-row"
      :col -> "flex flex-col"
    end
  end
end

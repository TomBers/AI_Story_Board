defmodule Aistorybook.Page.Utils do
  def order_pages_with_index(pages) do
    pages
    |> Enum.sort(&DateTime.before?(&1.created_at, &2.created_at))
    |> then(&Enum.with_index(&1, 1))
  end
end

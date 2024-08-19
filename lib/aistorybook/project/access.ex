defmodule Aistorybook.Project.Access do
  require Ash.Query

  def get_project_by_name(name) do
    Aistorybook.Project.Resources.Project
    |> Ash.Query.load(chapters: [pages: [panels: [:images]]])
    |> Ash.Query.filter(name == ^name)
    |> Ash.read_one!()
  end
end

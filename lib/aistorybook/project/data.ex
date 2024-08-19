defmodule Project.Data do
  require Ash.Query

  def run do
    # Create
    Aistorybook.Project.Resources.Project
    |> Ash.Changeset.for_create(:create, %{name: "Test1"})
    |> Ash.create!()

    # List all
    Ash.read!(Aistorybook.Project.Resources.Project)

    # Find by project name
    Aistorybook.Project.Resources.Project
    |> Ash.Query.filter(name == "Test1")
    |> Ash.read!()
  end
end

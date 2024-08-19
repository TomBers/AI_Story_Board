defmodule Project.Data do
  require Ash.Query

  def run do
    # Create
    project =
      Aistorybook.Project.Resources.Project
      |> Ash.Changeset.for_create(:create, %{name: "Test1", style: "In an impressonistic style"})
      |> Ash.create!()

    chapter =
      Aistorybook.Chapter.Resources.Chapter
      |> Ash.Changeset.for_create(:create, %{name: "Chapter1", project_id: project.id})
      |> Ash.create!()

    page =
      Aistorybook.Page.Resources.Page
      |> Ash.Changeset.for_create(:create, %{
        chapter_id: chapter.id
      })
      |> Ash.create!()

    panel =
      Aistorybook.Page.Resources.Panel
      |> Ash.Changeset.for_create(:create, %{
        text: "This is the first label",
        image_prompt: "Create an image of a cactus",
        page_id: page.id
      })
      |> Ash.create!()

    Aistorybook.Image.Resources.Image
    |> Ash.Changeset.for_create(:create, %{
      url: "https://picsum.photos/seed/picsum/200/300",
      panel_id: panel.id
    })
    |> Ash.create!()

    # List all
    # Ash.read!(Aistorybook.Project.Resources.Project)

    # Find by project name
    # Aistorybook.Project.Resources.Project
    # |> Ash.Query.filter(name == "Test1")
    # |> Ash.read!()
  end
end

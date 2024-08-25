defmodule Project.Data do
  require Ash.Query

  def run do
    # Create
    project =
      Aistorybook.Project.Resources.Project
      |> Ash.Changeset.for_create(:create, %{name: "Test1", style: "In an impressonistic style"})
      |> Ash.create!()

    create_related(project)
  end

  def create_related(project) do
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
        width: 512,
        height: 512,
        page_id: page.id
      })
      |> Ash.create!()

    image =
      Aistorybook.Image.Resources.Image
      |> Ash.Changeset.for_create(:create, %{
        # url: "https://picsum.photos/seed/picsum/200/300",
        url: "/images/placeholder.jpg",
        panel_id: panel.id
      })
      |> Ash.create!()

    Aistorybook.Page.Access.set_panel_image(panel, image)

    # List all
    # Ash.read!(Aistorybook.Project.Resources.Project)

    # Find by project name
    # Aistorybook.Project.Resources.Project
    # |> Ash.Query.filter(name == "Test1")
    # |> Ash.read!()
  end
end

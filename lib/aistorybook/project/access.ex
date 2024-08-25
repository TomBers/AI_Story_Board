defmodule Aistorybook.Project.Access do
  require Ash.Query

  def all_projects do
    Aistorybook.Project.Resources.Project
    |> Ash.read!()
  end

  def get_project_by_name(name) do
    Aistorybook.Project.Resources.Project
    |> Ash.Query.load(chapters: [pages: [panels: [:images]]])
    |> Ash.Query.filter(name == ^name)
    |> Ash.read_one!()
  end

  def find_chapter_by_name(project, chapter_name) do
    Enum.find(
      project.chapters,
      List.first(project.chapters),
      &(&1.name == chapter_name)
    )
  end

  def add_page_to_chapter(chapter) do
    Aistorybook.Page.Resources.Page
    |> Ash.Changeset.for_create(:create, %{
      chapter_id: chapter.id
    })
    |> Ash.create!()

    Aistorybook.Chapter.Resources.Chapter
    |> Ash.Query.load(pages: [panels: [:images]])
    |> Ash.Query.filter(id == ^chapter.id)
    |> Ash.read_one!()
  end
end

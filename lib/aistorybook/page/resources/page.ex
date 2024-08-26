defmodule Aistorybook.Page.Resources.Page do
  use Ash.Resource, data_layer: AshPostgres.DataLayer, domain: Aistorybook.Page.Domain

  postgres do
    table "pages"
    repo Aistorybook.Repo
  end

  actions do
    defaults [:read]

    create :create do
      accept [:chapter_id]
    end

    update :update do
      accept [:chapter_id]
    end
  end

  attributes do
    uuid_primary_key :id

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :chapter, Aistorybook.Chapter.Resources.Chapter
    has_many :panels, Aistorybook.Page.Resources.Panel
  end
end

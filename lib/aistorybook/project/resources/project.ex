defmodule Aistorybook.Project.Resources.Project do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    domain: Aistorybook.Project.Domain

  postgres do
    table "projects"
    repo Aistorybook.Repo
  end

  actions do
    defaults [:read]

    create :create do
      accept [:name, :style]
    end

    update :update do
      accept [:name, :style]
    end

    update :update_notes do
      accept [:notes]
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
      public? true
    end

    attribute :style, :string do
      allow_nil? true
      public? true
    end

    attribute :notes, :string do
      allow_nil? true
      public? true
    end

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    has_many :chapters, Aistorybook.Chapter.Resources.Chapter
  end
end

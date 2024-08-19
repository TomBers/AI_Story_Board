defmodule Aistorybook.Chapter.Resources.Chapter do
  use Ash.Resource, data_layer: Ash.DataLayer.Ets, domain: Aistorybook.Chapter.Domain

  actions do
    defaults [:read]

    create :create do
      accept [:name, :style, :project_id]
    end

    update :update do
      accept [:name, :style, :project_id]
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

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :project, Aistorybook.Project.Resources.Project
    has_many :pages, Aistorybook.Page.Resources.Page
  end
end

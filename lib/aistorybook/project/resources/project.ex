defmodule Aistorybook.Project.Resources.Project do
  use Ash.Resource, data_layer: Ash.DataLayer.Ets, domain: Aistorybook.Project.Domain

  actions do
    defaults [:read]

    create :create do
      accept [:name]
    end

    update :update do
      accept [:name]
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
      public? true
    end

    create_timestamp :created_at
    update_timestamp :updated_at
  end
end

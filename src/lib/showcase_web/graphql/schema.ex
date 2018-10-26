defmodule ShowcaseWeb.Schema do
  use Absinthe.Schema
  import_types(Absinthe.Type.Custom)

  alias ShowcaseWeb.Resolvers

  import_types(__MODULE__.AccountTypes)

  def middleware(middleware, _field, _object) do
    middleware
  end

  query do
    import_fields(:user_queries)
  end

  mutation do
    import_fields(:login)
  end

  object :user_queries do
    @desc """
    query user info(admin accounts are excluded)
    """

    field :users, list_of(:user) do
      arg(:id, :id)
      arg(:nickname, :string)
      resolve(&Resolvers.Accounts.users/3)
    end
  end

  object :login do
    @desc """
    login with the params
    """

    field :login, :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      arg(:permission, non_null(:permission))
      resolve(&Resolvers.Accounts.login/3)
    end
  end
end

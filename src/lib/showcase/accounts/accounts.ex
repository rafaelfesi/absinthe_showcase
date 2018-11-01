defmodule Showcase.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Showcase.Repo

  alias Showcase.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  def list_users(:normal_user, args) do
    query =
      from(
        u in User,
        where: u.permission == 0,
        order_by: [asc: u.id]
      )

    Enum.reduce(args, query, fn
      {_, nil}, query ->
        query

      {:id, id}, query ->
        from(
          q in query,
          where: q.id == ^id
        )

      {:nickname, nickname}, query ->
        from(
          q in query,
          where: q.nickname == ^nickname
        )
    end)
    |> Repo.all()
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id, permission) do
    Repo.get_by(User, id: id, permission: permission)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def authenticate(permission, email, password) do
    user = Repo.get_by(User, permission: permission, email: email)

    ### In a production, you must use comeonin or such to avoid plain password!
    with %{plain_password: db_password} <- user,
         true <- db_password == password do
      {:ok, user}
    else
      _ -> :error
    end
  end

  def user_for_question(question) do
    question
    |> Ecto.assoc(:user)
    |> Repo.one()
  end

  def user_for_answer(answer) do
    answer
    |> Ecto.assoc(:user)
    |> Repo.one()
  end
end

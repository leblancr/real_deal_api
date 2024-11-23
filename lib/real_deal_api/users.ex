defmodule RealDealApi.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias RealDealApi.Repo

  alias RealDealApi.Users.User

  @doc """
  Creates a user.
  Given the association has_one :user, User in the Account schema,
  Ecto knows that the associated struct should be of type User, because it is defined as such in the schema.
  the new User struct (with its associated account_id) is inserted into the database as a new row in the users table.
  the new User will replace the old one when you build and insert the new User

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

      build_assoc/2 - takes two args
      piped in thing becomes first arg of function
      account |> Ecto.build_assoc(user) = equivalent to Ecto.build_assoc(account, user)
  """
  def create_user(account, attrs \\ %{}) do
    account
    |> Ecto.build_assoc(:user)  # Step 1: Build the associated User struct
    |> IO.inspect(label: "After build_assoc")  # Debug step to inspect the new object
    |> User.changeset(attrs)     # Step 2: Apply changeset
    |> IO.inspect(label: "After changeset")  # Debug step to inspect the object after changeset
    |> Repo.insert()             # Step 3: Insert the new user into the database
    |> IO.inspect(label: "After Repo.insert")  # Debug step to inspect the result of Repo.insert
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
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

  @doc """
  Updates a user. what does that mean?

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
  Deletes a user.

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
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end

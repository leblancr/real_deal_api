defmodule RealDealApi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias RealDealApi.Repo

  alias RealDealApi.Accounts.Account

  @doc """
  Creates an account.
  Creating a New Struct:
  %Account{} initializes a new instance of the Account struct. At this point, it contains no data (i.e., all fields are set to their default values).

  Pipeline Usage:
  The function then uses the pipe operator (|>) to pass this empty struct to the Account.changeset(attrs) function, where attrs is a map of attributes you want to set for this new account.

  Inserting into the Database:
  Finally, Repo.insert() attempts to insert the changeset (which includes the data from attrs and any validation) into the database.

    ## Examples

      iex> create_account(%{email: value, hash_password: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

    \\ operator allows you to specify a default value for the attrs parameter. If no argument is provided when calling create_account, attrs will default to an empty map %{}.
  """
  def create_account(attrs \\ %{}) do
    %Account{} # new empty struct created
    |> Account.changeset(attrs) # set values with changeset/1
    |> Repo.insert() # insert the changeset (which includes the data from attrs and any validation) into the database
  end

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Repo.all(Account)
  end

  @doc """
  Gets a single account by email.

  returns nil if account doesn't exist.

  ## Examples

      iex> get_account_by_email(test@email.com)
      %Account{}

      iex> get_account_by_email(no_account@email.com)
      nil
  """
   def get_account_by_email(email) do
     Account # database schema module from RealDealApi.Accounts.Account (account.ex)
     |> where(email: ^email) # ^ = pin the variable
     |> Repo.one()
   end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """

  """

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{data: %Account{}}

  """
  def change_account(%Account{} = account, attrs \\ %{}) do
    Account.changeset(account, attrs)
  end
end

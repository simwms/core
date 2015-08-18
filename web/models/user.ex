defmodule Core.User do
  use Core.Web, :model

  schema "users" do
    field :email, :string
    field :username, :string
    field :password_hash, :string
    field :recovery_hash, :string
    field :remember_token, :string
    field :forget_at, Ecto.DateTime
    field :remembered_at, Ecto.DateTime
    field :stripe_customer_id, :string
    has_many :accounts, Core.Account
    timestamps
  end

  @required_fields ~w(email username password_hash)
  @optional_fields ~w(recovery_hash remember_token forget_at stripe_customer_id)
  @password_hash_opts [min_length: 1, extra_chars: false]
  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    params = params |> process_params
    model 
    |> cast(params, @required_fields, @optional_fields)
    |> downcase_email
    |> validate_format(:email, ~r/@/)
    |> validate_unique(:email, on: Core.Repo, downcase: true)
    |> validate_unique(:username, on: Core.Repo, downcase: true)
  end

  def process_params(%{"password" => _}=params) do
    case params |> Comeonin.create_user(@password_hash_opts) do
      {:ok, p} -> p 
      {:error, _} -> params
    end
  end
  def process_params(%{password: _}=params) do
    case params |> Comeonin.create_user(@password_hash_opts) do
      {:ok, p} -> p 
      {:error, _} -> params
    end
  end
  def process_params(p), do: p

  defp downcase_email(changeset) do
    if email = changeset |> get_field(:email) do
      changeset |> put_change(:email, String.downcase(email))
    else
      changeset
    end
  end

  def synchronize_stripe(user) do
    case user.stripe_customer_id do
      nil -> initialize_stripe(user)
      _ -> user
    end
  end

  defp initialize_stripe(user) do
    customer = create_stripe_customer user
    user
    |> changeset(%{"stripe_customer_id" => customer.id})
    |> Repo.update!
  end

  defp create_stripe_customer(user) do
    metadata = %{ "username" => user.username, "id" => user.id }
    Stripex.Customers.create email: user.email, metadata: metadata
  end

end

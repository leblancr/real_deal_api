# RealDealApi

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix


RealDealApi Project tutorial:
https://www.youtube.com/watch?v=LGY_eILc8Ks
Using Phoenix Framework to Create an Elixir REST API Project

Project setup:
mix phx.new real_deal_api --no-install --app real_deal_api --database postgres --no-live --no-assets --no-html --no-dashboard --no-mailer --binary-id

$ cd real_deal_api
$ mix deps.get

Then configure your database in config/dev.exs and run:

    $ mix ecto.create

Start your Phoenix app with:

    $ mix phx.server

You can also run your app inside IEx (Interactive Elixir) as:

    $ iex -S mix phx.server

Database:
real_deal_api_dev

Database setup:
1. Create account table
mix phx.gen.json Accounts Account accounts email:string hash_password:string
Accounts = module with database interact code.
Account = schema file being created.
accounts = database table name being created.
email:string =
hash_password:string =

2. Create user table
mix phx.gen.json Users User users account_id:references:accounts full_name:string gender:string biography:text
mix ecto.migrate

Create first account (in elixir shell):
iex(2)> RealDealApi.Accounts.create_account(%{email: "rkba1@proton.me", hash_password: "this is hashed"})
[debug] QUERY OK source="accounts" db=21.9ms decode=1.2ms queue=0.6ms idle=1183.9ms
INSERT INTO "accounts" ("email","hash_password","inserted_at","updated_at","id") VALUES ($1,$2,$3,$4,$5) ["rkba1@proton.me", "this is hashed", ~U[2024-10-28 00:33:58Z], ~U[2024-10-28 00:33:58Z], "43d0627b-1eec-4913-bc6e-5c3a0bfecadd"]
↳ :elixir.eval_external_handler/3, at: src/elixir.erl:386
{:ok,
%RealDealApi.Accounts.Account{
__meta__: #Ecto.Schema.Metadata<:loaded, "accounts">,
id: "43d0627b-1eec-4913-bc6e-5c3a0bfecadd",
email: "rkba1@proton.me",
hash_password: "this is hashed",
user: #Ecto.Association.NotLoaded<association :user is not loaded>,
inserted_at: ~U[2024-10-28 00:33:58Z],
updated_at: ~U[2024-10-28 00:33:58Z]
}}

Flow:
1. Create account in database:
    router.ex says for this endpoint call AccountController.create()
    post "/accounts/create", AccountController, :create

    conn is automatically passed into the controller action by Phoenix.
    The account struct comes from the body of the request.
    AccountController.create(conn, %{"account" => account_params}) calls
    Accounts.create_account(account_params) # creates account in database

2. Authenticate (get a jwt, requires email and password):
    Uses email and password to get a json web token.
    Returns token in response body.
     post "/accounts/sign_in", AccountController, :sign_in 

    AccountController.sign_in(conn, %{"email" => email, "hash_password" => hash_password}) calls
    Guardian.authenticate(email, password) calls
    Accounts.get_account_by_email(email) returns {:ok, account, token}

3. Protected Endpoints:
   Use the id from account in step 2 to access sensitive material.
    get "/accounts/by_id/:id", AccountController, :show

   AccountController.show(conn, %{"id" => id}) calls
   Accounts.get_account!(id)

    returns:
    {
       "token": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJyZWFsX2RlYWxfYXBpIiwiZXhwIjoxNzM1MzM2NzcxLCJpYXQiOjE3MzI5MTc1NzEsImlzcyI6InJlYWxfZGVhbF9hcGkiLCJqdGkiOiJhZGFjNjllMS01ZTQzLTQ1OWQtODAwZi03MTg0ZDg2ZWZjZDgiLCJuYmYiOjE3MzI5MTc1NzAsInN1YiI6ImJlYjcxM2ZlLTQ5ODItNDIyMS1hMjRkLWIwNTdhYWY5MmJlNiIsInR5cCI6ImFjY2VzcyJ9.4n8WuOkLJVCfwluz3PX4QZ8aIVHrkcEpa2SjlkWvTnqxe90ySrCFm0XWblonc_kvGDXyUDqsM-modEL6T6m1Qg",
       "account": {
       "id": "beb713fe-4982-4221-a24d-b057aaf92be6",
       "email": "client5@proton.me",
       "inserted_at": "2024-11-29T18:32:14Z",
       "updated_at": "2024-11-29T18:32:14Z"
       }
    }

4. 

    



Step 1. Create account:
    RealDealApiWeb.AccountController.create(conn, %{"account" => account_params}) calls
    RealDealApi.Accounts.create_account(attrs \\ %{}) attrs is %{email: "test1@proton.me", hash_password: "our_password"} calls
    RealDealApi.Accounts.Account.changeset(attrs) attrs is %{email: "test1@proton.me", hash_password: "our_password"} calls
    Ecto.Changeset.change(changeset, hash_password: Bcrypt.hash_pwd_salt(hash_password)) calls
    RealDealApi.Repo.insert()


    Example: 
    To create a new account, requires email and password:
    iex -S mix
    iex(11)> RealDealApi.Accounts.create_account(%{email: "test1@proton.me", hash_password: "our_password"})

    Hoppscotch - Uses AccountController.create/2:
    We provide the body, Hoppscotch adds conn.
    Don't use https:
    post http://localhost:4000/api/accounts/create
    body, quote everything:
    {
        "account": {
          "email": "client5@proton.me",
          "hash_password": "our_password5"
        }
    }

Step 2. Authenticate with email and password and get a json web token:
    RealDealApiWeb.Auth.Guardian.authenticate("test1@proton.me", "our_password")
    calls RealDealApi.Accounts.get_account_by_email(email) returns an account struct,
    representing an Account entity loaded from the accounts table in database as defined by 
    the RealDealApi.Accounts.Account module schema: %RealDealApi.Accounts.Account{}  
    then validate_password(password, account.hash_password)
    then create_token(account) which returns {:ok, account, token}


    Example:
    To authenticate and get a jwt, requires email and password:
    iex -S mix
    iex(12)> RealDealApiWeb.Auth.Guardian.authenticate("client5@proton.me", "our_password5")
    guardian.ex authenticating email: test1@proton.me, password: our_password
    [debug] QUERY OK source="accounts" db=6.2ms decode=2.5ms queue=1.3ms idle=672.7ms
    SELECT a0."id", a0."email", a0."hash_password", a0."inserted_at", a0."updated_at" FROM "accounts" AS a0 WHERE (a0."email" = $1) ["test1@proton.me"]
    ↳ RealDealApiWeb.Auth.Guardian.authenticate/2, at: lib/real_deal_api_web/auth/guardian.ex:15
    account: %RealDealApi.Accounts.Account{__meta__: #Ecto.Schema.Metadata<:loaded, "accounts">, id: "d671b809-0d36-4b75-8c1e-85f140ee0081", email: "test1@proton.me", hash_password: "$2b$12$M5KcYouCJZdhKKRs5tU6.edmfrn13cXn/WA.Bw.8xUSS8AfY43Cwu", user: #Ecto.Association.NotLoaded<association :user is not loaded>, inserted_at: ~U[2024-10-31 17:37:06Z], updated_at: ~U[2024-10-31 17:37:06Z]}
    {:ok,
    %RealDealApi.Accounts.Account{
    __meta__: #Ecto.Schema.Metadata<:loaded, "accounts">,
    id: "d671b809-0d36-4b75-8c1e-85f140ee0081",
    email: "test1@proton.me",
    hash_password: "$2b$12$M5KcYouCJZdhKKRs5tU6.edmfrn13cXn/WA.Bw.8xUSS8AfY43Cwu",
    user: #Ecto.Association.NotLoaded<association :user is not loaded>,
    inserted_at: ~U[2024-10-31 17:37:06Z],
    updated_at: ~U[2024-10-31 17:37:06Z]
    },
    "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJyZWFsX2RlYWxfYXBpIiwiZXhwIjoxNzM1MzIwNjcyLCJpYXQiOjE3MzI5MDE0NzIsImlzcyI6InJlYWxfZGVhbF9hcGkiLCJqdGkiOiIzOTdkYWQ5ZC0wZDVmLTQwZDAtODczYS04ZDQxYTJiODdjNTYiLCJuYmYiOjE3MzI5MDE0NzEsInN1YiI6ImQ2NzFiODA5LTBkMzYtNGI3NS04YzFlLTg1ZjE0MGVlMDA4MSIsInR5cCI6ImFjY2VzcyJ9.88Rw5fu5axIaXK4BpN6kbf1X824awWM_uubwRFhN8yvTwWr1nYLvqVx2fuiFRRv2cmRBhnswMRp_T3Noz2LEmQ"}

    Test with bad password:
    iex(13)> RealDealApiWeb.Auth.Guardian.authenticate("test1@proton.me", "our_passwod")
    authenticating email: test1@proton.me, password: our_passwod
    [debug] QUERY OK source="accounts" db=0.2ms idle=1063.7ms
    SELECT a0."id", a0."email", a0."hash_password", a0."inserted_at", a0."updated_at" FROM "accounts" AS a0 WHERE (a0."email" = $1) ["test1@proton.me"]
    ↳ RealDealApiWeb.Auth.Guardian.authenticate/2, at: lib/real_deal_api_web/auth/guardian.ex:36
    %RealDealApi.Accounts.Account{__meta__: #Ecto.Schema.Metadata<:loaded, "accounts">, id: "d671b809-0d36-4b75-8c1e-85f140ee0081", email: "test1@proton.me", hash_password: "$2b$12$M5KcYouCJZdhKKRs5tU6.edmfrn13cXn/WA.Bw.8xUSS8AfY43Cwu", user: #Ecto.Association.NotLoaded<association :user is not loaded>, inserted_at: ~U[2024-10-31 17:37:06Z], updated_at: ~U[2024-10-31 17:37:06Z]}
    {:error, :unauthorized}

    Hoppscotch - Uses AccountController.sign_in/2:
    We provide the body, Hoppscotch adds conn.
    Don't use https:
    post http://localhost:4000/api/accounts/sign_in
    body, quote everything:
    {
        "email": "client5@proton.me",
        "hash_password": "our_password5"
    }

    "account": {
        "id": "beb713fe-4982-4221-a24d-b057aaf92be6",
        "email": "client5@proton.me",
        "inserted_at": "2024-11-29T18:32:14Z",
        "updated_at": "2024-11-29T18:32:14Z"
    }

    token:
    eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJyZWFsX2RlYWxfYXBpIiwiZXhwIjoxNzM1MzM0MTU5LCJpYXQiOjE3MzI5MTQ5NTksImlzcyI6InJlYWxfZGVhbF9hcGkiLCJqdGkiOiIzMDk1NjY0ZC0xNDVlLTQ5NmItYWY1MS04N2FlYzUwNTkxMWYiLCJuYmYiOjE3MzI5MTQ5NTgsInN1YiI6ImJlYjcxM2ZlLTQ5ODItNDIyMS1hMjRkLWIwNTdhYWY5MmJlNiIsInR5cCI6ImFjY2VzcyJ9.ob75sbak67H7JgMC1i4ouAuNL6myHSh72e7FjjU90SIEoao-AHoOtr2S7-XDJ6kZWPs4qeXvs57UOlgVNPCYQw

3. Protected Endpoints
    Use the id from account to access protected endpoints.

    "account": {
       "id": "beb713fe-4982-4221-a24d-b057aaf92be6",
       "email": "client5@proton.me",
       "inserted_at": "2024-11-29T18:32:14Z",
       "updated_at": "2024-11-29T18:32:14Z"
    }


    Hoppscotch:
    get http://localhost:4000/api/accounts/by_id/beb713fe-4982-4221-a24d-b057aaf92be6
    No body

    {
        "error": "unauthenticated"
    }

    Need to add token to header or Authorization.
    {
    "token": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJyZWFsX2RlYWxfYXBpIiwiZXhwIjoxNzM1MzM2NzcxLCJpYXQiOjE3MzI5MTc1NzEsImlzcyI6InJlYWxfZGVhbF9hcGkiLCJqdGkiOiJhZGFjNjllMS01ZTQzLTQ1OWQtODAwZi03MTg0ZDg2ZWZjZDgiLCJuYmYiOjE3MzI5MTc1NzAsInN1YiI6ImJlYjcxM2ZlLTQ5ODItNDIyMS1hMjRkLWIwNTdhYWY5MmJlNiIsInR5cCI6ImFjY2VzcyJ9.4n8WuOkLJVCfwluz3PX4QZ8aIVHrkcEpa2SjlkWvTnqxe90ySrCFm0XWblonc_kvGDXyUDqsM-modEL6T6m1Qg",
    "account": {
        "id": "beb713fe-4982-4221-a24d-b057aaf92be6",
        "email": "client5@proton.me",
        "inserted_at": "2024-11-29T18:32:14Z",
        "updated_at": "2024-11-29T18:32:14Z"
        }
    }
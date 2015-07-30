defmodule Core.ChangesetView do
  use Core.Web, :view

  def render("error.json", %{session: session}) do
    %{errors: render_errors(session)}
  end

  def render("error.json", %{changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    %{errors: changeset}
  end

  def render_errors(session) do
    session.errors 
    |> Enum.map(&hashify/1)
  end

  def hashify({key, error}) do
    %{"key" => key, "msg" => error}
  end

end

defmodule WishlistBeWeb.ChangesetJSON do
  @doc """
  Renders changeset errors.
  """
  def error(%{changeset: changeset}) do
    %{errors: translate_errors(changeset)}
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  defp translate_error({msg, _opts}) do
    # Customize this function to translate errors as needed
    Phoenix.Naming.humanize(msg)
  end
end

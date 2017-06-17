defmodule LifeApp.Web do
  def view do
    quote do
      use Phoenix.View, root: "web/templates"
      import LifeApp.Router.Helpers
      use Phoenix.HTML
    end
  end

  def controller do
    quote do
      use Phoenix.Controller
      import LifeApp.Router.Helpers
    end
  end

  def model do
    quote do
      use Ecto.Model
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
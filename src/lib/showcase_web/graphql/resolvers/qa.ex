defmodule ShowcaseWeb.Resolvers.QA do
  alias Showcase.{
    QA
  }

  def questions(_, args, info) do
    results =
      :questions
      |> getset_params(args)
      |> QA.list_questions(info)

    {:ok, results}
  end

  def answers(_, args, info) do
    results =
      :answers
      |> getset_params(args)
      |> QA.list_answers(info)

    {:ok, results}
  end

  def answers_for_question(source, key) do
    QA.answers_for_question(source, key)
  end

  # called from user object
  def questions_for_users(user, args, _) do
    new_args = getset_params(:questions, args)
    {:ok, QA.questions_for_user(user, new_args)}
  end

  def questions_for_user(map_user, args, info) do
    user = map_user.user
    questions_for_users(user, args, info)
  end

  def answers_for_users(user, args, _) do
    new_args = getset_params(:answers, args)
    {:ok, QA.answers_for_user(user, new_args)}
  end

  def answers_for_user(map_user, args, info) do
    user = map_user.user
    answers_for_users(user, args, info)
  end

  def get_default_params(:questions), do: %{limit: 5, offset: 0}
  def get_default_params(:answers), do: %{limit: 5, offset: 0}

  def set_default_params(set_params, args) do
    set_params
    |> Enum.reduce(args, fn {key, value}, acc ->
      Map.put_new(acc, key, value)
    end)
  end

  defp getset_params(key, args) do
    key
    |> get_default_params()
    |> set_default_params(args)
  end
end

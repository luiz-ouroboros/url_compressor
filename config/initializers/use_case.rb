class UseCase < Micro::Case
  def build_error(field, message)
    { field => [I18n.t("#{message}")] }
  end
end

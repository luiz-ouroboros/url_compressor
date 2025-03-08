module Types
  include Dry.Types()

  StringUntil255 = Types::Coercible::String.constrained(max_size: 255)
  I18nDateTime = Types::String.constrained(format: I18n.t('regexp.datetime'))
  I18nDate = Types::String.constrained(format: I18n.t('regexp.date'))
  URL = Types::String.constrained(format: URI::DEFAULT_PARSER.make_regexp(['http', 'https']))
end

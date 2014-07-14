class Quote
  include Mongoid::Document

  field :text, type: String
  field :answer, type: String
  field :tags, type: Array
end
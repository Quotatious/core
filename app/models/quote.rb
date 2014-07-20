class Quote
  include Mongoid::Document

  field :text, type: String
  field :answers, type: Hash
  field :categories, type: Array
end
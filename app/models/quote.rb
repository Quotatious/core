class Quote
  include Mongoid::Document

  has_many :games

  field :text, type: String
  field :answers, type: Hash
  field :categories, type: Array
  field :random_point, type: Array, default: [Random::rand, Random::rand]

  index({ random_point: '2d' }, { name: "Quote 2d random index" })
end
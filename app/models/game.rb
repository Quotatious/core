class Game
  include Mongoid::Document

  belongs_to :user
  belongs_to :quote

  field :text, type: String
  field :answers, type: Array
  field :category, type: String
  field :answer_type, type: String, default: nil
  field :answer_text, type: String, default: nil
  field :status, type: String, default: 'awaiting_answer'

end
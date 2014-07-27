module Quotatious
  module V1
    class Root < Grape::API
      prefix 'v1'
      mount Quotatious::V1::Quotes
      mount Quotatious::V1::Users
      mount Quotatious::V1::Games
    end
  end
end

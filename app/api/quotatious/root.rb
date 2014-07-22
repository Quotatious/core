module Quotatious
  class Root < Grape::API
    mount Quotatious::V1::Root
  end
end
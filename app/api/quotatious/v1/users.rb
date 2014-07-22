module Quotatious
  module V1
    class Users < Grape::API
      version 'v1', using: :header, vendor: 'quotatious'
      format :json

      resource :users do
        desc "Create a user."
        params do
          requires :email, type: String, desc: "The user's email."
          requires :username, type: String, desc: "The username."
          requires :password, type: String, desc: "The user's password."
        end
        post do
          if User.where({email: params[:email]}).exists?
            error!({error: :EmailNonUnique}, 500)
          elsif User.where({username: params[:username]}).exists?
            error!({error: :UsernameNonUnique}, 500)
          end

          User.create({
                          email: params[:email],
                          username: params[:username],
                          password: BCrypt::Password.create(params[:password], :cost => 8),
                      })
        end
      end
    end
  end
end
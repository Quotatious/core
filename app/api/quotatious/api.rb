module Quotatious
  class API < Grape::API
    version 'v1', using: :header, vendor: 'quotatious'
    format :json

    resource :quotes do
      desc "Return Quotes."
      get :random do
        Quote.limit(20)
      end

      desc "Return a quote."
      params do
        requires :id, type: String, desc: "Quote id."
      end
      route_param :id do
        get do
          begin
          Quote.find(params[:id])
          rescue Mongoid::Errors::DocumentNotFound => e
            error!({error: :DocumentNotFound}, 500)
          end
        end
      end

      desc "Create a quote."
      params do
        requires :text, type: String, desc: "The quote."
        requires :answers, type: Hash, desc: "The anwsers."
        requires :categories, type: Array, desc: "Categories."
      end
      post do
        Quote.create({
                              text: params[:text],
                              answers: params[:answers],
                              categories: params[:categories],
                          })
      end

      desc "Update a Quote."
      params do
        requires :id, type: String, desc: "Quote ID."
        requires :text, type: String, desc: "Your quote."
        requires :answers, type: Hash, desc: "The anwsers."
        requires :categories, type: Array, desc: "Categories."
      end
      put ':id' do
        begin
        Quote.find(params[:id]).update({
                                           text: params[:text],
                                           answers: params[:answers],
                                           categories: params[:categories],
                                       })
        rescue Mongoid::Errors::DocumentNotFound => e
          error!({error: :DocumentNotFound}, 500)
        end
      end

      desc "Delete a Quote."
      params do
        requires :id, type: String, desc: "Quote ID."
      end
      delete do
        begin
          Quote.find(params[:id]).destroy
          {success: 'true'}
        rescue Mongoid::Errors::DocumentNotFound => e
          error!({error: :DocumentNotFound}, 500)
        end
      end
    end
  end
end
module Quotalitious
  class API < Grape::API
    version 'v1', using: :header, vendor: 'quotalitious'
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
          Quote.find(params[:id])
        end
      end

      desc "Create a quote."
      params do
        requires :text, type: String, desc: "The quote."
        requires :answer, type: String, desc: "The anwser."
        requires :tags, type: Array, desc: "Tags."
      end
      post do
        quote = Quote.new({
                              text: params[:text],
                              answer: params[:answer],
                          })
        quote.push(tags: params[:tags])

        quote.insert()
      end

      desc "Update a Quote."
      params do
        requires :id, type: String, desc: "Quote ID."
        requires :text, type: String, desc: "Your quote."
        requires :answer, type: String, desc: "The anwser."
        requires :tags, type: Array, desc: "Tags."
      end
      put ':id' do
        Quote.find(params[:id]).update({
                                           text: params[:text],
                                           answer: params[:answer],
                                           tags: params[:tags]
                                       })
      end

      desc "Delete a Quote."
      params do
        requires :id, type: String, desc: "Quote ID."
      end
      delete do
        begin
          Quote.find(params[:id]).destroy
          {success: 'true'}
        rescue Exception => e
          {
              success: 'false',
              error: e.as_json
          }
        end
      end
    end
  end
end
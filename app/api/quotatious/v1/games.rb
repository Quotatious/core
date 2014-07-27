module Quotatious
  module V1
    class Games < Grape::API
      version 'v1', using: :header, vendor: 'quotatious'
      format :json

      http_basic do |email, password|
        @user = User::where({email: email}).first
        @user && BCrypt::Password.new(@user.password) == password
      end

      resource :games do
        desc "Create a game."
        params do
          requires :category, type: String, desc: "Category name."
        end
        post do
          quote = Quote.in(categories: params[:category]).near(random_point: [Random.rand, Random.rand]).first
          error!({error: :CategoryNotFound}, 500) unless quote

          answers = Quote.near(random_point: [Random.rand, Random.rand])
          .in(categories: params[:category])
          .ne(_id: quote._id)
          .limit(3)
          .pluck('answers')

          Game.create({
                          user: @user,
                          text: quote.text,
                          quote: quote,
                          answers: [quote.answers].concat(answers),
                          category: params[:category]
                      })
        end

        desc "Answer a game."
        params do
          requires :game_id, type: String, desc: "game id."
          requires :answer_text, type: String, desc: "answer text."
          requires :answer_type, type: String, desc: "answer type."
        end
        post :answer do
          game = Game.where(_id: params[:game_id]).first
          error!({error: :CategoryNotFound}, 500) unless game
          error!({error: :GameDone}, 500) unless game.status === 'awaiting_answer'

          if game.quote.answers[params[:answer_type]] === params[:answer_text]
            game.status = 'won'
            game.user.score = game.user.score + 1
            game.user.save
          else
            game.status = 'lost'
          end

          game.save

          {valid_answer: game.status === 'won', user_score: game.user.score}
        end

        desc "Get the user's score."
        get :score do
          {user_score: @user.score}
        end

        desc "Get the categories."
        get :categories do
          {categories: Quote.all.distinct('categories')}
        end
      end
    end
  end
end
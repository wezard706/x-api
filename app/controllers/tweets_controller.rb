# frozen_string_literal: true

class TweetsController < AuthenticatedController
  def create
    tweet = Tweet.new(tweet_params)
    tweet.save!

    head :created
  end

  private

  def tweet_params
    params.require(:tweet).permit(:content).merge({
                                                    user: current_user
                                                  })
  end
end

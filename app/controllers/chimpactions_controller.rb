class ChimpactionsController < ApplicationController
  def index
    @actions  = Chimpactions.actions
    @registered  = Chimpactions.registered_class
    @ar_actions = Chimpaction.all
  end
end
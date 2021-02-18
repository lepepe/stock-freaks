class StocksController < ApplicationController
  before_action :set_stock, only: [:show]
  def index
    @stocks = Stock.all
  end

  def show
    @mentions = @stock.mention.order(dt: :desc)
    @three_bar_breakout = @stock.three_bar_breakout
  end

  private
    def set_stock
      @stock = Stock.find_by(symbol: params[:id])
    end
end

class StocksController < ApplicationController
  include ApplicationHelper

  before_action :set_stock, only: [:show]
  def index
    @stocks = Stock.all
  end

  def show
    @mentions = @stock.mention.order(dt: :desc)

    require 'uri'
    require 'net/http'
    require 'openssl'

    url = URI("https://api.stocktwits.com/api/2/streams/symbol/#{@stock.symbol}.json")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["cookie"] = '__cfduid=dad9412d12cd60c48c433e782b78e68421613496927; session_visits_count=1'

    response = http.request(request)
    stocktwits =  JSON.parse(response.read_body).with_indifferent_access
    @stocktwits = stocktwits[:messages]
  end

  def engulfing_pattern_action
    @engulfing_pattern = Stock.find_by_sql("
      SELECT
        a.day,
        a.open,
        a.close,
        a.stock_id,
        a.symbol,
        a.name,
        a.previous_close,
        a.previous_open,
        a.volume
      FROM
        (
          SELECT
            daily_bars.day,
            daily_bars.open,
            daily_bars.close,
            daily_bars.stock_id,
            stock.symbol,
            stock.name,
            lag(daily_bars.close, 1) OVER (
              PARTITION BY daily_bars.stock_id
              ORDER BY
                daily_bars.day
            ) AS previous_close,
            lag(daily_bars.open, 1) OVER (
              PARTITION BY daily_bars.stock_id
              ORDER BY
                daily_bars.day
            ) AS previous_open,
            daily_bars.volume
          FROM
            daily_bars
            JOIN stock ON stock.id = daily_bars.stock_id
        ) a
      WHERE
        a.previous_close < a.previous_open
        AND a.close > a.previous_open
        AND a.open < a.previous_close
        AND a.day = '#{time_now_zone_to_date}'
        AND a.close < 10;
    ")
  end

  def three_bar_breakout_action
    @three_bar_breakout = Stock.find_by_sql("
      SELECT
        a.day,
        a.close,
        a.volume,
        a.stock_id,
        a.symbol,
        a.previous_close,
        a.previous_volume,
        a.previous_previous_close,
        a.previous_previous_volume,
        a.previous_previous_previous_close,
        a.previous_previous_previous_volume
      FROM
        (
          SELECT
            daily_bars.day,
            stock.symbol,
            daily_bars.close,
            daily_bars.volume,
            daily_bars.stock_id,
            lag(daily_bars.close, 1) OVER (
              PARTITION BY daily_bars.stock_id
              ORDER BY
                daily_bars.day
            ) AS previous_close,
            lag(daily_bars.volume, 1) OVER (
              PARTITION BY daily_bars.stock_id
              ORDER BY
                daily_bars.day
            ) AS previous_volume,
            lag(daily_bars.close, 2) OVER (
              PARTITION BY daily_bars.stock_id
              ORDER BY
                daily_bars.day
            ) AS previous_previous_close,
            lag(daily_bars.volume, 2) OVER (
              PARTITION BY daily_bars.stock_id
              ORDER BY
                daily_bars.day
            ) AS previous_previous_volume,
            lag(daily_bars.close, 3) OVER (
              PARTITION BY daily_bars.stock_id
              ORDER BY
                daily_bars.day
            ) AS previous_previous_previous_close,
            lag(daily_bars.volume, 3) OVER (
              PARTITION BY daily_bars.stock_id
              ORDER BY
                daily_bars.day
            ) AS previous_previous_previous_volume
          FROM
            daily_bars
            JOIN stock ON stock.id = daily_bars.stock_id
        ) a
      WHERE
        a.close > a.previous_previous_previous_close
        AND a.previous_close < a.previous_previous_close
        AND a.previous_close < a.previous_previous_previous_close
        AND a.volume > a.previous_volume
        AND a.previous_volume < a.previous_previous_volume
        AND a.previous_previous_volume < a.previous_previous_previous_volume
        AND a.day = '#{time_now_zone_to_date}'
        AND a.close < 10;
    ")
  end

  private
    def set_stock
      @stock = Stock.find_by(symbol: params[:id])
    end
end

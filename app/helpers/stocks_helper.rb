module StocksHelper

  def moving_ave_20_day(stock_id)
    Stock.find_by_sql("
      SELECT
        avg(close)
      FROM
        (
          SELECT *
          FROM daily_bars
          WHERE stock_id = #{stock_id}
          ORDER BY day
          DESC LIMIT 2011
        ) a;
    ")
  end

  def high_close(stock_id)
    Stock.find_by_sql("
      SELECT max(high) FROM stock_price WHERE stock_id = #{stock_id}
    ")
  end

  def low_close(stock_id)
    Stock.find_by_sql("
      SELECT min(low) FROM stock_price WHERE stock_id = #{stock_id}
    ")
  end
end

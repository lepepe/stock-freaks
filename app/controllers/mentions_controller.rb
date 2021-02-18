class MentionsController < ApplicationController
  def index
    @mentions = Mention.find_by_sql("
      SELECT
        count(m.stock_id) AS count,
        s.symbol,
        s.name
      FROM
        mention m
        JOIN stock s ON m.stock_id = s.id
      GROUP BY
        s.symbol,
        s.name
      ORDER BY
        (count(m.stock_id)) DESC;
    ")
  end
end

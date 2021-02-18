class Stock < ApplicationRecord
  self.table_name  = 'stock'
  self.primary_key = 'id'

  has_many :mention
  has_many :three_bar_breakout
  has_many :engulfing_pattern

  def to_param
    symbol
  end
end

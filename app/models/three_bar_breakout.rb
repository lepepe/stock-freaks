class ThreeBarBreakout < ApplicationRecord
  self.table_name  = 'three_bar_breakout'
  self.primary_key = 'stock_id'

  belongs_to :stock
end

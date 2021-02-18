class EngulfingPattern < ApplicationRecord
  self.table_name  = 'bullish_pattern'
  self.primary_key = 'stock_id'

  belongs_to :stock
end

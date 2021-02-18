class DailyBars < ApplicationRecord
  self.table_name  = 'daily_bars'
  self.primary_key = 'stock_id'

  has_many :mention 
  belongs_to :stocks
end

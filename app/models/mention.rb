class Mention < ApplicationRecord
  self.table_name  = 'mention'
  self.primary_key = 'stock_id'

  belongs_to :stock
end

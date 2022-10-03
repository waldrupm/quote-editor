# == Schema Information
#
# Table name: quotes
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Quote < ApplicationRecord
  has_many :line_item_dates, dependent: :destroy
  belongs_to :company

  validates :name, presence: true

  scope :ordered, -> { order(id: :desc) }
  
  # after_create_commit -> { broadcast_prepend_later_to "quotes" }
  # after_update_commit -> { broadcast_replace_later_to "quotes" }
  # after_destroy_commit -> { broadcast_remove_to "quotes" }
  # Those three callbacks are equivalent to the following single line
  broadcasts_to ->(quote) { [quote.company, "quotes"] }, inserts_by: :prepend
  # [quote.company, "quotes"] allows the lambda to return unique values for the channel names, scoped to company, preventing broadcasting to other companies
end

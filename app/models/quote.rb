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
  belongs_to :company

  validates :name, presence: true

  scope :ordered, -> { order(id: :desc) }
  
  # after_create_commit -> { broadcast_prepend_later_to "quotes" }
  # after_update_commit -> { broadcast_replace_later_to "quotes" }
  # after_destroy_commit -> { broadcast_remove_to "quotes" }
  # Those three callbacks are equivalent to the following single line
  broadcasts_to ->(quote) { "quotes" }, inserts_by: :prepend
end

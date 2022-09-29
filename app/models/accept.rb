class Accept < ApplicationRecord
  belongs_to :top_trump
  belongs_to :user

  after_create do
    top_trump.try_update_trick
  end

end

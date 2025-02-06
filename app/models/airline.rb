# Airline Model
class Airline < ApplicationRecord
  has_many :reviews

  # Run callback before validations are checked
  before_validation :slugify

  def slugify
    # Example: United Airlines -> united-airlines
    self.slug = name.parameterize if name.present? && slug.blank
  end

  def avg_score
    reviews.average(:score).round(2).to_f
  end
end

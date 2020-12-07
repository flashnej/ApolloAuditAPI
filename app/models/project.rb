class Project < ApplicationRecord
    validates :name, presence: true
    validates :auditor, presence: true

    has_many :line_items
  end
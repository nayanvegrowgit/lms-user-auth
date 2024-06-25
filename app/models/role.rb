class Role < ApplicationRecord
  validates :name, presence: true , uniqueness: true
  validates :name, acceptance: { accept: ['member', 'librarian', 'admin'] }
end

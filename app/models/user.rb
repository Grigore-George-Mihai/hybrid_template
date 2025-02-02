# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :jwt_authenticatable,
         jwt_revocation_strategy: self

  enum :role, { user: 0, admin: 1 }, validate: true

  validates :first_name, :last_name, :email, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[first_name last_name email role]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  def password_required?
    new_record? || password.present? || password_confirmation.present?
  end
end

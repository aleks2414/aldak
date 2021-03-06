class Charter < ApplicationRecord
 
  default_scope { where(user_id: User.current.company.users.pluck(:id)) }

  belongs_to :user
  has_many :services
  has_many :charter_payments, dependent: :destroy

  enum status: %w( Saldo_en_Contra Saldo_a_Favor )

  def balance
    c1 = charter_payments.map(&:cantidad).sum
    c2 = services.map(&:fletera).sum
    c1 - c2
  end

  def set_status
    balance <= 0 ? 'Saldo_en_Contra' : 'Saldo_a_Favor'
  end
end

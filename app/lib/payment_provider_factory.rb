# frozen_string_literal: true

class PaymentProviderFactory
  class Provider
    def debit_card(user) end
  end
  def self.provider
    @provider ||= Provider.new
  end
end

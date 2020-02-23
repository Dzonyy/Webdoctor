# frozen_string_literal: true

class PaymentsController < ApplicationController
  def create
    @message = Message.create(body: "I've lost my script, please issue a new one at a charge of €10", outbox: Outbox.find_by(user_id: params[:user_id]), inbox: Inbox.find_by(user_id: User.default_admin))
    PaymentProviderFactory.provider.debit_card(User.current)
    @payment = Payment.create(user_id: params[:user_id])
    if @payment.save
      redirect_to root_path
    else
      puts yoo
    end
  end
end

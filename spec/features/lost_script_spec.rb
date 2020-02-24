# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Lost script', type: :feature do
  let!(:patient) { User.create(first_name: 'Luke', last_name: 'Skywalker', inbox: Inbox.new, outbox: Outbox.new) }
  let!(:doctor) { User.create(first_name: 'Leia', last_name: 'Organa', is_doctor: true, is_patient: false, inbox: Inbox.new, outbox: Outbox.new) }
  let!(:admin) { User.create(first_name: 'Obi-wan', last_name: 'Kenobi', is_admin: true, is_patient: false, inbox: Inbox.new, outbox: Outbox.new) }
  let!(:message) do
    Message.create(body: 'Thanks for your order. I will in touch shortly after reviewing your treatment application.',
                   outbox: doctor.outbox,
                   inbox: patient.inbox)
  end

  scenario 'Get new prescription send msg to admin' do
    visit "/messages/#{message.id}"

    find('.btn-prescription').click
    expect(Message.last.inbox.id).to be(admin.inbox.id)
  end

  scenario 'Get new prescription create new payment' do
    expect do
      visit "/messages/#{message.id}"

      find('.btn-prescription').click
    end.to change { Payment.all.count}.by(1)
  end

  scenario 'Get new prescription will make API call' do
    expect_any_instance_of(PaymentProviderFactory::Provider).to receive(:debit_card)
    visit "/messages/#{message.id}"

    find('.btn-prescription').click
  end

  scenario 'Get new prescription API call fails' do
    allow_any_instance_of(PaymentProviderFactory::Provider).to receive(:debit_card).and_raise('Invalid amount')
    visit "/messages/#{message.id}"

    find('.btn-prescription').click
  end
end


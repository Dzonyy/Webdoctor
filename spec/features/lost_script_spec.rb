# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Lost script', type: :feature do
  let(:patient) { User.create(first_name: 'Luke', last_name: 'Skywalker', inbox: Inbox.new, outbox: Outbox.new) }
  let(:doctor) { User.create(first_name: 'Leia', last_name: 'Organa', is_doctor: true, is_patient: false, inbox: Inbox.new, outbox: Outbox.new) }
  let(:admin) { User.create(first_name: 'Obi-wan', last_name: 'Kenobi', is_admin: true, is_patient: false, inbox: Inbox.new, outbox: Outbox.new) }
  let(:message) do
    Message.create(body: 'Thanks for your order. I will in touch shortly after reviewing your treatment application.',
                   outbox: Outbox.find_by(user_id: doctor),
                   inbox: Inbox.find_by(user_id: patient))
  end

  scenario 'Get new prescription' do
    visit '/messages/1'

    find('.btn-prescription').click
    expect(page).to have_selector 'h6'
  end
end

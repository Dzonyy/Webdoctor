# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Replying message', type: :feature do
  let(:patient) { User.create(first_name: 'Luke', last_name: 'Skywalker', inbox: Inbox.new, outbox: Outbox.new) }
  let(:doctor) { User.create(first_name: 'Leia', last_name: 'Organa', is_doctor: true, is_patient: false, inbox: Inbox.new, outbox: Outbox.new) }
  let(:admin) { User.create(first_name: 'Obi-wan', last_name: 'Kenobi', is_admin: true, is_patient: false, inbox: Inbox.new, outbox: Outbox.new) }
  let(:message) do
    Message.create(body: 'Thanks for your order. I will in touch shortly after reviewing your treatment application.',
                   outbox: Outbox.find_by(user_id: doctor),
                   inbox: Inbox.find_by(user_id: patient))
  end

  scenario 'Reply' do
    visit '/message/new/1'

    within('#new_message') do
      fill_in 'message_body', with: 'Test msg'
    end
    find('#new_message input[type=submit]').click
    expect(Message.last.read).to be false
    # expect(Message.last.outbox_id).to be @doctor.outbox
    # expect(Message.last.inbox_id).to be @patient.inbox
  end
end

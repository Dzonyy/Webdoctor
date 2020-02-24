# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Replying message', type: :feature do
  let!(:patient) { User.create(first_name: 'Luke', last_name: 'Skywalker', inbox: Inbox.new, outbox: Outbox.new) }
  let!(:doctor) { User.create(first_name: 'Leia', last_name: 'Organa', is_doctor: true, is_patient: false, inbox: Inbox.new, outbox: Outbox.new) }
  let!(:admin) { User.create(first_name: 'Obi-wan', last_name: 'Kenobi', is_admin: true, is_patient: false, inbox: Inbox.new, outbox: Outbox.new) }
  let!(:message) do
    Message.create(body: 'Thanks for your order. I will in touch shortly after reviewing your treatment application.',
                   outbox: doctor.outbox,
                   inbox: patient.inbox)
  end
  let!(:message2) do
    Message.create(body: 'Thanks for your order. I will in touch shortly after reviewing your treatment application.',
                   created_at: 8.days.ago,
                   outbox: doctor.outbox,
                   inbox: patient.inbox)
  end

  scenario 'Check message status after create' do
    visit "/message/new/#{message.id}"

    within('#new_message') do
      fill_in 'message_body', with: 'Test msg'
    end
    find('#new_message input[type=submit]').click
    expect(Message.last.read).to be_falsey
  end

  scenario 'Check message outbox and inbox' do
    visit "/message/new/#{message.id}"

    within('#new_message') do
      fill_in 'message_body', with: 'Test msg'
    end
    find('#new_message input[type=submit]').click
    expect(Message.last.inbox.id).to be(doctor.inbox.id)
    expect(Message.last.outbox.id).to be(patient.outbox.id)
  end

  scenario 'Check message older than week outbox and inbox' do
    visit "/message/new/#{message2.id}"

    within('#new_message') do
      fill_in 'message_body', with: 'Test msg'
    end
    find('#new_message input[type=submit]').click
    expect(Message.last.inbox.id).to be(admin.inbox.id)
    expect(Message.last.outbox.id).to be(patient.outbox.id)
  end
end

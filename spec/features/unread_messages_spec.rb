require 'rails_helper'

RSpec.feature 'Replying message', type: :feature do
  let!(:patient) { User.create(first_name: 'Luke', last_name: 'Skywalker', inbox: Inbox.new, outbox: Outbox.new) }
  let!(:doctor) { User.create(first_name: 'Leia', last_name: 'Organa', is_doctor: true, is_patient: false, inbox: Inbox.new, outbox: Outbox.new) }
  let!(:admin) { User.create(first_name: 'Obi-wan', last_name: 'Kenobi', is_admin: true, is_patient: false, inbox: Inbox.new, outbox: Outbox.new) }
  let!(:message) do
    Message.create(body: 'Thanks for your order. I will in touch shortly after reviewing your treatment application.',
                   inbox: doctor.inbox,
                   outbox: patient.outbox)
  end
  let!(:message2) do
    Message.create(body: 'Thanks for your order. I will in touch shortly after reviewing your treatment application.',
                   outbox: doctor.outbox,
                   inbox: patient.inbox)
  end


  scenario 'Check increment of unread messages' do
    expect do
      visit "/message/new/#{message2.id}"

      within('#new_message') do
        fill_in 'message_body', with: 'Test msg'
      end
      find('#new_message input[type=submit]').click
    end.to change { doctor.inbox.reload.unread_messages }.by(1)
  end

  scenario 'Check decrement of unread messages' do
    allow(User).to receive(:current).and_return(doctor)
    expect do
      visit "/"
      find(".message-#{message.id}").click
    end.to change { doctor.inbox.reload.unread_messages }.by(-1)
  end
end

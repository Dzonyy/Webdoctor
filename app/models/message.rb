# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :inbox
  belongs_to :outbox
  after_commit :increment_unread_messages, on: :create

  def increment_unread_messages
    inbox.unread_messages += 1
    inbox.save
  end

  def decrement_unread_messages
    inbox = Inbox.find(outbox.id)
    inbox.unread_messages -= 1
    inbox.save
  end
end

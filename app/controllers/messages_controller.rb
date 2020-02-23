# frozen_string_literal: true

class MessagesController < ApplicationController
  def show
    @message = Message.find(params[:id])
    # render json: @message
    if @message.read == false
      @message.decrement_unread_messages
      @message.read = true
      @message.save
    end
  end

  def new
    @message = Message.new
  end

  def create
    old_message = Message.find_by(id: params[:reply]) if params[:reply].present?
    @message = Message.new(message_params)
    @message.outbox = Outbox.find_by(user_id: User.current)
    @message.inbox = if old_message.created_at < 7.days.ago
                       Inbox.find_by(user_id: User.default_admin)
                     else
                       Inbox.find_by(user_id: User.default_doctor)
                     end
    if @message.save
      redirect_to root_path
    else
      render 'new'
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :inbox, :outbox)
  end
end

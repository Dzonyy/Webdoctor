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
    @message.outbox = User.current.outbox
    @message.inbox = if old_message.created_at < 7.days.ago
                       User.default_admin.inbox
                     else
                       User.default_doctor.inbox
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

# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Lost script', type: :feature do
  scenario 'Reply' do
    visit '/message/new/1'

    within('#new_message') do
      fill_in 'message_body', with: 'Test msg'
    end
    find('#new_message input[type=submit]').click
    expect(page).to have_selector ''
  end
end

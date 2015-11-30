require 'rails_helper'

feature 'feed' do
  image_0_name = 'feature_spec_img.png'

  scenario 'display the welcome message' do
    visit '/'
    expect(page).to have_content('Filterspam')
  end

  context 'User is not signed in' do
    scenario 'display login prompt' do
      visit '/'
      expect(page).to have_current_path(user_session_path)
    end
  end

  context 'User is signed in' do
    user_0_email = 'user0@users.com'
    before do
      sign_up_and_sign_in(email: user_0_email)
    end
    scenario 'display the sign out link' do
      expect(page).to have_link 'Sign out'
    end

    context 'no filterspams have been posted' do
      scenario 'display prompt to add filterspam' do
        visit '/'
        expect(page).to have_content('No filterspams :(')
        expect(page).to have_link('Add filterspam')
      end
      context 'creating filterspams' do
        comment_0 = 'The defective force maintains the drink.'
        scenario 'prompt user to fill out form, then display new filterspam' do
          visit '/'
          click_link 'Add filterspam'
          fill_in 'Comment', with: comment_0
          attach_file 'Image', Rails.root.join("spec/features/#{image_0_name}")
          click_button 'Create Filterspam'
          expect(page).to have_content(comment_0)
          expect(page).to have_css("img[src*='#{image_0_name}']")
        end
      end
    end

    context 'filterspam has been posted' do
      comment_0 = 'The fierce order heads the sign.'
      comment_1 = 'The credit triples the experience.'
      user_1_email = 'user_1@users.com'
      before do
        user_1 = User.create( email: user_1_email,
                              password: 'password',
                              password_confirmation: 'password')
        image_0 = File.new(Rails.root.join('spec/features',image_0_name), 'rb')
        params = { comment: comment_0, image: image_0, user: user_1 }
        filterspam_0 = Filterspam.create(params)
      end
      scenario 'display filterspams' do
        visit '/'
        expect(page).to have_content("By: #{user_1_email}")
        expect(page).to have_content(comment_0)
        expect(page).to have_css("img[src*='#{image_0_name}']")
        expect(page).not_to have_content('No filterspams :(')
      end
      context 'deleting filterspams' do
        scenario 'delete a filterspam' do
          visit '/'
          click_link 'Delete'
          expect(page).not_to have_content(comment_0)
          expect(page).not_to have_css("img[src*='#{image_0_name}']")
          expect(page).to have_content('No filterspams :(')
        end
      end
      context 'adding comments' do
        scenario 'add comment' do
          visit '/'
          click_link 'Comment'
          fill_in 'Comment', with: comment_1
          click_button 'Create Comment'
          expect(page).to have_content(comment_1)
        end
      end
      context 'adding likes' do
        scenario 'add like' do
          visit '/'
          click_link 'Like'
          expect(page).to have_content "#{user_0_email} likes this"
        end
      end
    end

  end
end

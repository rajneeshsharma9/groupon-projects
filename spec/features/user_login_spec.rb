require 'rails_helper'

describe 'the login process', type: :feature do
  let(:user) { FactoryBot.create(:admin) }
  before { visit '/login' }
  context 'with valid email and password' do
    before do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Login'
    end
    it 'signs me in' do
      expect(page).to have_content 'Logged In'
    end
  end
  context 'with invalid email and password' do
    before do
      fill_in 'Email', with: 'wrw@rfwrf.com'
      fill_in 'Password', with: 'wdwrf'
      click_button 'Login'
    end
    it 'does not sign me in' do
      expect(page).to have_content 'Invalid email'
    end
  end
  context 'with blank email and password' do
    before do
      fill_in 'Email', with: ''
      fill_in 'Password', with: ''
      click_button 'Login'
    end
    it 'does not sign me in' do
      expect(page).to have_content 'Invalid email'
    end
  end
  context 'with valid email and invalid password' do
    before do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: ''
      click_button 'Login'
    end
    it 'gives wrong password error' do
      expect(page).to have_content 'Password is wrong'
    end
  end
end


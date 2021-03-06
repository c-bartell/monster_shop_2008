require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')

      within 'nav' do
        click_link 'Cart: '
      end

      expect(current_path).to eq('/cart')

      within 'nav' do
        click_link 'Register New User'
      end

      expect(current_path).to eq('/register')

      within 'nav' do
         click_link 'Home Page'
      end

      expect(current_path).to eq('/home')

      within 'nav' do
        click_link 'User Log In'
      end

      expect(current_path).to eq('/login')
    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

    end
  end
  describe 'As a User' do
    it "shows same links as visitor plus profile page link and logout link" do
      kiera = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password')

      visit '/login'

      fill_in :email, with: kiera.email
      fill_in :password, with: kiera.password

      click_button 'Login'

      within 'nav' do
        expect(page).to have_link("#{kiera.name}'s Profile")
        expect(page).to have_link("Logout")
        expect(page).to_not have_link("User Log In")
        expect(page).to_not have_link("Register New User")
        expect(page).to have_content("Logged in as #{kiera.name}")
      end
    end
  end

  describe 'As a Merchant' do
    it "shows same links as users plus dashboard link" do
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      kiera = bike_shop.users.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password', role: 1)

      visit '/login'

      fill_in :email, with: kiera.email
      fill_in :password, with: kiera.password

      click_button 'Login'

      within 'nav' do
        expect(page).to have_link("Merchant's Dashboard")
      end
    end
  end

  describe 'As a Admin' do
    it "shows same links as users plus dashboard link and all users" do
      kiera = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password', role: 2)

      visit '/login'

      fill_in :email, with: kiera.email
      fill_in :password, with: kiera.password

      click_button 'Login'

      within 'nav' do
        expect(page).to have_link("Admin's Dashboard")
        expect(page).to have_link("Users")
      end
    end
  end

  describe 'As a visitor' do
    it "When I try to access any path that begins with the following, then I see a 404 error:" do

      visit "/merchant"
      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit "/admin"
      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit "/profile"
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end

  describe 'As a user' do
    it "When I try to access any path that begins with the following, then I see a 404 error:" do
      kiera = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password')

      visit '/login'

      fill_in :email, with: kiera.email
      fill_in :password, with: kiera.password

      click_button 'Login'

      visit "/merchant"
      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit "/admin"
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end

  describe 'As a merchant' do
    it "When I try to access any path that begins with the following, then I see a 404 error:" do
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      sally = bike_shop.users.create!(name: 'Sally Peach', address: '432 Grove St.', city: 'Denver', state: 'CO', zip: 80205, email: 'sally@peach.com', password: 'password', role: 1)

      visit '/login'

      fill_in :email, with: sally.email
      fill_in :password, with: sally.password

      click_button 'Login'

      visit "/admin"
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end

  describe 'As a admin' do
    it "When I try to access any path that begins with the following, then I see a 404 error:" do
      bob = User.create!(name: 'Bob Ross', address: '745 Rose St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@ross.com', password: 'password', role: 2)

      visit '/login'

      fill_in :email, with: bob.email
      fill_in :password, with: bob.password

      click_button 'Login'

      visit "/merchant"
      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit "/cart"
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end
end

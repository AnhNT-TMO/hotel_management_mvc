# README

Using Ruby 2.7.1, Rails 6.1.5.1 and Node version 16.19.1.
STEP installing:

1. Create database.yml and application.yml from example
2. Rails db:create -> rails db:migrate -> rails db:seed
3. curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
4. echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
5. sudo apt-get update
6. sudo apt-get install yarn -y
7. yarn install
8. rails webpacker:install

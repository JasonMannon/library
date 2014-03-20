require 'rspec'
require 'pg'
require 'book'
require 'author'
require 'patron'
require 'copy'


DB = PG.connect(:dbname => 'library_test')

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM authors *;")
    DB.exec("DELETE FROM books *;")
    DB.exec("DELETE FROM auths_books *;")
    DB.exec("DELETE from patrons *;")
    DB.exec("DELETE from copies *;")
    DB.exec("DELETE from checkouts *;")
  end
end

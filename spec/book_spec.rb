require 'spec_helper'

describe Book do
  it 'initializes the book class' do
    test_book = Book.new("The Song of Roland")
    test_book.should be_instance_of Book
  end

  it 'should start with an empty array of book objects' do
    test_book = Book.new("The Song of Roland")
    Book.all.should eq []
  end

  it 'should be able to save itself to the database' do
    test_book = Book.new("The Song of Roland")
    test_book.save
    Book.all.should eq [test_book]
  end

  it 'should have an array of all author objects associated with it'  do
    test_book = Book.new("Il Principe")
    test_book.save
    test_book.link_author("Niccolo Machiavelli")
    test_book.authors[0].name.should eq "Niccolo Machiavelli"
  end

  it 'is able to delete itself from the database' do
    test_book = Book.new("Storm of Swords")
    test_book.save
    test_book.delete
    Book.all.should eq []
  end

  it 'should allow you to search for a book by title' do
    test_book = Book.new("Storm of Swords")
    test_book.save
    test_book.link_author("GRRM")
    Book.search_title("Storm of Swords").should eq [test_book]
  end

  it 'can add copies of itself to the database' do
    test_book = Book.new("Adventures of Huckleberry Finn")
    test_book.save
    test_copy = test_book.make_copy
    test_copy.book_id.should eq test_book.id
  end

end

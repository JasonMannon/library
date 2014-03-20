require 'spec_helper'

describe Author do
  it 'initializes the Author class' do
    test_author = Author.new("Geoffrey Chaucer")
    test_author.should be_instance_of Author
  end

  it 'should start with an empty array of author objects' do
    test_author = Author.new("Geoffrey Chaucer")
    Author.all.should eq []
  end

  it 'should be able to save itself to the database' do
    test_author = Author.new("Geoffrey Chaucer")
    test_author.save
    Author.all.should eq [test_author]
  end

  it 'should be able to link a book to the author in the database' do
    test_author = Author.new("Geoffrey Chaucer")
    test_author.save
    test_author.add_book("Canterbury Tales")
    test_author.books[0].title.should eq "Canterbury Tales"
  end

  it 'should delete a author from the database' do
    test_author = Author.new("Geoffrey Chaucer")
    test_author2 = Author.new("Stephen King")
    test_author2.save
    test_author.save
    test_author.delete
    Author.all.should eq [test_author2]
  end

  it 'should let you search by author name' do
    test_author = Author.new("Geoffrey Chaucer")
    test_author.save
    test_author.add_book("Canterbury Tales")
    Author.search_author("Geoffrey Chaucer").should eq [test_author]
  end
end


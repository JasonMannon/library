require 'spec_helper'

describe Copy do
  it 'should initialze an instance of copy' do
    new_book = Book.new("Storm of Swords")
    new_book.save
    new_copy = Copy.new(new_book.id)
    new_copy.should be_an_instance_of Copy
  end

  it 'should let you read the copy' do
    new_book = Book.new("Storm of Swords")
    new_book.save
    new_copy = Copy.new(new_book.id)
    new_copy.title.should eq "Storm of Swords"
  end
end

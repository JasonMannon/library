require 'spec_helper'

describe Patron do
    it 'should create a instance of the class Patron' do
      new_patron = Patron.new("Joe")
      new_patron.should be_an_instance_of Patron
    end

    it 'should let you read the patron' do
      new_patron = Patron.new("Joe")
      new_patron.name.should eq ("Joe")
    end

    it 'should start with no patrons' do
      new_patron = Patron.new("Joe")
      Patron.all.should eq []
    end

    it 'should let you save a patron' do
      new_patron = Patron.new("Joe")
      new_patron.save
      Patron.all.should eq [new_patron]
    end

    it 'should be the same if it has the same name and id' do
      new_patron = Patron.new("Joe")
      new_patron2 = Patron.new("Joe")
      new_patron.should eq new_patron2
    end

    it 'can checkout copies of a book' do
      new_patron = Patron.new("Dan")
      new_patron.save
      new_book = Book.new("Storm of Swords")
      new_book.save
      new_copy = new_book.make_copy
      new_patron.checkout(new_copy.id, "2016-07-01")
    end

    it 'has a list of all copies checked out with their due dates'  do
      new_patron = Patron.new("Dan")
      new_patron.save
      new_book = Book.new("Storm of Swords")
      new_book.save
      new_copy = new_book.make_copy
      new_patron.checkout(new_copy.id, "2016-07-01")
      new_patron.copies_due.should eq [[new_copy, "2016-07-01"]]
    end

    # it 'can checkout copies of a book' do
    #   new_patron = Patron.new("Jake")
    #   new_patron.save
    #   new_book = Book.new("Storm of Swords")
    #   new_book.save
    #   new_book2 = Book.new("Game of Thrones")
    #   new_book2.save
    #   new_copy = Copy.new(new_book.id)
    #   new_copy.save
    #   new_copy2 = Copy.new(new_book2.id)
    #   new_copy2.save
    #   new_patron.checkout(new_copy.id, "2007-06-08")
    #   new_patron.checkout(new_copy2.id, "2015-02-23")
    #   new_patron.books.should eq [new_book, new_book2]
    # end
end

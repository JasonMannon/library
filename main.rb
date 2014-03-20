require 'pg'
require './lib/book'
require './lib/author'
require './lib/copy'
require './lib/patron'

DB = PG.connect(:dbname => 'library')

def main_menu
  system('clear')
  puts "Welcome to the Portland Library!"
  puts "Enter 'l' if you are a librarian."
  puts "Enter 'p' if you are a patron."
  puts "Enter 'x' to leave the library program."
  case gets.chomp.downcase
  when 'l'
    librarian_menu
  when 'p'
    patron_new
  when 'x'
    exit
  else
    main_menu
  end
end

def librarian_menu
  puts "Enter 'b' to add, edit, or delete a book."
  puts "Enter 'a' to add, edit, or delete an author."
  puts "Enter 'c' to add copies of a book."
  puts "Enter 'x' to go back to main menu."
  case gets.chomp.downcase
  when 'b'
    l_book_menu
  when 'a'
    l_author_menu
  when 'c'
    l_copy_menu
  when 'x'
    main_menu
  else
    puts "That is an invalid command. Enter any key to try again."
    gets.chomp
    librarian_menu
  end
end

def l_book_menu
  puts "Enter 'a' to add a book."
  puts "Enter 'd' to delete a book."
  puts "Enter 'u' to update a book."
  puts "Enter 's' to search for a book."
  puts "Enter 'l' to list out all books in the catalog."
  puts "Enter 'x' to go back to librarian menu"
  case gets.chomp.downcase
  when 'a'
    puts "Enter the name of the book you would like to add:"
    input_b = gets.chomp
    new_book = Book.new(input_b)
    new_book.save
    puts "What is the name of its author?"
    input_a = gets.chomp
    new_book.link_author(input_a)
    l_book_menu
  when 'd'
    puts "Enter the name of the book you would to delete."
    input = gets.chomp
    del_book = (Book.all.select {|book| book.title == input}).first
    del_book.delete
    puts "Enter anything to go back."
    gets.chomp
    l_book_menu
  when 'u'
  when 's'
    puts "Would you like to search for by title(t) or by author(a)?"
    input2 = gets.chomp
    case input2
    when "t"
      puts "What is the book title you would like to search by?"
      input = gets.chomp
      search_book = Book.search_title(input)
      search_book.each do |book|
        puts book.title + " - " + book.authors[0].name
      end
      puts "Enter any key to go back"
      gets.chomp
      l_book_menu
    when 'a'
      puts "What is the name of the author you would like to search by?"
      input = gets.chomp
      search_author = Author.search_author(input)
      puts "Here are all the books for this author:"
      search_author.each do |author|
        author.books.each {|b| puts b.title}
      end
      puts "Enter any key to go back."
      gets.chomp
      l_book_menu
    else
      puts "Invalid input."
      l_book_menu
    end
  when 'l'
    book_list
    puts "Enter anything to go back."
    gets.chomp
    l_book_menu
  when 'x'
    librarian_menu
  else
    puts "Invalid command."
    gets.chomp
    l_book_menu
  end
end

def l_author_menu
  puts "Enter 'a' to add a author"
  puts "Enter 'd' to delete a author"
  puts "Enter 'u' to update a author"
  puts "Enter 's' to search for a author"
  puts "Enter 'l' to list all authors"
  input = gets.chomp
  case input
  when 'a'
    puts "Enter the name of the author you would like to add"
    input = gets.chomp
    new_author = Author.new(input)
    new_author.save
    puts "Would you like to add a book to the author"
    input = gets.chomp
    new_author.add_book(input)
    puts "Enter any key to go back"
    gets.chomp
    l_author_menu
  when 'd'
    puts "Enter a author name to delete"
    input = gets.chomp
    del_author = (Author.all.select {|author| author.name == input}).first
    del_author.delete
    puts "Enter any key to go back"
    gets.chomp
    l_author_menu
  when 'u'
  when 's'
    puts "Enter an author name to search:"
    input = gets.chomp
    ser_authors = Author.search_author(input)
    ser_authors.each {|a| puts a.name}
    puts "Enter any key to go back."
    l_author_menu
  when 'l'
    author_list
    puts "Enter any key to go back."
    l_author_menu
  else
  end
end

def l_copy_menu
  puts "What book would you like to add copies of?"
  puts "Enter the index of the book you wish to copy."
  book_list
  input = gets.chomp.to_i - 1
  Book.all[input].make_copy
  puts "This book has " + Book.all[input].copy_count.to_s + " copies."
  puts "Enter any key to go back to librarian menu."
  gets.chomp
  librarian_menu
end

def book_list
  Book.all.each_with_index do |book, index|
    puts (index+1).to_s + ": " + book.title + " - " + book.authors[0].name + " " + book.copy_count.length.to_s + " copies "
  end
end

def author_list
  Author.all.each_with_index do |author, index|
    puts (index+1).to_s + ": " +  author.name
  end
end

def patron_list
  Patron.all.each_with_index do |name, index|
    puts (index+1).to_s + ": " + name.name
  end
end

def patron_new
  puts "Are you a new patron 'n', or a old patron 'o'"
  input = gets.chomp
  case input
  when 'n'
    puts "Enter your name"
    input = gets.chomp
    new_patron = Patron.new(input)
    new_patron.save
    patron_menu(new_patron)
  when 'o'
    patron_list
    puts 'Please choose the index of your name'
    input = gets.chomp.to_i - 1
    current_patron = Patron.all[input]
    patron_menu(current_patron)
  end
end

def patron_menu(current_patron)
  puts "Enter 's' to search"
  puts "Enter 'c' to check out a book"
  puts "Enter 'l' to list books or authors"
  puts "Enter 'r' to return a book"
  puts "Enter 'h' to show the books you have checked out."
  input = gets.chomp
  case input
  when 's'
    p_search_menu
  when 'c'
    p_checkout(current_patron)
  when 'l'
    book_list
  when 'r'
  when 'h'
    current_patron.copies_due.each do |copy|
      puts "Title: " + copy[0].title + " Due date: " + copy[1]
    end
    puts "Enter any ket to go back to patron menu."
    gets.chomp
    patron_menu(current_patron)
  else
  end
end

def p_search_menu(current_patron)
  puts "Would you like to search for by title(t) or by author(a)?"
    input = gets.chomp
    case input
    when "t"
      puts "What is the book title you would like to search by?"
      input = gets.chomp
      search_book = Book.search_title(input)
      search_book.each do |book|
        puts book.title + " - " + book.authors[0].name
      end
      puts "Enter any key to go back"
      gets.chomp
      patron_menu(current_patron)
    when 'a'
      puts "What is the name of the author you would like to search by?"
      input = gets.chomp
      search_author = Author.search_author(input)
      puts "Here are all the books for this author:" #NOT PUTTING OUT
      search_author.each do |author|
        author.books.each {|b| puts b.title}
      end
      puts "Enter any key to go back."
      gets.chomp
      patron_menu(current_patron)
    else
      puts "Invalid input."
      patron_menu(current_patron)
  end
end

def p_checkout(current_patron)
  book_list
  puts "Enter the index of which book you would like to checkout"
  input = gets.chomp.to_i - 1
  book_to_checkout = Book.all[input]
  book_to_checkout.copy_count.each do |copy|
    if copy.out == false
      current_patron.checkout(copy.id, "2014-05-05")
      copy.checked_out
      puts "This book has been checked out, your due date is: " + "2014-05-05"
      break
    end
  end
  puts "Enter any key to go back to patron menu."
  gets.chomp
  patron_menu(current_patron)
end

main_menu

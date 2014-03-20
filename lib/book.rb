class Book
  attr_reader :title, :id, :authors

  def initialize(title, id = nil)
    @title = title
    @id = id
  end

  def self.all
    books = []
    results = DB.exec("SELECT * FROM books;")
    results.each do |result|
      title = result['title']
      id = result['id'].to_i
      books << Book.new(title, id)
    end
    books
  end

  def self.search_title(title)
    self.all.select {|book| book.title == title}
  end

  def delete
    results = DB.exec("DELETE FROM books WHERE id = #{@id};")
  end


  def save
    results = DB.exec("INSERT INTO books (title) VALUES ('#{@title}') RETURNING id;")
    @id = results.first['id'].to_i
  end

  def ==(another_book)
    self.id == another_book.id && self.title == another_book.title
  end

  def authors
    authors = []
    results = DB.exec("SELECT authors.* FROM authors JOIN auths_books ON (authors.id = auths_books.author_id) JOIN books ON (auths_books.book_id = books.id) WHERE books.id = #{@id};")
    results.each do |result|
      name = result['name']
      id = result['id']
      authors << Author.new(name, id)
    end
    authors
  end

  def make_copy
    new_copy = Copy.new(@id)
    new_copy.save
    new_copy
  end

  def copy_count
    results = DB.exec("SELECT * FROM copies WHERE book_id = #{@id}")
    copy_count = []
    results.each do |result|
      book_id = result['book_id']
      id = result['id']
      copy_count << Copy.new(book_id, id)
    end
    copy_count
  end

  def link_author(author_name)
    results = DB.exec("SELECT * FROM authors WHERE name = ('#{author_name}');")
    if results.first == nil
      new_author = Author.new(author_name)
      new_author.save
      author_id = new_author.id
    else
      author_id = results.first['id'].to_i
    end
    DB.exec("INSERT INTO auths_books (author_id, book_id) VALUES (#{author_id}, #{@id});")
  end
end

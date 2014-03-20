class Author
  attr_reader :name, :id, :books

  def initialize(name, id = nil)
    @name = name
    @id = id
  end

  def self.all
    authors = []
    results = DB.exec("SELECT * FROM authors;")
    results.each do |result|
      name = result['name']
      id = result['id'].to_i
      authors << Author.new(name, id)
    end
    authors
  end

  def save
    results = DB.exec("SELECT * FROM authors WHERE name = ('#{@name}');")
    if results.first == nil
      a_results = DB.exec("INSERT INTO authors (name) VALUES ('#{@name}') RETURNING id;")
      @id = a_results.first['id'].to_i
    else
      @id = results.first['id']
    end
  end

  def delete
    DB.exec("DELETE FROM authors WHERE id = #{@id}")
  end

  def ==(another_author)
    self.id == another_author.id && self.name == another_author.name
  end

  def books
    books = []
    results = DB.exec("SELECT books.* FROM authors JOIN auths_books ON (authors.id = auths_books.author_id) JOIN books ON (auths_books.book_id = books.id) WHERE authors.id = #{@id};")
    results.each do |result|
      title = result['title']
      id = result['id']
      books << Book.new(title, id)
    end
    books
  end

  def add_book(book_title)
    results = DB.exec("SELECT * FROM books WHERE title = ('#{book_title}');")
    if results.first == nil
      new_book = Book.new(book_title)
      new_book.save
      book_id = new_book.id
    else
      book_id = results.first['id'].to_i
    end
    DB.exec("INSERT INTO auths_books (author_id, book_id) VALUES (#{@id}, #{book_id});")
  end

  def self.search_author(name)
    self.all.select {|author| author.name == name}
  end

end

class Copy
  attr_reader :book_id, :id, :title, :out

  def initialize(book_id, id=nil)
    @book_id = book_id
    @id = id
    @out = false
    name_find
  end

  def name_find
    results = DB.exec("SELECT * FROM books WHERE id = #{book_id}")
    @title = results.first['title']
  end

  def self.all
    copies = []
    results = DB.exec("SELECT * FROM copies;")
    results.each do |result|
      book_id = result['book_id']
      id = result['id'].to_i
      copies << Copy.new(book_id, id)
    end
    copies
  end

  def checked_out
    @out = true
  end

  def save
    result = DB.exec("INSERT INTO copies (book_id) VALUES (#{@book_id}) RETURNING id;")
    @id = result.first['id'].to_i
  end

  def ==(another_copy)
    self.id == another_copy.id && self.title == another_copy.title
  end
end

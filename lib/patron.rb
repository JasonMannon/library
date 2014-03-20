class Patron
  attr_reader :name, :id, :books

  def initialize(name, id=nil)
    @name = name
    @id = id
  end

  def self.all
    patrons = []
    results = DB.exec("SELECT * FROM patrons;")
    results.each do |result|
      name = result["name"]
      id = result['id'].to_i
      patrons << Patron.new(name, id)
    end
    patrons
  end

  def copies_due
    copies_due = []
    results = DB.exec("SELECT copies.* FROM patrons JOIN checkouts ON (patrons.id = checkouts.patron_id) JOIN copies ON (checkouts.copy_id = copies.id) WHERE patrons.id = #{@id};")
    results.each do |result|
      book_id = result['book_id'].to_i
      id = result['id'].to_i
      due_date = DB.exec("SELECT * FROM checkouts WHERE copy_id = #{id};").first['due_date']
      copies_due << [Copy.new(book_id, id), due_date]
    end
    copies_due
  end


  def checkout(copy_id, due_date)
    DB.exec("INSERT INTO checkouts (copy_id, patron_id, due_date) VALUES (#{copy_id}, #{@id}, ('#{due_date}'));")
  end

  def save
    results = DB.exec("INSERT INTO patrons (name) VALUES ('#{name}') RETURNING id;")
    @id = results.first['id'].to_i
  end

  def ==(another_name)
    self.name == another_name.name && self.id == another_name.id
  end
end

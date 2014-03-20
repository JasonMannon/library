Books = ["one", "two", "three"]

p (Books.select {|book| book == "one"})[0]

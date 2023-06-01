class Dog
  attr_accessor :name, :breed, :id
   def initialize(name:, breed:, id: nil)
    @id = id
    @name = name
    @breed = breed
   end

   #.create_table
   def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
    )
    SQL
    DB[ :conn].execute(sql)
   end

   #.drop_table
   def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS dogs
    SQL
    DB[:conn].execute(sql)
   end

   #save table
   def save
    sql = <<-SQL
    INSERT INTO dogs (name, breed) 
    VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.breed)
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    self
   end

   #create a new dog object and uses the #save method to save that dog to the database 
   def self.create(name:, breed:)
    dog = Dog.new(name: name, breed: breed)
    dog.save
   end

   #new_from_db, creates an instance with corresponding attribute values
   def self.new_from_db(row)
    self.new(id: row[0], name: row[1], breed: row[2])
   end

   #all returns an array of Dog instances for all records in the dogs table
   def self.all
    sql = <<-SQL
    SELECT * FROM dogs
    SQL
    DB[:conn].execute(sql).map { |row| self.new_from_db(row)}
   end

   # find_by_name, returns an instance of dog that matches the name from the DB
   def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM dogs WHERE name = ? LIMIT 1
    SQL
    DB[:conn].execute(sql, name).map { |row| self.new_from_db(row)}.first
   end

   #find ,returns a new dog object by id
   def self.find(id)
    sql = <<-SQL
      SELECT * FROM dogs WHERE Id = ? LIMIT 1
      SQL
      DB[:conn].execute(sql,id) .map { |row| self.new_from_db(row)}.first
   end

end

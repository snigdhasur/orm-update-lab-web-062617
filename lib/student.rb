require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

attr_accessor :name, :grade, :id 

	def initialize(name, grade, id = nil)
		@name = name
		@grade = grade
		@id = id
	end 

	def self.create_table 
		DB[:conn].execute("CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT, grade INTEGER);")
	end 

	def self.drop_table 
		DB[:conn].execute("DROP TABLE students;")
	end 


	def update 
		sql = <<-SQL
	   		 		UPDATE students SET name = ?, grade = ? 
	    			WHERE id = ?
	  				SQL
	  	DB[:conn].execute(sql, self.name, self.grade, self.id)
	end 


	def save
		if self.id
			self.update
		else 
			sql = <<-SQL
	   		 		INSERT INTO students (name, grade) 
	    			VALUES (?, ?)
	  				SQL

			DB[:conn].execute(sql, self.name, self.grade)
			@id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
		end 
	end 

	def self.create(name, grade)
		@name = name 
		@grade = grade
		new_student = Student.new(@name, @grade)
		new_student.save
	end 

	def self.new_from_db(array)
		new_student = Student.new(array[1], array[2], array[0])
		new_student 
	end 

	def self.find_by_name(name_input)
		sql = <<-SQL
	   		 		SELECT * FROM students 
	   		 		WHERE name = ?
	  				SQL
	  	row = DB[:conn].execute(sql, name_input)[0]
	  	new_student = Student.new(row[1], row[2], row[0])
	  	new_student
	end 



end

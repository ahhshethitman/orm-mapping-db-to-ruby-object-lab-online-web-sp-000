class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    pat = self.new 
    pat.id = row[0]
    pat.name = row[1]
    pat.grade = row[2]
    pat
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
    SQL
 
    DB[:conn].execute(sql).map do |row| 
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL #grabs name from the database
      SELECT * 
      FROM students 
      WHERE name = ?
      LIMIT 1 
    SQL
    
    DB[:conn].execute(sql,name).map do |row| #iterate through sql using .map b/c they are strings
      self.new_from_db(row) #assign found data to a ruby object
    end.first 
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
  
  def self.all_students_in_grade_9
    sql = <<-SQL 
      SELECT * 
      FROM students 
      WHERE grade = 9
    SQL
    
    DB[:conn].execute(sql)
      
  end
  
  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * 
    FROM students 
    WHERE students.grade < 12
    SQL
    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end
  end
  
  def self.first_X_students_in_grade_10(amt)
  end
  
  def self.first_student_in_grade_10
  end
  
  def self.all_students_in_grade_X
  end
end

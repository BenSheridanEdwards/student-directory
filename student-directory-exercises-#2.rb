@students = []

def print_menu
  puts ""
  puts "1. Enrol students"
  puts "2. Show the students"
  puts "3. Save the list to students.csv"
  puts "4. Load the list to students.csv"
  puts "9. Exit"
end

def interactive_menu
  loop do
    print_menu
    process(STDIN.gets.chomp)
  end
end

def process(selection)
  case selection
  when "1"
    puts "Launching student enrolment form"
    enrol_students
  when "2"
    puts "Showing student list"
    show_students
  when "3"
    puts "What file would you like these students to?"
    savefile = STDIN.gets.chomp
    puts "Saving student data"
    save_students(savefile)
    puts "Save successful"
  when "4"
    puts "What file would you like to load from?"
    loadfile = STDIN.gets.chomp
    puts "Loading students"
    load_students(loadfile)
    puts "Students loaded"
  when "9"
    exit
  else
    puts "I don't know what you meant, try again"
  end
end

def enter_student_details
  puts "What name would you like to add?"
  name = STDIN.gets.chomp
  puts "What cohort are they apart of?"
  cohort = STDIN.gets.chomp
end

def enrol_students
  puts "Please enter the names of the students"
  puts "To finish, just hit return twice"
  enter_student_details
  cohort = :novmeber if cohort.empty?
  while !name.empty? do
    store_students
    puts "Now we have #{@students.count} students"
    enter_student_details
  end
  @students
end

def show_students
  print_header
  print_students_list
  print_footer
end

def print_header
  puts "The students of Villains Academy"
  puts "_____________"
end

def print_students_list
  if @students.count >= 1
    @students.each.with_index(1) {|student, index| puts  "#{index}. #{student[:name]} (#{student[:cohort]} cohort)"}
  end
end

def print_footer
  if @students.count == 0
    puts "Now, you haven't got any students."
  elsif @students.count == 1
    puts "Now, we have 1 great student."
  else
    puts "Now, we have #{@students.count} great students."
  end
end

def store_students
  @students << {name: name, cohort: cohort.to_sym}
end

def save_students(filename)
  File.open(filename, "w") do |file|
    @students.each do |student| student_data = [student[:name], student[:cohort]]
      csv_line = student_data.join(",")
      file.puts csv_line
    end
  end
end

def save_students_to_csv(filename)
  CSV.open(filename, "w") do |file|
    @students.each do |student| student_data = [student[:name], student[:cohort]]
      file << student_data
    end
  end
end

def load_students(filename)
  File.open(filename, "r") do |file|
    file.readlines.each do |line|
      name, cohort = line.chomp.split(",")
      store_students
    end
  end
end

def load_students_to_csv(filename)
  CSV.foreach(filename) do |line|
    name, cohort = line.chomp.split(",")
    store_students
  end
end 

def try_load_students
  filename = ARGV.first
  filename = "student.csv" if filename.nil?
  if File.exists?(filename)
    load_students(filename)
    puts "Loaded #{@students.count} from #{filename}"
  else
    puts "Sorry, #{filename} doesn't exist."
    exit
  end
end

try_load_students
interactive_menu

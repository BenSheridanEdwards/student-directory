@students = []

def print_menu
  puts ""
  puts "1. Input the students"
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
    input_students
  when "2"
    show_students
  when "3"
    save_students
  when "4"
    load_students
  when "9"
    exit
  else
    puts "I don't know what you meant, try again"
  end
end

def input_students
  puts "Please enter the names of the students"
  puts "To finish, just hit return twice"
  name = STDIN.gets.chomp
  puts "Please enter the cohort"
  cohort = STDIN.gets.chomp
  cohort = :novmeber if cohort.empty?
  while !name.empty? do
    @students << {
      name: name,
      cohort: cohort.to_sym
    }
    puts "Now we have #{@students.count} students"
    puts "What name would you like to add?"
    name = STDIN.gets.chomp
    puts "What cohort are they apart of?"
    cohort = STDIN.gets.chomp
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

def save_students
  file = File.open("students.csv", "w")
  @students.each do |student| student_data = [student[:name], student[:cohort]]
    csv_line = student_data.join(",")
    file.puts csv_line
  end
  file.close
end

def load_students(filename = "students.csv")
  file = File.open(filename, "r")
  file.readlines.each do |line|
    name, cohort = line.chomp.split(",")
    @students << {name: name, cohort: cohort.to_sym}
  end
  file.close
end

def try_load_students
  filename = ARGV.first
  return if filename.nil?
  if File.exists?(filename)
    loud_students(filename)
    puts "Loaded #{@students.count} from #{filename}"
  else
    puts "Sorry, #{filename} doesn't exist."
    exit
  end
end

try_load_students
interactive_menu

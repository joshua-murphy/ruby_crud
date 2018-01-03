require 'httparty'
require 'json'
require 'pry'

BASE_URL = "http://json-server.devpointlabs.com/api/v1/users"

def menu
  puts "\n===== MENU =====\n1) All Users  2) Single User  3) New User  0) Exit"
  case gets.strip.to_i
    when 1
      all_users
    when 2
      single_user
    when 3
      new_user
    else
      puts "Goodbye"
      exit
  end 
end

def all_users
  puts "\n=== ALL USERS ==="
  @users = HTTParty.get("#{BASE_URL}").parsed_response
  @users.each_with_index do |user, i|
    puts "#{i + 1}. #{user["id"]} #{user["first_name"]} #{user["last_name"]} #{user["phone_number"]}"
  end
end

def single_user
  @users = HTTParty.get("#{BASE_URL}").parsed_response 
  available_ids = []
  @users.each do |user|
    available_ids.push(user["id"])
  end
  puts "\n=== WHICH USER ID? ==="
  puts "Available: #{available_ids.sort.to_s}"
  user_id = gets.strip.to_i

  if available_ids.include?(user_id)
    user = HTTParty.get("#{BASE_URL}/#{user_id}").parsed_response
    puts "#{user["first_name"]} #{user["last_name"]} #{user["phone_number"]}"
  else
    puts "User with id: #{user_id} not found. Please try again."
    single_user
  end
end

def new_user
  puts "\n=== NEW USER ==="  
  print "First name: "
  first_name = gets.strip
  print "Last name:  "
  last_name = gets.strip
  print "Phone number: "
  phone_number = gets.strip
  HTTParty.post(BASE_URL, 
    :body => { 
      :first_name => first_name, 
      :last_name => last_name,
      :phone_number => phone_number,
    }.to_json,
      :headers => { 'Content-Type' => 'application/json' } 
  )
end

while true
  menu
end
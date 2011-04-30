# taskwarrior.rb
require "rubygems"
require "bundler/setup"
require 'sinatra'
require 'erb'
require 'parseconfig'
require 'json'

# Require all model files
Dir['./models/*.rb'].each do |file|
  require file
end

# Before filter
before do
  @current_page = request.path_info
end

# Helpers
helpers do

  def format_date(timestamp)
    format = Taskwarrior::Config.file.get_value('dateformat') || 'm/d/Y'
    subbed = format.gsub(/([a-zA-Z])/, '%\1')
    Time.at(timestamp.to_i).strftime(subbed)
  end

  def colorize_date(timestamp)
    return if timestamp.nil?
    due_def = Taskwarrior::Config.file.get_value('due').to_i || 5
    case true
      when Time.now.to_date == Time.at(timestamp.to_i).to_date then 'today'
      when Time.now.to_i > timestamp.to_i then 'overdue'
      when (Time.now.to_i - timestamp.to_i) < (due_def * 86400) then 'due'
      else 'regular'
    end
  end

end

# Redirects
get '/' do
  redirect '/tasks/pending'
end
get '/tasks/?' do
  redirect '/tasks/pending'
end

# Task routes
get '/tasks/pending/?' do
  @title = 'Pending Tasks'
  @subnav = { '/tasks/pending' => 'Pending', '/tasks/completed' => 'Completed' }
  @tasks = Taskwarrior::Task.tasks
  erb :listing  
end

get '/tasks/completed/?' do
  @title = 'Completed Tasks'
  @subnav = { '/tasks/pending' => 'Pending', '/tasks/completed' => 'Completed' }
  @tasks = Taskwarrior::Task.tasks(:completed)
  erb :listing
end

# Projects
get '/projects' do

end

get 'projects/:name/tasks' do

end

# Reporting
get '/reports' do

end

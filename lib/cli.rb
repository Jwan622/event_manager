require 'csv'
require_relative 'session'

class CLI
  attr_reader :command, :messages, :instream, :outstream, :session

  def initialize(instream, outstream)
    @messages  = Messages.new
    @instream  = instream
    @outstream = outstream
    @session   = Session.new("")
    @command   = ""
  end

  def call
    outstream.puts messages.welcome
    outstream.puts messages.help
    until quit?
      @command = instream.gets.strip
      process_commands
    end
  end

  private

  def process_commands
    case
    when load?
      filename = @command[4..-1].strip
      filename = "event_attendees.csv" if filename.empty?
      @session = Session.new(filename)
      session.load_file
    when print?
      outstream.puts session.queue_to_tsv
    when print_by?
      attribute = @command.split(" ")[3]
      if attribute != nil
        outstream.puts session.sorted_queue_to_tsv(attribute)
      end
    when count?
      outstream.puts session.queue.length
    when clear?
      outstream.puts session.queue_clear
    when find?
      attribute = @command.split(" ")[1]
      criteria = @command.split(" ")[2]
      if attribute != nil && criteria != nil
        session.find(attribute, criteria)
      end
    when save?
      filename = @command.split(" ")[3]
      if filename != nil
        session.save_to_csv(filename)
      end
    when help?
      user_option = @command.split(" ")[1]
      if user_option !=nil
        outstream.puts  messages.help_list(user_option)
      else
        outstream.puts messages.help
      end
    end
  end

  def load?
    command.downcase.start_with?("load")
  end

  def print?
    command.strip.downcase == "queue print"
  end

  def print_by?
    command.downcase.start_with?("queue print by")
  end

  def count?
    command.strip.downcase == "queue count"
  end

  def clear?
    command.strip.downcase == "queue clear"
  end

  def find?
    command.downcase.start_with?("find")
  end

  def save?
    command.downcase.start_with?("queue save to")
  end

  def quit?
    command.downcase == "quit"
  end

  def help?
    command.downcase.start_with?("help")
  end
end

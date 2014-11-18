require 'csv'
require 'time'
require_relative '../lib/data_cleaner'
require_relative '../lib/messages'
require_relative '../lib/entry'

class Session
  attr_reader :filename, :contents, :queue, :messages

  def initialize(filename)
    @filename  = filename
    @contents  = []
    @queue     = []
    @messages  = Messages.new
  end

  def load_file
    data = CSV.open(filename, headers: true, header_converters: :symbol)
    @contents = data.map do |row|
      content = {}
      content[:id] = row[0]
      content[:regdate] = Time.strptime(row[:regdate], "%m/%d/%y %H:%M")
      content[:first_name] = row[:first_name].strip
      content[:last_name] = row[:last_name].strip
      content[:email_address] = row[:email_address].strip
      content[:homephone] = clean_homephone(row[:homephone])
      content[:state] = clean_state(row[:state])
      content[:street] = clean_street(row[:street])
      content[:zipcode] = clean_zipcode(row[:zipcode])
      Entry.new(content)
    end
  end

  def find(attribute, criteria)
    @queue = contents.select do |entry|
      entry.send(attribute).downcase == criteria.strip.downcase
    end
  end

  def queue_clear
    @queue = []
  end

  def queue_to_tsv
    tsv = messages.tsv_header
    queue.each do |entry|
      tsv += "\n" + entry.to_array.join("\t")
    end
    tsv
  end

  def sorted_queue_to_tsv(attribute)
    tsv = messages.tsv_header
    queue.sort_by { |e| e.send(attribute) }.each do |entry|
      tsv += "\n" + entry.to_array.join("\t")
    end
    tsv
  end

  def save_to_csv(filename)
    CSV.open(filename, "wb") do |csv|
      csv << messages.csv_header
      queue.each do |entry|
        csv << entry.to_array
      end
    end
  end

end

# session = Session.new
# session.load_file
# session.find(:zipcode, "20011")
# puts session.queue
require 'csv'                           # => true
require 'time'                          # => true
require_relative '../lib/data_cleaner'  # => true
require_relative '../lib/messages'      # => true
require_relative '../lib/entry'         # => true

#basically, after we type load, we load the file name into a session object. When we do session.load_file,
# we map through the whole CSv which is an array of array of strings, and convert it into an array of hashes which have
# values. the hashes have values are cleaned and stripped.

class Session
  attr_reader :filename, :contents, :queue, :messages, :data_cleaner  # => nil

  def initialize(filename)
    @filename     = filename
    @contents     = []
    @queue        = []
    @messages     = Messages.new
    @data_cleaner = DataCleaner.new
  end

  def load_file
    data = CSV.open(filename, headers: true, header_converters: :symbol)
    @contents = data.map do |row|  #so @contents is an array of Entry objects. The last thing in the map enumerable gets returned which is an Entry object. content on the otherhand is a single hash everytime it loops.
      content                 = {}
      content[:id]            = row[0]
      content[:regdate]       = Time.strptime(row[:regdate], "%m/%d/%y %H:%M")
      content[:first_name]    = row[:first_name].strip
      content[:last_name]     = row[:last_name].strip
      content[:email_address] = row[:email_address].strip
      content[:homephone]     = data_cleaner.clean_homephone(row[:homephone])
      content[:state]         = data_cleaner.clean_state(row[:state])
      content[:street]        = data_cleaner.clean_street(row[:street])
      content[:zipcode]       = data_cleaner.clean_zipcode(row[:zipcode])

      Entry.new(content)
    end
  end

  def find(attribute, criteria) #so attribute is coming in as a string. contents is an array of Entries.
    @queue = contents.select do |entry| #we then add the entries where the condition is true. @queue is an array of objects
      entry.send(attribute).downcase == criteria.strip.downcase #what's going on is that we're calling the attribute method on entry object.
    end
  end

  def queue_clear
    @queue = []
  end

  def queue_to_tsv
    tsv = messages.tsv_header
    queue.each do |entry|
      tsv += "\n" + entry.to_array.join("\t")
      require 'pry', binding.pry
    end
    tsv
  end

  def sorted_queue_to_tsv(attribute)
    tsv = messages.tsv_header
    queue.sort_by { |e| e.send(attribute) }.each do |entry|   #queue is an array of objects.
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
      csv
    end
  end

end

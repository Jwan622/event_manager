require 'csv'                                                                                                                        # => true
puts __dir__                                                                                                                         # => nil
data = CSV.open("/Users/Jwan/Dropbox/Turing/Projects/event_manager/event_attendees.csv", headers: true, header_converters: :symbol)  # => <#CSV io_type:File io_path:"/Users/Jwan/Dropbox/Turing/Projects/event_manager/event_attendees.csv" encoding:US-ASCII lineno:0 col_sep:"," row_sep:"\n" quote_char:"\"" headers:true>                                                                                                                  # => nil

# >> /Users/Jwan/Dropbox/Turing/Projects/event_manager
# >> <#CSV io_type:File io_path:"/Users/Jwan/Dropbox/Turing/Projects/event_manager/event_attendees.csv" encoding:US-ASCII lineno:0 col_sep:"," row_sep:"\n" quote_char:"\"" headers:true>

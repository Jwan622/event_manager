class Entry
# basically, after we type load, the data is passed into sessions which cleans the data. The clean data is then passed to Entry
# so we create new Entry objects. Every hash gets passed into an Entry and so a new Entry object is created for every hash/row.

  attr_reader :first_name, :last_name, :email_address, :zipcode, :city, :state, :street, :home_phone
  def initialize(data)
    @id             = data[0]   # I think this should be data[:id]
    @reg_date       = data[:regdate]
    @first_name     = data[:first_name]
    @last_name      = data[:last_name]
    @email_address  = data[:email_address]
    @home_phone     = data[:homephone]
    @street         = data[:street]
    @state          = data[:state]
    @city           = data[:city]
    @zipcode        = data[:zipcode]
  end

  def to_array
    #"LAST NAME  FIRST NAME  EMAIL  ZIPCODE  CITY  STATE  ADDRESS  PHONE"
    [last_name, first_name, email_address, zipcode, city, state, street, home_phone]
  end


end

class DataCleaner

  def clean_homephone(number)
    number.gsub(/[^0-9]/, "").ljust(10, "0")[0..9]
  end

  def clean_zipcode(zipcode)
    zipcode.to_s.rjust(5, "0")[0..4]
  end

  def clean_state(state)
    if state == nil || state == ""
      "state not given"
    else
      state.strip[0..1]
    end
  end

  def clean_street(street)
    if street == nil || street == ""
      "street not given"
    else
      street.downcase.strip.gsub(/\s+/, "")
    end
  end
end

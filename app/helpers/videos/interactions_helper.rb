module Videos::InteractionsHelper
  def format_time seconds
    Time.at(seconds)
      .utc
      .strftime "%H:%M:%S"
  end
end
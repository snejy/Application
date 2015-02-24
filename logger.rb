require 'time'
require 'net/http'

LEVELS = {1 => 'INFO', 2 => 'WARNING', 3 => 'PLSCHECKFFS'}

class MyLogger
  def log(level, message)
    raise NotImplementedError
  end
end

class ConsoleLogger < MyLogger
  def log(level, message)
    time = Time.now.utc.iso8601
    "#{LEVELS[level]}::#{time}::#{message}"
  end
end

class FileLogger < MyLogger
  def log(level, message)
    time = Time.now.utc.iso8601
    File.open('./logger.txt', 'a') { |file| file.write("#{LEVELS[level]}::#{time}::#{message}\n") }
  end
end

class HTTPLogger < MyLogger
  def log(level, message)
    time = Time.now.utc.iso8601
    Net::HTTP.post_form(URI.parse('http://localhost'), {'message'=> "#{LEVELS[level]}::#{time}::#{message}" })
  end
end

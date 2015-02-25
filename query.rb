def get_table(file)
  flag = true
  hashed = []
  keys = []
  File::open(file).each_line do |line|
    if flag
        keys = line.split(',').map(&:strip)
        flag = false
    else
        items = line.split(',')
        hashed.push Hash[keys.zip(items)]
    end
  end
  hashed
end

def find_max(hash, arg)
  max = hash[0][arg]
  hash.each do |item|
    if item[arg].size > max.size
        max = item[arg]
    end
  end
  max.size
end

def select(args, hash, limit = nil)
  args.each do |arg|
    if not hash[0].keys.include? arg
      p "#{arg} is invalid argument !"
      return
    end
  end
  counter = 0
  p args.map { |arg| "|" + arg.center(find_max(hash, arg)) + "|"}.join
  p args.map { |arg| "|" +"-" * find_max(hash, arg) + "|"}.join
  hash.each do |item|
    if limit == counter
      return
    end
    p args.map { |arg| "|" + item[arg].strip.chomp.center(find_max(hash, arg)) + "|"}.join
    counter += 1
  end
end

def sum(hash, query)
  if hash[0][query].to_i == 0 and hash[0][query] != "0"
    p "The column #{query} does not contain numbers."
    return
  end
  sum = 0
  hash.map{|item| sum += item[query].to_i}
  p sum
end

def find(hash, pattern)
  args = hash[0].keys
  p args.map { |arg| "|" + arg.center(find_max(hash, arg)) + "|"}.join
  p args.map { |arg| "|" +"-" * find_max(hash, arg) + "|"}.join
  hash.select {|item| item.values.join(" ").include? pattern}.each do |item|
    p args.map { |arg| "|" + item[arg].strip.chomp.center(find_max(hash, arg)) + "|"}.join
  end
end

def main(file)
  p "Enter query:"
  option = gets
  hash = get_table(file)
  while option.chomp.downcase != "quit"
    valid = false
    query = option.split().map{ |item| item.chomp(",")}
    if query[0].downcase == 'select' and not query.map(&:downcase).include? "limit"
        query.shift
        select(query, hash)
        valid = true
    end
    if query.map(&:downcase).include? "limit"
      limit = query[-1]
      query.shift
      query.pop
      query.pop
      select(query, hash, limit.to_i)
      valid = true
    end
    if query[0].downcase == 'show'
      p hash[0].keys.join(", ")
      valid = true
    end
    if query[0].downcase == 'sum'
      sum(hash, query[1])
      valid = true
    end
    if query[0].downcase == 'find'
      pattern = query[1].chomp('"').reverse.chomp('"').reverse
      p pattern
      find(hash, pattern)
      valid = true
    end
    if valid == false
      p "Such query is not supported. Please try again with the following commands:"
      p "SELECT [columns] LIMIT X"
      p "SUM [column]"
      p "SHOW"
      p "FIND X"
      p "QUIT"
    end
    p "Enter query:"
    option = gets
  end
  p "Quitting.."
end
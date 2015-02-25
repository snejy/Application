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
    if item.size > max.size
        max = item
    end
  end
  max.size
end

def select(args, hash, limit = nil)
    counter = 0
    p "here"
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
  sum = 0
  hash.map{|item| sum += item[query].to_i}
  sum
end

def main(file)
  p "Enter query"
  option = gets
  hash = get_table(file)
  while option != "quit"
    query = option.split().map{ |item| item.chomp(",")}
    if query[0].downcase == 'select' and not query.map(&:downcase).include? "limit"
        query.shift
        select(query, hash)
    end
    if query.map(&:downcase).include? "limit"
      limit = query[-1]
      query.shift
      query.pop
      query.pop
      select(query, hash, limit.to_i)
    end
    if query[0].downcase == 'show'
      p hash[0].keys.join(", ")
    end
    if query[0].downcase == 'sum'
      p sum(hash, query[1])
    end
    p "Enter query"
    option = gets
  end
end

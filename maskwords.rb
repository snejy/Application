def maskOutWords(words, text)
    text.tr('^A-Za-z0-9', ' ').split()
    .select { |word| words.map(&:downcase).include? word.downcase }
    .map{ |word| text.gsub! word, '*' * word.size}[0] || text
end

p maskOutWords(["YESTERday", "walk"],  "Yesterday, I took my dog for a walk.\n It was crazy! My dog wanted only food.")
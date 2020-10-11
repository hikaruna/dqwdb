#!/usr/bin/env ruby

require 'csv'

CSV.foreach(ARGV[0], col_sep: "\t", encoding: 'UTF-8') do |row|
    monster = row[1]
    effects_text = row[14]
    effects_text.split(" ").each do |effect_text|
        match_data = /(.+)\+([0-9]+)%?/.match(effect_text)
        effect = match_data[1]
        value = match_data[2]
        puts "INSERT INTO 'こころの特殊効果' ('こころ','グレード','特殊効果','値') VALUES ('#{monster}','S', '#{effect}','#{value}');"
    end
end

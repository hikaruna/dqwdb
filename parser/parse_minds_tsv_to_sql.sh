cat "$1" |
awk -F "\t" '{
    print "INSERT INTO \"こころ\" (\"モンスター\",\"グレード\",\"さいだいHP\",\"さいだいMP\",\"ちから\",\"みのまもり\",\"こうげき魔力\",\"かいふく魔力\",\"すばやさ\",\"きようさ\") VALUES ('\''"$2"'\'','\''S'\'','\''"$4"'\'','\''"$5"'\'','\''"$6"'\'','\''"$8"'\'','\''"$9"'\'','\''"$10"'\'','\''"$11"'\'','\''"$12"'\'');"
}'

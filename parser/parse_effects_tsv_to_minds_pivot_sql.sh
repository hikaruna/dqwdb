
echo 'SELECT `モンスター`'

cat "$1" |
while read line
do
    echo ",max(case when \`名前\` = '${line}' THEN \`値\` END) AS \`${line}\`"
done

cat <<EOS
FROM \`こころview\`
GROUP BY \`モンスター\`, \`グレード\`
;
EOS

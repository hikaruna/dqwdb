cat data.tsv | jq --raw-input --slurp 'split("\n") | map(split("\t")) | .[0:-1] | map( { "monster": .[0], "hp": .[2], "atk": .[3] } )'

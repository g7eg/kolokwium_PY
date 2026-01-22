#!/bin/bash

# Pobierz numer commita z pliku .new/commit_status.txt
commit_file=".new/commit_status.txt"
if [[ ! -f "$commit_file" ]]; then
  echo "0" > "$commit_file"
fi
commit_nr=$(cat "$commit_file")
commit_nr=$((commit_nr + 1))

# Zaktualizuj numer commita w pliku
echo "$commit_nr" > "$commit_file"

# Dodaj wszystkie zmiany
git add -u
git add .

# Dodaj commita z odpowiednim komentarzem
git commit -m "commit nr $commit_nr"

# Wypchnij zmiany, rozwiązując konflikty na korzyść lokalnych plików
git pull --rebase --strategy-option=theirs || git pull --rebase
git push

# # Zaktualizuj numer commita w pliku
# echo "$commit_nr" > "$commit_file"

echo "Commit nr $commit_nr został dodany i wypchnięty."
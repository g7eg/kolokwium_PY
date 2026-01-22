#!/bin/bash

if grep -q "WYKONANO SZTUCZKE" .new/status.txt 2>/dev/null; then
  echo "Sztuczka została już wykonana. Skrypt nie zostanie powtórzony."
  exit 0
fi

for item in *; do
  case "$item" in
    .devcontainer|.git|.gitignore|.new|.scripts|.template|.vscode|LICENSE|status.txt)
      # pomiń te pliki/katalogi
      ;;
    *)
      rm -rf -- "$item"
      ;;
  esac
done

cp .template/* .

echo "Wszystko OK, mozesz przystąpić do realizacji kolokwium. Powodzenia! :)"
echo "WYKONANO SZTUCZKE" > .new/status.txt
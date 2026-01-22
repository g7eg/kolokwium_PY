#!/bin/bash
# rm -f *.py *.txt *.md
# cp .template/* .


for item in *; do
  case "$item" in
    .devcontainer|.git|.gitignore|.new|.scripts|.template|.vscode|LICENSE)
      # pomiń te pliki/katalogi
      ;;
    *)
      rm -rf -- "$item"
      ;;
  esac
done

cp .template/* .

echo "Wszystko przebiegło pomyślnie, mozesz przystapić do realizacji kolokwium."
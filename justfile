all:
    # Compiles all .typ files in the root and stores the result as SVG under `compiled/`.
    for file in *.typ; do typst compile "$file" --format svg "compiled/${file%.typ}.svg"; done

# Watch individual files when editing.

pbm:
    typst watch pbm.typ --open --format svg compiled/pbm.svg

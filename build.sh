#!/bin/bash

# Navigate to the directory containing main.tex
cd "$(dirname "$0")"

# Check if pandoc is installed
if ! command -v pandoc &> /dev/null
then
    echo "Pandoc could not be found. Please install it to continue."
    exit 1
fi

# Create the necessary directories if they don't exist
mkdir -p astro

# Convert the main LaTeX file to Markdown just once
pandoc "main.tex" --bibliography=main.bib --csl=chicago-author-date -o "main.md" --wrap=none --filter filter.py

# Initialize chapter counter
chapter_counter=1

# Split main.md into chapters based on H1 headings
csplit -k -f "chapter" -b "%02d.md" "main.md" "/^# /" "{*}"

# Move and rename each chapter file
for chapter_file in chapter*; do
    # Get the title of the chapter (first line)
    title=$(head -1 "$chapter_file" | sed 's/^# //')

    # Create a valid filename from the title
    base_name=$(echo $title | tr "[:upper:]" "[:lower:]" | tr " " "_" | tr -cd '[:alnum:]_')

    # Remove the first occurrence of the title in the markdown (it will be in the frontmatter)
    tail -n +2 "$chapter_file" > "temp_file.md"
    mv "temp_file.md" "$chapter_file"

    # Add the YAML front matter to the Markdown file
    sed -i "1s;^;---\ntitle: \"$title\"\norder: ${chapter_counter}\n---\n\n;" "$chapter_file"

    # Move the file to the astro directory with a more meaningful name
    mv "$chapter_file" "astro/${base_name}.md"

    echo "Converted chapter ${chapter_counter} to Markdown with front matter and moved to astro/${base_name}.md"

    # Increment the chapter counter
    ((chapter_counter++))
done

echo "All chapters have been converted to Markdown and moved to the astro directory."

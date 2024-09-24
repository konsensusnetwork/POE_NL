import re

# Function to increment the footnote number by 28
def increment_footnote(match):
    number = int(match.group(1))
    return f'[^{number + 23}]'

# File paths
input_file = 'chapters/ch17.qmd'  # Replace with the path to your input file
output_file = 'chapters/ch17.qmd'  # Replace with the path to the output file

# Read the content from the file
with open(input_file, 'r', encoding='utf-8') as file:
    text = file.read()

# Apply the regular expression with the function to increment footnote numbers
new_text = re.sub(r'\[\^(\d+)\]', increment_footnote, text)

# Write the updated content back to a new file (or overwrite the original file if needed)
with open(output_file, 'w', encoding='utf-8') as file:
    file.write(new_text)

print("Footnotes updated and saved to the new file.")

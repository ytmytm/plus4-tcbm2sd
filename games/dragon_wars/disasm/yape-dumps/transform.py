
from pathlib import Path

# Ustalmy ścieżki do plików wejściowych i wyjściowych
input_path = Path("titlepic")
output_path = input_path.with_suffix(".bin")

# Wczytaj cały plik jako bajty
binary_data = input_path.read_bytes()

# Znajdź pierwszy bajt '>' — początek dumpa
start_index = binary_data.find(b'>')

# Każdy wiersz ma stałą długość: od '>' do końca linii
line_length = 0x74 - 0x2d + 1  # czyli 72 bajty

# Wydziel wszystkie linie zaczynające się od '>' co 72 bajty
raw_lines = [
    binary_data[i:i + line_length]
    for i in range(start_index, len(binary_data), line_length)
    if binary_data[i:i + 1] == b'>'
]

# Z każdej linii wyciągamy 16 bajtów, zaczynają się od offsetu 6 (po ">8000 ")
byte_values = []
for line in raw_lines:
    try:
        hex_part = line[6:6 + 47]  # 16 bajtów w hexach + spacje (3*16 - 1)
        hex_strs = hex_part.decode("ascii").strip().split()
        byte_values.extend(int(b, 16) for b in hex_strs)
    except Exception as e:
        print(f"Błąd przy parsowaniu linii: {line}\n{e}")

# Zapisz bajty do pliku binarnego
with output_path.open("wb") as f:
    f.write(bytearray(byte_values))

output_path.name

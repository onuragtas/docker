import json
import os
import sys

def convert_mongo_types(data):
    # Eğer veri bir sözlükse
    if isinstance(data, dict):
        new_data = {}
        for key, value in data.items():
            # `$numberInt` varsa, düz tam sayıya çevir
            if key == "$numberInt" and isinstance(value, str):
                try:
                    return int(value)
                except ValueError:
                    return value
            # `$numberDouble` varsa, düz ondalıklı sayıya çevir
            elif key == "$numberDouble" and isinstance(value, str):
                try:
                    return float(value)
                except ValueError:
                    return value
            else:
                new_data[key] = convert_mongo_types(value)
        return new_data
    # Eğer veri bir listeyse, her öğeyi dönüştür
    elif isinstance(data, list):
        return [convert_mongo_types(item) for item in data]
    else:
        return data

# metadata.json dosyalarını bulmak için dizin
backup_path = sys.argv[1]

for root, dirs, files in os.walk(backup_path):
    for file in files:
        if 'metadata.json' in file:
            file_path = os.path.join(root, file)
            with open(file_path, 'r') as f:
                data = json.load(f)

            # JSON verisini dönüştür
            updated_data = convert_mongo_types(data)

            # Dosyayı güncellenmiş JSON ile tekrar yaz
            with open(file_path, 'w') as f:
                json.dump(updated_data, f, indent=4)

print("Dönüştürme işlemi tamamlandı!")
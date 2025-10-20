import random
import json
import os

# Lists of syllables to combine
prefixes = ["El", "Val", "Nor", "Thal", "Fend", "Riv", "Sil", "Dor", "Mar", "Bel"]
middles = ["an", "or", "en", "ar", "il", "un", "ir", "al", "el", "on"]
suffixes = ["ia", "mere", "wood", "hold", "wick", "bay", "peak", "heim", "gorn", "dale"]

def generate_province_name() -> str:
    """Combine random syllables to create a fictional region name"""
    name = random.choice(prefixes) + random.choice(middles) + random.choice(suffixes)
    return name

def generate_provinces(count: int) -> dict[str, dict]:
    """Generate a set of fictional region names"""
    provinces = {}
    for _ in range(count):
        province = {
            "population": random.randint(1000, 10000),
            "color": "#{:06x}".format(random.randint(0, 0xFFFFFF)),
        }
        provinces[generate_province_name()] = province
    return provinces

def generate_realms(provinces: dict[str, dict]) -> dict[str, dict]:
    """Generate a set of fictional realms containing provinces"""
    realms = {}
    for province_name, province in provinces.items():
        realms[province_name] = {"provinces": [province_name]}
    return realms


# Example usage
if __name__ == "__main__":
    provinces = generate_provinces(200)
    realms = generate_realms(provinces)
    map_data = {"provinces": provinces, "realms": realms}
    with open(os.path.join(__file__, "../map_data.json"), "w") as file:
        file.write(json.dumps(map_data))

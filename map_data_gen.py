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

def generate_provinces(count: int) -> list[dict]:
    """Generate a set of fictional region names"""
    provinces = []
    for _ in range(count):
        province = {
            "name": generate_province_name(),
            "population": random.randint(1000, 10000),
            "color": "#{:06x}".format(random.randint(0, 0xFFFFFF)),
        }
        provinces.append(province)
    return provinces

def generate_realms(provinces: list[dict]) -> dict[str, dict]:
    """Generate a set of fictional realms containing provinces"""
    realms = {}
    for province in provinces:
        # For now, each province will be a seperate realm:
        realms[province["name"]] = {"provinces": [province["name"]]}
    return realms


# Example usage
if __name__ == "__main__":
    provinces = generate_provinces(200)
    realms = generate_realms(provinces)
    map_data = {"provinces": provinces, "realms": realms}
    with open(os.path.join(os.path.dirname(__file__), "map_data.json"), "w") as file:
        file.write(json.dumps(map_data))

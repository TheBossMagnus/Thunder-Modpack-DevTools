import requests
from requests.structures import CaseInsensitiveDict


def update_game_versions():
    auth_token = input("Enter authorization token: ")
    version_id = input("Enter version ID: ")
    game_versions_input = input("Enter game versions separated by commas (e.g., 1.21.4, 1.20.3): ")

    game_versions = [version.strip() for version in game_versions_input.split(",")]

    url = f"https://api.modrinth.com/v2/version/{version_id}"

    headers = CaseInsensitiveDict()
    headers["Authorization"] = auth_token
    headers["Content-Type"] = "application/json"

    data = {"game_versions": game_versions}

    resp = requests.patch(url, headers=headers, json=data)

    if resp.status_code == 200:
        print("Success")
    else:
        print(f"Failed: {resp.status_code}")

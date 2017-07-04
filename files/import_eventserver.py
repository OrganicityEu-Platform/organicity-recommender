"""
Import sample data for similar product engine
"""

import predictionio
import argparse
import requests
import random

def import_events(client):
  print(client.get_status())
  print("Importing user data...")

  users = requests.get('https://accounts.organicity.eu/my/api/v1/users')
  users_json = users.json()
  user_ids = [];
  asset_ids = [];

  user_count = 0;
  for user in users_json:
    client.create_event(
      event="$set",
      entity_type="user",
      entity_id=user["sub"]
    )
    user_ids.append(user["sub"])
    user_count += 1
  print("  user count", user_count)


  print("Importing assets data...")

  sites = requests.get('https://discovery.organicity.eu/v0/assets/sites')
  sites_json = sites.json()

  for site in sites_json:
    counter=1
    while True:
      site_page=requests.get('https://discovery.organicity.eu/v0/assets/sites/' + site["name"].lower() + '?per=500&page=' + str(counter))
      asset_list = site_page.json()

      if not asset_list:
        break

      for asset in asset_list:
        if asset["id"]:
            client.create_event(
              event="$set",
              entity_type="item",
              entity_id=asset["id"],
              properties={
                "categories" : [asset["type"]]
              }
            )
            asset_ids.append(asset["id"])

      counter+=1
  print("  asset count", counter)


  # each user randomly viewed 10 items
  print("Importing random view events...")
  ve_count = 0;
  for user_id in user_ids:
    for viewed_item in random.sample(asset_ids, 10):
      client.create_event(
        event="view",
        entity_type="user",
        entity_id=user_id,
        target_entity_type="item",
        target_entity_id=viewed_item
      )
      ve_count += 1

  print("  view event count", ve_count)
  print("Events, users and assets are now imported.")

if __name__ == '__main__':
  parser = argparse.ArgumentParser(
    description="Import sample data for similar product engine")
  parser.add_argument('--access_key', default='invald_access_key')
  parser.add_argument('--url', default="http://localhost:7070")

  args = parser.parse_args()
  print(args)

  client = predictionio.EventClient(
    access_key=args.access_key,
    url=args.url,
    threads=5,
    qsize=500)
  import_events(client)

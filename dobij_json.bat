@echo off
docker exec mongo_baza mongoexport --host mongo_baza --db=MarkeAutomobila --collection=MarkeAutomobila --out=/exports/novi_json.json --jsonArray --username=user --password=password --authenticationDatabase=admin

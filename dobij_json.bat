docker exec mongo_baza mongoexport --db=MarkeAutomobila --collection=MarkeAutomobila --out=/data/novi_json.json --jsonArray
docker cp mongo_baza:/data/novi_json.json novi_json.json

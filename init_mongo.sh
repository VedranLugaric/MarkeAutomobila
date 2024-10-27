echo "Waiting for MongoDB to start..."
until mongosh --host localhost:27017 -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" --authenticationDatabase admin --eval "db.runCommand({ping: 1})"; do
  sleep 2
done

echo "MongoDB is up. Starting mongorestore..."
#mongorestore --drop --db podaci --host localhost:27017 -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" --authenticationDatabase admin /dump/podaci

mongorestore --drop --nsInclude=MarkeAutomobila.MarkeAutomobila dump/
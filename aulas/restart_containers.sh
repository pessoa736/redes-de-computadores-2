
docker compose down -v
docker compose up -d --build --remove-orphans --force-recreate


echo
echo
echo "abra: http://localhost:8080"


sleep 5 && ./listar-imagems-e-container.sh
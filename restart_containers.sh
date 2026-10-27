
docker compose down -v
sleep 3
docker compose up -d --build --remove-orphans --force-recreate


echo
echo
echo "abra: http://localhost:8080"


sleep 3 && ./listar-imagems-e-container.sh
echo "Docker Installer"

if [ -f ".env" ]; then
  echo ".env already exists"
else
  echo "Creating .env"
  cp -n .env.example .env
fi
echo ""

echo "Please enter projects path"
echo "For example: /project/folder/path"

read -p "Project Folder:" project_path
if [ -z "$project_path" ]
then
      echo "ERROR: Null"
      exit 1
else
    sed -i "s#./sites_folder#$project_path#g" .env
    echo "writed..."
fi

echo ""

echo "Cleaning up..."
docker-compose down
docker-compose up -d --build
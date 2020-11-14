aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 843314631316.dkr.ecr.eu-west-2.amazonaws.com
aws ecr create-repository --repository-name cloud-computing
docker build -t cloud-computing .
docker tag cloud-computing:latest 843314631316.dkr.ecr.eu-west-2.amazonaws.com/cloud-computing:latest
docker push 843314631316.dkr.ecr.eu-west-2.amazonaws.com/cloud-computing:latest
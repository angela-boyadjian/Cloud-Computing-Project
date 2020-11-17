aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 843314631316.dkr.ecr.eu-west-2.amazonaws.com
aws ecr create-repository --repository-name fargate-task
docker build -t fargate-task .
docker tag fargate-task:latest 843314631316.dkr.ecr.eu-west-2.amazonaws.com/fargate-task:latest
docker push 843314631316.dkr.ecr.eu-west-2.amazonaws.com/fargate-task:latest
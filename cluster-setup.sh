aws ec2 create-key-pair \
  --key-name kops \
  | jq -r '.KeyMaterial' \
  >keys/kops.pem

chmod 400 keys/kops.pem

ssh-keygen -y -f keys/kops.pem \
  >keys/kops.pub

aws s3api create-bucket \
  --bucket $BUCKET_NAME \
  --create-bucket-configuration \
  LocationConstraint=$AWS_DEFAULT_REGION

kops create cluster \
  --name $NAME \
  --master-count 3 \
  --node-count 1 \
  --node-size t2.small \
  --master-size t2.small \
  --zones $ZONES \
  --master-zones $ZONES \
  --ssh-public-key keys/kops.pub \
  --networking kubenet \
  --kubernetes-version v1.8.7 \
  --authorization RBAC \
  --yes
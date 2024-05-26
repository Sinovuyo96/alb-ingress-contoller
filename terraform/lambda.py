import boto3
import os

#############################
# Get access keys from role
#############################
def lambda_handler(event, context):

client = boto3.client('sts')
response = client.assume_role(
  RoleArn='arn:aws:iam::339712811345:role/s3-creds-role',
  RoleSessionName='testAssumeRoleSession',
)
print(response)

####################
# Create s3 bucket
####################
response = client.create_bucket(
    Bucket='eks-s3-bucket-config',
)

print(response)

########################
#  Put object to s3
########################

BUCKET = 'eks-s3-bucket-config'
KEY = os.urandom(32)
s3 = boto3.client('s3')

print("Uploading S3 object with SSE-C")
s3.put_object(Bucket=BUCKET,
              #Key='encrypt-key',
              #Body=b'foobar',
              SSECustomerKey=KEY,
              SSECustomerAlgorithm='AES256')
print("Done")

#########################
# Getting the object
#########################

print("Getting S3 object...")
# Note how we're using the same ``KEY`` we
# created earlier.
response = s3.get_object(Bucket=BUCKET,
                         #Key='encrypt-key',
                         SSECustomerKey=KEY,
                         SSECustomerAlgorithm='AES256')
print("Done, response body:")
print(response['Body'].read())


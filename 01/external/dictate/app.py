from __future__ import print_function
import boto3
import os
from contextlib import closing

dynamoDBResource = boto3.resource('dynamodb')
pollyClient = boto3.client('polly')
s3Client = boto3.client('s3', endpoint_url='https://s3.' +
                        os.environ['AWS_REGION'] + '.amazonaws.com')


def lambda_handler(event, context):
    print(event)

    UserId = event["UserId"]
    NoteId = event["NoteId"]
    VoiceId = event['VoiceId']
    mp3Bucket = os.environ['MP3_BUCKET_NAME']
    ddbTable = os.environ['TABLE_NAME']

    text = getNote(dynamoDBResource, ddbTable, UserId, NoteId)
    filePath = createMP3File(pollyClient, text, VoiceId, NoteId)
    signedURL = hostFileOnS3(s3Client, filePath, mp3Bucket, UserId, NoteId)

    return signedURL


def getNote(dynamoDBResource, ddbTable, UserId, NoteId):
    print("getNote Function")

    table = dynamoDBResource.Table(ddbTable)
    records = table.get_item(
        Key={
            'UserId': UserId,
            'NoteId': int(NoteId)
        }
    )

    return records['Item']['Note']


def createMP3File(pollyClient, text, VoiceId, NoteId):
    print("createMP3File Function")

    pollyResponse = pollyClient.synthesize_speech(
        OutputFormat='mp3',
        Text = text,
        VoiceId = VoiceId
    )

    if "AudioStream" in pollyResponse:
        postId = str(NoteId)
        with closing(pollyResponse["AudioStream"]) as stream:
            filePath = os.path.join("/tmp/", postId)
            with open(filePath, "wb") as file:
                file.write(stream.read())

    return filePath


def hostFileOnS3(s3Client, filePath, mp3Bucket, UserId, NoteId):
    print("hostFileOnS3 Function")

    s3Client.upload_file(filePath,
    mp3Bucket,
    UserId+'/'+NoteId+'.mp3')

    os.remove(filePath)

    url = s3Client.generate_presigned_url(
        ClientMethod='get_object',
        Params={
            'Bucket': mp3Bucket,
            'Key': UserId+'/'+NoteId+'.mp3'
        }
    )

    return url

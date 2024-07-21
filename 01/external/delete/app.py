from __future__ import print_function
import boto3
import os

dynamoDBResource = boto3.resource('dynamodb')


def lambda_handler(event, context):
    print(event)

    UserId = event["UserId"]
    NoteId = event["NoteId"]
    ddbTable = os.environ['TABLE_NAME']

    deletedNoteId = deleteItem(dynamoDBResource, ddbTable, UserId, NoteId)

    return deletedNoteId


def deleteItem(dynamoDBResource, ddbTable, UserId, NoteId):
    print('deleteItem function')

    table = dynamoDBResource.Table(ddbTable)

    table.delete_item(
        Key={
            'UserId': UserId,
            'NoteId': int(NoteId)
        }
    )

    return NoteId

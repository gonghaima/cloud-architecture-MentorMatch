const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const { DynamoDBDocumentClient, UpdateCommand } = require('@aws-sdk/lib-dynamodb');

const client = new DynamoDBClient({ region: 'ap-southeast-2' });
const ddbDocClient = DynamoDBDocumentClient.from(client);

exports.handler = async (event) => {
  const userId = event.pathParameters.id;
  const requestBody = JSON.parse(event.body);
  const { role, username, password, address, postcode, offering, studying } = requestBody;

  const params = {
    TableName: process.env.USER_TABLE_NAME,
    Key: { user: userId },
    UpdateExpression: 'set #r = :r, username = :u, password = :p, address = :a, postcode = :pc, offering = :o, studying = :s',
    ExpressionAttributeNames: { '#r': 'role' },
    ExpressionAttributeValues: {
      ':r': role,
      ':u': username,
      ':p': password,
      ':a': address,
      ':pc': postcode,
      ':o': offering,
      ':s': studying,
    },
    ReturnValues: 'UPDATED_NEW',
  };

  try {
    const data = await ddbDocClient.send(new UpdateCommand(params));
    return {
      statusCode: 200,
      body: JSON.stringify({ message: 'User updated successfully', data: data.Attributes }),
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Failed to update user', error: error.message }),
    };
  }
};
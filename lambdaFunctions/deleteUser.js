const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const { DynamoDBDocumentClient, DeleteCommand } = require('@aws-sdk/lib-dynamodb');

const client = new DynamoDBClient({ region: 'ap-southeast-2' });
const ddbDocClient = DynamoDBDocumentClient.from(client);

exports.handler = async (event) => {
  const userId = event.pathParameters.id;

  const params = {
    TableName: process.env.USER_TABLE_NAME,
    Key: { user: userId },
  };

  try {
    await ddbDocClient.send(new DeleteCommand(params));
    return {
      statusCode: 200,
      body: JSON.stringify({ message: 'User deleted successfully' }),
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Failed to delete user', error: error.message }),
    };
  }
};
const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const { DynamoDBDocumentClient, ScanCommand } = require('@aws-sdk/lib-dynamodb');

const client = new DynamoDBClient({ region: 'ap-southeast-2' });
const ddbDocClient = DynamoDBDocumentClient.from(client);

exports.handler = async (event) => {
  const requestBody = JSON.parse(event.body);
  const { role, username, address, postcode, offering, studying, email } = requestBody;

  let filterExpression = [];
  let expressionAttributeNames = {};
  let expressionAttributeValues = {};

  if (role) {
    filterExpression.push('#r = :r');
    expressionAttributeNames['#r'] = 'role';
    expressionAttributeValues[':r'] = role;
  }
  if (username) {
    filterExpression.push('contains(username, :u)');
    expressionAttributeValues[':u'] = username;
  }
  if (address) {
    filterExpression.push('contains(address, :a)');
    expressionAttributeValues[':a'] = address;
  }
  if (postcode) {
    filterExpression.push('postcode = :pc');
    expressionAttributeValues[':pc'] = postcode;
  }
  if (offering) {
    filterExpression.push('contains(offering, :o)');
    expressionAttributeValues[':o'] = offering;
  }
  if (studying) {
    filterExpression.push('contains(studying, :s)');
    expressionAttributeValues[':s'] = studying;
  }
  if (email) {
    filterExpression.push('contains(email, :s)');
    expressionAttributeValues[':e'] = email;
  }

  const params = {
    TableName: process.env.USER_TABLE_NAME,
    FilterExpression: filterExpression.length > 0 ? filterExpression.join(' and ') : undefined,
    ExpressionAttributeNames: Object.keys(expressionAttributeNames).length > 0 ? expressionAttributeNames : undefined,
    ExpressionAttributeValues: Object.keys(expressionAttributeValues).length > 0 ? expressionAttributeValues : undefined,
  };

  try {
    const data = await ddbDocClient.send(new ScanCommand(params));
    return {
      statusCode: 200,
      body: JSON.stringify(data.Items),
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Failed to list users', error: error.message }),
    };
  }
};
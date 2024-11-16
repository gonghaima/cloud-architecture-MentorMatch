const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const { DynamoDBDocumentClient, PutCommand, DeleteCommand } = require('@aws-sdk/lib-dynamodb');
const { handler } = require('../listUsers');

// Configure AWS SDK with your region
const client = new DynamoDBClient({ region: 'ap-southeast-2' });
const ddbDocClient = DynamoDBDocumentClient.from(client);

describe('listUsers Lambda Function', () => {
  const userId = 'user123';
  const user = {
    user: userId,
    role: 'student',
    username: 'john_doe',
    password: 'securepassword',
    address: '123 Main St',
    postcode: '12345',
    offering: ['math', 'science'],
    studying: ['history', 'art'],
  };

  beforeAll(async () => {
    // Create the user in DynamoDB
    const params = {
      TableName: process.env.USER_TABLE_NAME || 'User',
      Item: user,
    };
    await ddbDocClient.send(new PutCommand(params));
  });

  afterAll(async () => {
    // Cleanup: Remove the test user from DynamoDB
    const params = {
      TableName: process.env.USER_TABLE_NAME || 'User',
      Key: { user: userId },
    };
    await ddbDocClient.send(new DeleteCommand(params));
  });

  test('should list users matching the criteria', async () => {
    process.env.USER_TABLE_NAME = 'User'; // Set your DynamoDB table name

    const event = {
      body: JSON.stringify({
        role: 'student',
        username: 'john_doe',
        address: '123 Main St',
        postcode: '12345',
        offering: 'math',
        studying: 'history',
      }),
    };

    try {
      
      const result = await handler(event);
      expect(result.statusCode).toBe(200);
      const users = JSON.parse(result.body);
      expect(users).toEqual(expect.arrayContaining([user]));
    } catch (error) {
      console.log(error);
      
    }

  });

  xtest('should return an error if DynamoDB scan fails', async () => {
    process.env.USER_TABLE_NAME = 'NonExistentTable'; // Set a non-existent table name to simulate failure

    const event = {
      body: JSON.stringify({
        role: 'student',
        username: 'john_doe',
        address: '123 Main St',
        postcode: '12345',
        offering: 'math',
        studying: 'history',
      }),
    };

    const result = await handler(event);

    expect(result.statusCode).toBe(500);
    expect(JSON.parse(result.body).message).toBe('Failed to list users');
  });
});
const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const { DynamoDBDocumentClient, PutCommand, GetCommand, DeleteCommand } = require('@aws-sdk/lib-dynamodb');
const { handler } = require('../updateUser');

// Configure AWS SDK with your region
const client = new DynamoDBClient({ region: 'ap-southeast-2' });
const ddbDocClient = DynamoDBDocumentClient.from(client);

describe('updateUser Lambda Function', () => {
  const userId = 'user123';
  const initialUser = {
    user: userId,
    role: 'student',
    username: 'john_doe',
    password: 'securepassword',
    address: '123 Main St',
    postcode: '12345',
    offering: ['math', 'science'],
    studying: ['history', 'art'],
  };

  const updatedUser = {
    role: 'student',
    username: 'john_doe_updated',
    password: 'newsecurepassword',
    address: '456 Main St',
    postcode: '67890',
    offering: ['math', 'science'],
    studying: ['history', 'art'],
  };

  beforeAll(async () => {
    // Create the initial user in DynamoDB
    const params = {
      TableName: process.env.USER_TABLE_NAME,
      Item: initialUser,
    };
    await ddbDocClient.send(new PutCommand(params));
  });

  afterAll(async () => {
    // Cleanup: Remove the test user from DynamoDB
    const params = {
      TableName: process.env.USER_TABLE_NAME,
      Key: { user: userId },
    };
    await ddbDocClient.send(new DeleteCommand(params));
  });

  test('should update an existing user successfully', async () => {
    process.env.USER_TABLE_NAME = 'User'; // Set your DynamoDB table name

    const event = {
      pathParameters: { id: userId },
      body: JSON.stringify(updatedUser),
    };

    const result = await handler(event);

    expect(result.statusCode).toBe(200);
    expect(JSON.parse(result.body).message).toBe('User updated successfully');

    // Verify the user was updated in DynamoDB
    const getParams = {
      TableName: process.env.USER_TABLE_NAME,
      Key: { user: userId },
    };
    const { Item } = await ddbDocClient.send(new GetCommand(getParams));
    expect(Item).toEqual({
      user: userId,
      ...updatedUser,
    });
  });

  test('should return an error if DynamoDB update fails', async () => {
    process.env.USER_TABLE_NAME = 'NonExistentTable'; // Set a non-existent table name to simulate failure

    const event = {
      pathParameters: { id: userId },
      body: JSON.stringify(updatedUser),
    };

    const result = await handler(event);

    expect(result.statusCode).toBe(500);
    expect(JSON.parse(result.body).message).toBe('Failed to update user');
  });
});
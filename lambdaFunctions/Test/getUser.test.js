const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const { DynamoDBDocumentClient, PutCommand, GetCommand, DeleteCommand } = require('@aws-sdk/lib-dynamodb');
const { handler } = require('../getUser');

// Configure AWS SDK with your region
const client = new DynamoDBClient({ region: 'ap-southeast-2' });
const ddbDocClient = DynamoDBDocumentClient.from(client);

describe('getUser Lambda Function', () => {
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

  test('should get an existing user successfully', async () => {
    process.env.USER_TABLE_NAME = 'User'; // Set your DynamoDB table name

    const event = {
      pathParameters: { id: userId },
    };

    const result = await handler(event);

    expect(result.statusCode).toBe(200);
    const retrievedUser = JSON.parse(result.body);
    expect(retrievedUser).toEqual(user);
  });

  xtest('should return a 404 error if user does not exist', async () => {
    process.env.USER_TABLE_NAME = 'User'; // Set your DynamoDB table name

    const event = {
      pathParameters: { id: 'nonexistent_user' },
    };

    const result = await handler(event);

    expect(result.statusCode).toBe(404);
    expect(JSON.parse(result.body).message).toBe('User not found');
  });

  xtest('should return an error if DynamoDB get fails', async () => {
    process.env.USER_TABLE_NAME = 'NonExistentTable'; // Set a non-existent table name to simulate failure

    const event = {
      pathParameters: { id: userId },
    };

    const result = await handler(event);

    expect(result.statusCode).toBe(500);
    expect(JSON.parse(result.body).message).toBe('Failed to get user');
  });
});
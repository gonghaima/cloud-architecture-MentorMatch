const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const { DynamoDBDocumentClient, GetCommand, DeleteCommand } = require('@aws-sdk/lib-dynamodb');
const { handler } = require('../createUser');

// Configure AWS SDK with your region
const client = new DynamoDBClient({ region: 'ap-southeast-2' });
const ddbDocClient = DynamoDBDocumentClient.from(client);

describe('createUser Lambda Function', () => {
  let event;

  beforeEach(() => {
    event = {
      body: JSON.stringify({
        user: 'user123',
        role: 'student',
        username: 'john_doe',
        password: 'securepassword',
        address: '123 Main St',
        postcode: '12345',
        offering: ['math', 'science'],
        studying: ['history', 'art'],
      }),
    };
  });

  afterEach(async () => {
    // Cleanup: Remove the test user from DynamoDB
    const params = {
      TableName:'User',
      Key: { user: 'user123' },
    };
    await ddbDocClient.send(new DeleteCommand(params));
  });

  test('should create a new user successfully', async () => {
    process.env.USER_TABLE_NAME = 'User'; // Set your DynamoDB table name

    const result = await handler(event);

    expect(result.statusCode).toBe(201);
    expect(JSON.parse(result.body).message).toBe('User created successfully');

    // Verify the user was created in DynamoDB
    const getParams = {
      TableName: process.env.USER_TABLE_NAME,
      Key: { user: 'user123' },
    };
    const { Item } = await ddbDocClient.send(new GetCommand(getParams));
    expect(Item).toEqual({
      user: 'user123',
      role: 'student',
      username: 'john_doe',
      password: 'securepassword',
      address: '123 Main St',
      postcode: '12345',
      offering: ['math', 'science'],
      studying: ['history', 'art'],
    });
  });

  test('should return an error if DynamoDB put fails', async () => {
    process.env.USER_TABLE_NAME = 'NonExistentTable'; // Set a non-existent table name to simulate failure

    const result = await handler(event);

    expect(result.statusCode).toBe(500);
    expect(JSON.parse(result.body).message).toBe('Failed to create user');
  });
});
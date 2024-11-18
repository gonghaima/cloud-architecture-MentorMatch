const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const { DynamoDBDocumentClient, PutCommand } = require('@aws-sdk/lib-dynamodb');

const client = new DynamoDBClient({ region: 'ap-southeast-2' });
const ddbDocClient = DynamoDBDocumentClient.from(client);

exports.handler = async (event) => {
    const requestBody = JSON.parse(event.body);
    const { user, role, username, password, address, postcode, offering, studying } = requestBody;

    const params = {
        TableName: process.env.USER_TABLE_NAME,
        Item: {
            user: user,
            role: role,
            username: username,
            password: password,
            address: address,
            postcode: postcode,
            offering: offering,
            studying: studying,
            ...requestBody,
        },
    };

    try {
        await ddbDocClient.send(new PutCommand(params));
        return {
            statusCode: 201,
            body: JSON.stringify({ message: 'User created successfully' }),
        };
    } catch (error) {
        return {
            statusCode: 500,
            body: JSON.stringify({ message: 'Failed to create user', error: error.message }),
        };
    }
};
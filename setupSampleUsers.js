const { DynamoDBClient, PutItemCommand } = require('@aws-sdk/client-dynamodb');
const { v4: uuidv4 } = require('uuid');

const client = new DynamoDBClient({ region: 'ap-southeast-2' });
const cloudFrontUrl = 'https://dc4174lh3tfw5.cloudfront.net';

const subjects = ['physics', 'math', 'english', 'computing'];
const profilePics = [
  ...Array.from({ length: 50 }, (_, i) => `${cloudFrontUrl}/men${i + 1}.jpg`),
  ...Array.from({ length: 50 }, (_, i) => `${cloudFrontUrl}/women${i + 1}.jpg`)
];

const generateRandomUser = () => {
  const randomSubject = subjects[Math.floor(Math.random() * subjects.length)];
  const randomProfilePic = profilePics[Math.floor(Math.random() * profilePics.length)];

  return {
    password: 'asdf',
    offering: ['math', 'science'],
    role: 'student',
    postcode: '12345',
    studying: ['history', 'art'],
    user: uuidv4(),
    username: `user_${Math.random().toString(36).substring(7)}`,
    address: '123 Main St',
    email: `${Math.random().toString(36).substring(7)}@gmail.com`,
    profilePic: randomProfilePic,
    subject: randomSubject
  };
};

const setupUsers = async (numUsers) => {
  for (let i = 0; i < numUsers; i++) {
    const user = generateRandomUser();
    const params = {
      TableName: 'User',
      Item: {
        password: { S: user.password },
        offering: { SS: user.offering },
        role: { S: user.role },
        postcode: { S: user.postcode },
        studying: { SS: user.studying },
        user: { S: user.user },
        username: { S: user.username },
        address: { S: user.address },
        email: { S: user.email },
        profilePic: { S: user.profilePic },
        subject: { S: user.subject }
      }
    };

    try {
      await client.send(new PutItemCommand(params));
      console.log(`User ${user.username} added successfully.`);
    } catch (error) {
      console.error(`Error adding user ${user.username}:`, error);
    }
  }
};

setupUsers(10); // Add 10 users
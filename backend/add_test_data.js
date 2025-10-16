// This is a Node.js script to add test data to Firestore
// You would normally run this with: node add_test_data.js
// But for now, we'll add data through Firebase CLI or manually through console

const testArticles = [
  {
    title: "Breaking News!",
    description: "This is breaking news! Arnold Schwarzenegger has been seen with a 20 year old male human in the park.",
    content: "This is breaking news! Arnold Schwarzenegger has been seen with a 20 year old male human in the park. Arnold is 78 years old. will he terminate him?",
    author: "John Doe",
    thumbnailURL: "media/articles/test1/thumbnail.jpg",
    publishedAt: new Date("2024-03-23T12:00:00Z"),
    createdAt: new Date("2024-03-23T11:55:00Z"),
    updatedAt: new Date("2024-03-23T12:00:00Z")
  }
];

console.log("Test data prepared. Add this manually through Firebase Console.");
console.log(JSON.stringify(testArticles, null, 2));

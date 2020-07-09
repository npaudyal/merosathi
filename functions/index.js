const functions = require('firebase-functions');


exports.onCreateLikes = functions.firestore
.document("users/{currentUserId}/selectedList/{userId}")
.onCreate( async (snapshot, context) => {
    console.log("Activity feed item created", snapshot.data());

    //Get the user connected to the likes

    const currentUserId = context.params.currentUserId;

    const currentUserRef = admin.firestore().document(`users/${currentUserId}`);

    const doc = await currentUserRef.get();

    //We have user data, check if they have notification token

    const androidNotificationToken = doc.data().androidNotificationToken;

    const createdLikes = snapshot.data();

    if(androidNotificationToken) {
        //send Notification

        sendNotification(androidNotificationToken, createdLikes);

    } else {
        console.log("No token")

    }

    function sendNotification(androidNotificationToken, userId) {
        
        const body = `${userId.name} liked you!`

    }

    //Create message for push notification

    const message = {
        notification: {body},
        token : androidNotificationToken,
        data : {recipient: currentUserId}
    }

    // Send message with admin.messaging

    admin
        .messaging().send(message)
        .then(response => {
            console.log("Successfully sent message", response);
        })
        .catch(error => {
            console.log("Error", error);
        })


})

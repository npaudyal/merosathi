const functions = require('firebase-functions');



exports.getMatches = functions.firestore.document('/users/{userId}/{collection}/{documentId}')
.onCreate( async (snap, context) => {

    const userId = context.params.userId;
    
    
    let getchosenId = await admin.firestore
    .collection("users")
    .doc(userId)
    .collection("chosenList")
    .get();
    

    let getSelectedId = admin.firestore
    .collection("users")
    .doc(userId)
    .collection("selectedList")
    .get();

    var matchedids = [];
    const matches = admin.firestore().collection('matchedList');


    for(docs in getchosenId) {
        for(doc in getSelectedId) {
            if(doc.documentId === docs.getchosenId) {
                 matches.add(docs);
            } else {
                return
            }
        }
    }  
    

})

const functions = require("firebase-functions");


const fs = require("fs");
const admin = require("firebase-admin");
admin.initializeApp();

exports.dynamicMetaTagsUpdate = functions.https.onRequest(async (request, response) => {
let html = fs.readFileSync("./web/index.html", "utf8");
const id = request.query.id;


const database = admin.firestore();
    try {
      // console.log("running try");
      const ref = await admin.firestore().collection('salons').doc(id);
      const chartData = ref.get().then((snapshot) => {
        if (snapshot.exists()) {
          // Gets the chart data stocks for seo tags
          const seoTags = [];
          snapshot.child("salons").val().forEach((element, index, array) => {
            seoTags.push(element.salonName,element.description);
          });
          // Add the y and x vaules from chart data to be used in seo tags
          seoTags.push(snapshot.child("salonName").val(), snapshot.child("description").val());
          const object = {salonName: snapshot.child("salonName").val(), description: snapshot.child("description").val(),  seoTags: seoTags,};
          return object;
        } else {
          console.log("No data available");
        }
      }).catch((error) => {
        console.error(error);
      });
      const htmlData = await chartData;
            // HTML to return with updated open graph meta tags
            html = `
                  <!doctype html>
                  <html lang="en">
                    <head>
                   <meta name="apple-mobile-web-app-title" content=${htmlData.description}>
                     <link rel="apple-touch-icon" href="icons/Icon-192.png">

                     <!-- Favicon -->
                     <link rel="icon" type="image/png" href="favicon.png"/>

                     <title>${htmlData.salonName}</title>
                     <link rel="manifest" href="manifest.json">

                    </head>

                  </html>
                  `;
      return response.send(html);
    } catch (e) {
      console.log(e);
      return response.send(html);
    }

});


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

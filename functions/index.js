/**
 * Firebase Cloud Functions for L'Alternative App
 *
 * This file contains functions to send push notifications
 * to users even when the app is killed.
 */

const {onRequest} = require("firebase-functions/v2/https");
const {onSchedule} = require("firebase-functions/v2/scheduler");
const {onValueWritten} = require("firebase-functions/v2/database");
const admin = require("firebase-admin");
const logger = require("firebase-functions/logger");

// Initialize Firebase Admin
admin.initializeApp();

/**
 * Send a notification to a specific user
 *
 * HTTP Endpoint: POST /sendNotification
 * Body: {
 *   userId: string,
 *   title: string,
 *   body: string,
 *   data: object (optional)
 * }
 */
exports.sendNotification = onRequest({
  cors: true,
}, async (req, res) => {
  try {
    if (req.method !== "POST") {
      res.status(405).send("Method Not Allowed");
      return;
    }

    const {userId, title, body, data} = req.body;

    if (!userId || !title || !body) {
      res.status(400).send({
        error: "Missing required fields: userId, title, body",
      });
      return;
    }

    // Get user's FCM token from database
    const tokenSnapshot = await admin.database()
        .ref(`users/${userId}/fcmToken/token`)
        .once("value");

    const fcmToken = tokenSnapshot.val();

    if (!fcmToken) {
      logger.warn(`No FCM token found for user ${userId}`);
      res.status(404).send({error: "User FCM token not found"});
      return;
    }

    // Prepare notification payload
    const message = {
      notification: {
        title: title,
        body: body,
      },
      data: data || {},
      token: fcmToken,
      android: {
        priority: "high",
        notification: {
          channelId: "high_importance_channel",
          priority: "high",
        },
      },
      apns: {
        payload: {
          aps: {
            contentAvailable: true,
            sound: "default",
          },
        },
      },
    };

    // Send notification
    const response = await admin.messaging().send(message);
    logger.info(`Notification sent successfully to ${userId}:`, response);

    res.status(200).send({
      success: true,
      messageId: response,
    });
  } catch (error) {
    logger.error("Error sending notification:", error);
    res.status(500).send({
      error: "Failed to send notification",
      details: error.message,
    });
  }
});

/**
 * Send notifications to multiple users by topic
 *
 * HTTP Endpoint: POST /sendNotificationToTopic
 * Body: {
 *   topic: string,
 *   title: string,
 *   body: string,
 *   data: object (optional)
 * }
 */
exports.sendNotificationToTopic = onRequest({
  cors: true,
}, async (req, res) => {
  try {
    if (req.method !== "POST") {
      res.status(405).send("Method Not Allowed");
      return;
    }

    const {topic, title, body, data} = req.body;

    if (!topic || !title || !body) {
      res.status(400).send({
        error: "Missing required fields: topic, title, body",
      });
      return;
    }

    // Prepare notification payload
    const message = {
      notification: {
        title: title,
        body: body,
      },
      data: data || {},
      topic: topic,
      android: {
        priority: "high",
        notification: {
          channelId: "high_importance_channel",
          priority: "high",
        },
      },
      apns: {
        payload: {
          aps: {
            contentAvailable: true,
            sound: "default",
          },
        },
      },
    };

    // Send notification to topic
    const response = await admin.messaging().send(message);
    logger.info(`Notification sent to topic ${topic}:`, response);

    res.status(200).send({
      success: true,
      messageId: response,
    });
  } catch (error) {
    logger.error("Error sending notification to topic:", error);
    res.status(500).send({
      error: "Failed to send notification",
      details: error.message,
    });
  }
});

/**
 * Schedule a notification to be sent after a delay
 *
 * HTTP Endpoint: POST /scheduleNotification
 * Body: {
 *   userId: string,
 *   title: string,
 *   body: string,
 *   delaySeconds: number,
 *   data: object (optional)
 * }
 */
exports.scheduleNotification = onRequest({
  cors: true,
}, async (req, res) => {
  try {
    if (req.method !== "POST") {
      res.status(405).send("Method Not Allowed");
      return;
    }

    const {userId, title, body, delaySeconds, data} = req.body;

    if (!userId || !title || !body || !delaySeconds) {
      res.status(400).send({
        error: "Missing required fields: userId, title, body, delaySeconds",
      });
      return;
    }

    // Get user's FCM token from database
    const tokenSnapshot = await admin.database()
        .ref(`users/${userId}/fcmToken/token`)
        .once("value");

    const fcmToken = tokenSnapshot.val();

    if (!fcmToken) {
      logger.warn(`No FCM token found for user ${userId}`);
      res.status(404).send({error: "User FCM token not found"});
      return;
    }

    // Schedule the notification using setTimeout
    // Note: In production, use Cloud Tasks or Pub/Sub for reliability
    setTimeout(async () => {
      try {
        // Prepare notification payload
        const message = {
          notification: {
            title: title,
            body: body,
          },
          data: data || {},
          token: fcmToken,
          android: {
            priority: "high",
            notification: {
              channelId: "high_importance_channel",
              priority: "high",
            },
          },
          apns: {
            payload: {
              aps: {
                contentAvailable: true,
                sound: "default",
              },
            },
          },
        };

        // Send notification
        const response = await admin.messaging().send(message);
        logger.info(
            `Scheduled notification sent to ${userId}:`,
            response,
        );
      } catch (error) {
        logger.error("Error sending scheduled notification:", error);
      }
    }, delaySeconds * 1000);

    logger.info(
        `Notification scheduled for ${userId} in ${delaySeconds} seconds`,
    );

    res.status(200).send({
      success: true,
      message: `Notification scheduled in ${delaySeconds} seconds`,
    });
  } catch (error) {
    logger.error("Error scheduling notification:", error);
    res.status(500).send({
      error: "Failed to schedule notification",
      details: error.message,
    });
  }
});

///**
// * Scheduled function to send daily reminders
// * Runs every day at 9 AM (adjust as needed)
// *
// * Configure in Firebase Console or via CLI:
// * firebase deploy --only functions:sendDailyReminders
// */
//exports.sendDailyReminders = onSchedule({
//  schedule: "0 9 * * *", // Every day at 9 AM
//  timeZone: "Europe/Paris", // Adjust to your timezone
//}, async (event) => {
//  try {
//    logger.info("Starting daily reminder job");
//
//    // Get all users who have enabled daily reminders
//    const usersSnapshot = await admin.database()
//        .ref("users")
//        .once("value");
//
//    const users = usersSnapshot.val();
//    const notifications = [];
//
//    // Iterate through users and send notifications
//    for (const [userId, userData] of Object.entries(users)) {
//      if (userData.fcmToken && userData.fcmToken.token) {
//        // Check if user has reminders enabled
//        if (userData.settings?.dailyReminder !== false) {
//          const message = {
//            notification: {
//              title: "Bonjour ! 🌞",
//              body: "N'oubliez pas de prendre un moment pour vous aujourd'hui",
//            },
//            token: userData.fcmToken.token,
//            android: {
//              priority: "high",
//              notification: {
//                channelId: "high_importance_channel",
//                priority: "high",
//              },
//            },
//            apns: {
//              payload: {
//                aps: {
//                  contentAvailable: true,
//                  sound: "default",
//                },
//              },
//            },
//          };
//
//          notifications.push(
//              admin.messaging().send(message)
//                  .then((response) => {
//                    logger.info(
//                        `Reminder sent to ${userId}: ${response}`,
//                    );
//                    return {userId, success: true};
//                  })
//                  .catch((error) => {
//                    logger.error(
//                        `Failed to send to ${userId}:`,
//                        error,
//                    );
//                    return {userId, success: false, error: error.message};
//                  }),
//          );
//        }
//      }
//    }
//
//    // Wait for all notifications to be sent
//    const results = await Promise.all(notifications);
//    const successCount = results.filter((r) => r.success).length;
//    const failCount = results.filter((r) => !r.success).length;
//
//    logger.info(
//        `Daily reminders completed. Success: ${successCount}, Failed: ${failCount}`,
//    );
//  } catch (error) {
//    logger.error("Error in daily reminders job:", error);
//  }
//});

/**
 * Trigger notification when a new activity is completed
 * This listens to database changes and sends congratulations
 *
 * NOTE: Commented out due to database region configuration
 * To enable: Configure the correct database instance and region
 */
/*
exports.onActivityCompleted = onValueWritten({
  ref: "/activites/{activityId}",
  instance: "l-alternative-bf37d-default-rtdb", // Specify the database instance
  region: "europe-west1", // Change to your database region
}, async (event) => {
  try {
    const beforeData = event.data.before.val();
    const afterData = event.data.after.val();

    // Check if activity was just completed
    if (!beforeData.isCompleted && afterData.isCompleted) {
      logger.info(
          `Activity ${event.params.activityId} was completed`,
      );

      // Get all users to send congratulations
      // In a real app, you'd only send to the user who completed it
      const usersSnapshot = await admin.database()
          .ref("users")
          .once("value");

      const users = usersSnapshot.val();
      const notifications = [];

      for (const [userId, userData] of Object.entries(users)) {
        if (userData.fcmToken && userData.fcmToken.token) {
          const message = {
            notification: {
              title: "Félicitations ! 🎉",
              body: `Vous avez complété: ${afterData.title}`,
            },
            data: {
              activityId: event.params.activityId,
              type: "activity_completed",
            },
            token: userData.fcmToken.token,
            android: {
              priority: "high",
              notification: {
                channelId: "high_importance_channel",
                priority: "high",
              },
            },
          };

          notifications.push(
              admin.messaging().send(message)
                  .catch((error) => {
                    logger.error(
                        `Failed to send completion notification to ${userId}:`,
                        error,
                    );
                  }),
          );
        }
      }

      await Promise.all(notifications);
      logger.info("Activity completion notifications sent");
    }
  } catch (error) {
    logger.error("Error in onActivityCompleted:", error);
  }
});
*/

/**
 * Clean up expired FCM tokens
 * Runs daily to remove invalid tokens
 */
exports.cleanupExpiredTokens = onSchedule({
  schedule: "0 2 * * *", // Every day at 2 AM
  timeZone: "Europe/Paris",
}, async (event) => {
  try {
    logger.info("Starting token cleanup job");

    const usersSnapshot = await admin.database()
        .ref("users")
        .once("value");

    const users = usersSnapshot.val();
    let removedCount = 0;

    for (const [userId, userData] of Object.entries(users)) {
      if (userData.fcmToken && userData.fcmToken.token) {
        // Check token age (older than 60 days)
        const tokenAge = Date.now() - (userData.fcmToken.updatedAt || 0);
        const sixtyDays = 60 * 24 * 60 * 60 * 1000;

        if (tokenAge > sixtyDays) {
          try {
            // Try to send a test message
            await admin.messaging().send({
              token: userData.fcmToken.token,
              data: {type: "test"},
              dryRun: true,
            });
          } catch (error) {
            // If token is invalid, remove it
            if (error.code === "messaging/invalid-registration-token" ||
                error.code === "messaging/registration-token-not-registered") {
              await admin.database()
                  .ref(`users/${userId}/fcmToken`)
                  .remove();
              removedCount++;
              logger.info(`Removed invalid token for user ${userId}`);
            }
          }
        }
      }
    }

    logger.info(`Token cleanup completed. Removed ${removedCount} tokens`);
  } catch (error) {
    logger.error("Error in token cleanup job:", error);
  }
});

package io.lbp

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import android.util.Log
import com.onesignal.NotificationExtenderService
import com.onesignal.OSNotificationReceivedResult

object MyData {
    const val TABLE_NAME = "notifications"
    const val NOTIFICATION_ID = "notification_id"
    const val TITLE = "title"
    const val DESC = "message"
    const val COMPLETED = "completed"
}

class MyDbHelper(context: Context) : SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION ) {

    override fun onCreate(db: SQLiteDatabase) {}

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        onCreate(db)
    }
    companion object {
        const val DATABASE_VERSION = 1
        const val DATABASE_NAME = "database.db"
    }
}

class CustomNotificationExtender : NotificationExtenderService() {
    override fun onNotificationProcessing(receivedResult: OSNotificationReceivedResult): Boolean {
        try {
            if (receivedResult.isAppInFocus || receivedResult.restoring) {
                Log.i("ExtenderIgnored", "App is in focus or restoring")
                return false
            }

            val title = receivedResult.payload.title
            val notificationId = receivedResult.payload.notificationID

            val context = baseContext
            val dbHelper = MyDbHelper(context)
            val db =  dbHelper.writableDatabase

            val values = ContentValues()
            values.put(MyData.NOTIFICATION_ID, notificationId)
            values.put(MyData.TITLE, title)
            values.put(MyData.DESC, "Click to open")
            values.put(MyData.COMPLETED, false)

            db.insert(MyData.TABLE_NAME, null, values)
            db.close()
            return false
        } catch (e: Exception) {
            // Report it to an external service if you wish
            Log.e("NotifExtenderServiceErr", e.toString())
            return false
        }
    }
}
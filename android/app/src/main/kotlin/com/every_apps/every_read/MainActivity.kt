// MainActivity.kt
package com.every_apps.every_read

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.io.InputStream
import android.provider.OpenableColumns
import android.database.Cursor


class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.every_apps.every_read/file_selector"
    private val FILE_PICKER_REQUEST_CODE = 1001

    private var resultPending: MethodChannel.Result? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
           when (call.method)  {
            "openFilePicker" ->  {
                resultPending = result
                openFilePicker()
            }
            "readFileBytes" -> {
                val uriString = call.argument<String>("uri")
                if (uriString != null) {
                    val bytes = readBytesFromUri(Uri.parse(uriString))
                    if (bytes != null) {
                        result.success(bytes)
                    } else {
                        result.error("READ_ERROR", "Can't read file", null)
                    }
                } else {
                    result.error("INVALID_URI", "URI not passed", null)
                }
            }
           "getFileName" -> {
               val uriString = call.argument<String>("uri")
               if (uriString != null) {
                   val fileName = getFileName(Uri.parse(uriString))
                   if (fileName != null) {
                       result.success(fileName)
                   } else {
                       result.error("FILE_NAME_ERROR", "Can't resolve filename", null)
                   }
               } else {
                   result.error("INVALID_URI", "URI not passed", null)
               }
            }
            else -> result.notImplemented()
            }
        }
    }

    private fun openFilePicker() {
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "*/*"
            putExtra(Intent.EXTRA_MIME_TYPES, arrayOf("application/pdf", "application/octet-stream"))
            addFlags(Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }
        try {
            startActivityForResult(intent, FILE_PICKER_REQUEST_CODE)
        } catch (e: ActivityNotFoundException) {
            resultPending?.error("NO_ACTIVITY", "Not application for open PDF", null)
            resultPending = null
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == FILE_PICKER_REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                data?.data?.let { uri ->
                   try {
                    contentResolver.takePersistableUriPermission(
                        uri,
                        Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                    )
                    resultPending?.success(uri.toString())
                   } catch (e: SecurityException) {
                       resultPending?.error("PERMISSION_ERROR", "Can't get permission for URI", null)
                   }
                } ?: run {
                    resultPending?.error("NO_URI", "URI not resolved", null)
                }
            } else {
                resultPending?.error("CANCELLED", "File selection canceled", null)
            }
            resultPending = null
        } else {
            super.onActivityResult(requestCode, resultCode, data)
        }
    }

    private fun readBytesFromUri(uri: Uri): ByteArray? {
        return try {
            val inputStream: InputStream? = contentResolver.openInputStream(uri)
            val buffer = ByteArray(1024)
            val outputStream = ByteArrayOutputStream()
            var bytesRead: Int = 0
            while (inputStream?.read(buffer).also { bytesRead = it ?: -1 } != -1) {
                outputStream.write(buffer, 0, bytesRead)
            }
            inputStream?.close()
            outputStream.toByteArray()
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    private fun getFileName(uri: Uri): String? {
        var result: String? = null
        if (uri.scheme == "content") {
            val cursor: Cursor? = contentResolver.query(uri, null, null, null, null)
            try {
                if (cursor != null && cursor.moveToFirst()) {
                    val nameIndex = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                    if (nameIndex != -1) {
                        result = cursor.getString(nameIndex)
                    }
                }
            } finally {
                cursor?.close()
            }
        }
        if (result == null) {
            result = uri.path
            val cut = result?.lastIndexOf('/')
            if (cut != -1 && cut != null) {
                result = result?.substring(cut + 1)
            }
        }
        return result
    }
}

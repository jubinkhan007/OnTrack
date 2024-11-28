package com.prangroup.mis93.tmbi

import android.widget.Toast
import com.prangroup.mis93.tmbi.utils.AWSService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File

class MainActivity : FlutterActivity() {
    private val channelName = "aws_service_channel"
    private val methodName = "upload_file"
    private lateinit var awsService: AWSService

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call: MethodCall, result: Result ->
                if (call.method == methodName) {
                    awsService = AWSService(this, onSuccess = { _, message ->
                        result.success(message)
                    }, onError = { _, message -> result.success(message) })
                    val filePaths: List<String>? = call.argument("args")
                    if (filePaths != null) {
                        val file = File(filePaths[0])
                        awsService.uploadFile(file)
                        Toast.makeText(this, "${filePaths[0]}", Toast.LENGTH_SHORT).show()
                        //result.success("SUCCESS")
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
}

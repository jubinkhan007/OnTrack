package com.whelksoft.flutter_native_timezone

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.*

class FlutterNativeTimezonePlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        setupMethodChannel(binding.binaryMessenger)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getLocalTimezone" -> result.success(getLocalTimezone())

            "getAvailableTimezones" -> result.success(getAvailableTimezones())

            else -> result.notImplemented()
        }
    }

    private fun getLocalTimezone(): String {
        // Always use java.util.TimeZone to avoid java.time desugaring requirements.
        return TimeZone.getDefault().id
    }

    private fun getAvailableTimezones(): List<String> {
        return TimeZone.getAvailableIDs().toCollection(ArrayList())
    }

    private fun setupMethodChannel(messenger: BinaryMessenger) {
        channel = MethodChannel(messenger, "flutter_native_timezone")
        channel.setMethodCallHandler(this)
    }
}

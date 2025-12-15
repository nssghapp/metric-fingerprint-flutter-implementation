package com.example.fingerprint_sdk_2

import android.os.Bundle
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.metric.fingerprint.ui.*
import com.metric.fingerprint.ui.contract.*
import com.metric.fingerprint.core.*

class MainActivity : FlutterFragmentActivity(){
    private val CHANNEL = "com.metric.metric-sdk/fingerprint"
    private var pendingResult: MethodChannel.Result? = null

    // Register BEFORE onCreate using lazy or direct initialization
    private val fingerprintLauncher: ActivityResultLauncher<FingerprintAuthRequest> =
        registerForActivityResult(FingerprintAuthContract()) { result ->
            when (result) {
                is FingerprintAuthResult.Success -> {
                    pendingResult?.success(mapOf(
                        "status" to "SUCCESS",
                        "name" to result.name,
                        "suid" to result.suid
                    ))
                }
                is FingerprintAuthResult.Error -> {
                    pendingResult?.success(mapOf(
                        "status" to "ERROR",
                        "message" to result.message
                    ))
                }
                is FingerprintAuthResult.Cancelled -> {
                    pendingResult?.success(mapOf(
                        "status" to "CANCELLED"
                    ))
                }
            }
            pendingResult = null
        }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "startFingerprintAuth") {
                val token = call.argument<String>("verification_token")
                if (token != null) {
                    pendingResult = result
                    fingerprintLauncher.launch(FingerprintAuthRequest(token = token))
                } else {
                    result.error("INVALID_TOKEN", "Verification token is required", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}

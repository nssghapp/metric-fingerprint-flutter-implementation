package com.example.fingerprint_sdk_2

import android.app.Application
import com.metric.fingerprint.ui.*
import com.metric.fingerprint.core.*

class MetricFingerprintApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        
        MetricFingerprint.init(
            context = this,
            theme = FingerprintTheme(
                companyName = "Aaron's Company",
                logo = Logo.Url("https://example.com/logo.png"),
                color = "#f7cd46"
            ),
            clientKey = "CLIENT-KEY-HERE",
            secretKey = "SECRET-KEY-HERE",
            environment = Environment.PROD
        )
        
    }
}
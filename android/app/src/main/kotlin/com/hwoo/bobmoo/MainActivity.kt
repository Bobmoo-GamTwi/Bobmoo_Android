package com.hwoo.bobmoo

import androidx.annotation.NonNull
import com.hwoo.bobmoo.widget.WidgetUpdateManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // 2. MethodChannel 설정
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "refreshWidgetsNow" -> {
                    WidgetUpdateManager.triggerImmediateUpdate(this)
                    WidgetUpdateManager.scheduleUpdate(this)
                    result.success(true)
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}

package com.hwoo.bobmoo

import android.app.AlarmManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    // 1. Flutter와 통신할 채널 이름 정의
    private val CHANNEL = "com.hwoo.bobmoo/alarm_permission"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // 2. MethodChannel 설정
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                // 3. Flutter에서 'canScheduleExactAlarms'를 호출했을 때 실행될 코드
                "canScheduleExactAlarms" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                        val alarmManager =
                            context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
                        result.success(alarmManager.canScheduleExactAlarms())
                    } else {
                        // 안드로이드 12 미만 버전에서는 이 권한이 없으므로 항상 true를 반환
                        result.success(true)
                    }
                }
                // 4. Flutter에서 'openAlarmPermissionSettings'를 호출했을 때 실행될 코드
                "openAlarmPermissionSettings" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                        // '알람 및 리마인더' 설정 화면으로 바로 이동하는 Intent
                        val intent = Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM).apply {
                            data = Uri.fromParts("package", packageName, null)
                        }
                        startActivity(intent)
                        result.success(true)
                    } else {
                        // 안드로이드 12 미만에서는 해당 설정 화면이 없으므로 아무것도 안 함
                        result.success(false)
                    }
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}

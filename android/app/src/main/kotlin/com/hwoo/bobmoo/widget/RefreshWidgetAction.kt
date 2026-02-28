package com.hwoo.bobmoo.widget

import android.content.Context
import androidx.glance.GlanceId
import androidx.glance.action.ActionCallback
import androidx.glance.action.ActionParameters

class RefreshWidgetAction : ActionCallback {
    override suspend fun onAction(
        context: Context,
        glanceId: GlanceId,
        parameters: ActionParameters
    ) {
        WidgetUpdateManager.triggerImmediateUpdate(context)
        WidgetUpdateManager.scheduleUpdate(context)
    }
}

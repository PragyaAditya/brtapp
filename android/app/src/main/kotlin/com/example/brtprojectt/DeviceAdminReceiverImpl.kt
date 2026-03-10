package com.example.brtprojectt

import android.app.admin.DeviceAdminReceiver
import android.content.Context
import android.content.Intent
import android.widget.Toast

class DeviceAdminReceiverImpl : DeviceAdminReceiver() {
    override fun onEnabled(context: Context, intent: Intent) {
        super.onEnabled(context, intent)
        
        // Persist the QR provisioning status from the initial intent
        val extras = intent.getBundleExtra(android.app.admin.DevicePolicyManager.EXTRA_PROVISIONING_ADMIN_EXTRAS_BUNDLE)
        val isQr = extras?.getBoolean("is_provisioned_by_qr") ?: false
        
        if (isQr) {
            val prefs = context.getSharedPreferences("admin_prefs", Context.MODE_PRIVATE)
            prefs.edit().putBoolean("is_provisioned_by_qr", true).apply()
        }

        Toast.makeText(context, "Device Owner Enabled", Toast.LENGTH_SHORT).show()
    }

    override fun onDisabled(context: Context, intent: Intent) {
        super.onDisabled(context, intent)
        Toast.makeText(context, "Device Owner Disabled", Toast.LENGTH_SHORT).show()
    }
}

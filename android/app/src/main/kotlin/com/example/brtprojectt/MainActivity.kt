package com.example.brtprojectt

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.device_owner/policy"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            val dpm = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
            val adminComponent = ComponentName(this, DeviceAdminReceiverImpl::class.java)

            when (call.method) {
                "isDeviceOwnerActive" -> {
                    result.success(dpm.isDeviceOwnerApp(packageName))
                }
                "setUninstallBlocked" -> {
                    val block = call.argument<Boolean>("blocked") ?: false
                    try {
                        if (dpm.isDeviceOwnerApp(packageName)) {
                            dpm.setUninstallBlocked(adminComponent, packageName, block)
                            result.success(true)
                        } else {
                            result.error("NOT_DEVICE_OWNER", "App is not device owner", null)
                        }
                    } catch (e: Exception) {
                        result.error("ERROR", e.message, null)
                    }
                }
                "isUninstallBlocked" -> {
                    try {
                        if (dpm.isDeviceOwnerApp(packageName)) {
                            result.success(dpm.isUninstallBlocked(adminComponent, packageName))
                        } else {
                            result.success(false)
                        }
                    } catch (e: Exception) {
                        result.error("ERROR", e.message, null)
                    }
                }
                "isProvisionedViaQR" -> {
                    try {
                        // First check SharedPreferences for persistent status
                        val prefs = getSharedPreferences("admin_prefs", Context.MODE_PRIVATE)
                        var isQr = prefs.getBoolean("is_provisioned_by_qr", false)
                        
                        // Fallback to initial intent if prefs not found yet
                        if (!isQr) {
                            val extras = intent?.getBundleExtra(DevicePolicyManager.EXTRA_PROVISIONING_ADMIN_EXTRAS_BUNDLE)
                            isQr = extras?.getBoolean("is_provisioned_by_qr") ?: false
                        }
                        
                        result.success(isQr)
                    } catch (e: Exception) {
                        result.success(false)
                    }
                }
                "setFactoryResetDisabled" -> {
                    val disabled = call.argument<Boolean>("disabled") ?: false
                    try {
                        if (dpm.isDeviceOwnerApp(packageName)) {
                            if (disabled) {
                                dpm.addUserRestriction(adminComponent, "no_factory_reset")
                            } else {
                                dpm.clearUserRestriction(adminComponent, "no_factory_reset")
                            }
                            result.success(true)
                        } else {
                            result.error("NOT_DEVICE_OWNER", "App is not device owner", null)
                        }
                    } catch (e: Exception) {
                        result.error("ERROR", e.message, null)
                    }
                }
                "isFactoryResetDisabled" -> {
                    try {
                        val restrictions = dpm.getUserRestrictions(adminComponent)
                        result.success(restrictions.getBoolean("no_factory_reset", false))
                    } catch (e: Exception) {
                        result.error("ERROR", e.message, null)
                    }
                }
                "setFRPAccount" -> {
                    val accountId = call.argument<String>("email") ?: ""
                    try {
                        if (dpm.isDeviceOwnerApp(packageName)) {
                            // 1. Legacy GMS Approach (Requires Numeric ID for older devices like Vivo Y81)
                            val bundle = android.os.Bundle()
                            bundle.putStringArray("factoryResetProtectionAccounts", arrayOf(accountId))
                            dpm.setApplicationRestrictions(adminComponent, "com.google.android.gms", bundle)

                            // 2. Modern Android Enterprise Approach (API 30+)
                            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.R) {
                                val policy = android.app.admin.FactoryResetProtectionPolicy.Builder()
                                    .setFactoryResetProtectionAccounts(listOf(accountId))
                                    .setFactoryResetProtectionEnabled(true)
                                    .build()
                                dpm.setFactoryResetProtectionPolicy(adminComponent, policy)
                            }
                            
                            // PERSIST state so UI can show it
                            val prefs = getSharedPreferences("admin_prefs", Context.MODE_PRIVATE)
                            prefs.edit().putString("frp_account", accountId).apply()
                            
                            result.success(true)
                        } else {
                            result.error("NOT_DEVICE_OWNER", "App is not device owner", null)
                        }
                    } catch (e: Exception) {
                        result.error("ERROR", e.message, null)
                    }
                }
                "getFRPAccount" -> {
                    val prefs = getSharedPreferences("admin_prefs", Context.MODE_PRIVATE)
                    result.success(prefs.getString("frp_account", null))
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}

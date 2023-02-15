package com.example.torch_light_app

import io.flutter.embedding.android.FlutterActivity

import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.content.Context
import android.hardware.camera2.CameraManager
import android.hardware.camera2.CameraAccessException
import android.os.Build
import androidx.annotation.RequiresApi


class MainActivity: FlutterActivity() {
    @RequiresApi(Build.VERSION_CODES.M)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

         lateinit var cameraId: String
         lateinit var cameraManager: CameraManager

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "example.com/channel").setMethodCallHandler {
                call, result ->
            if(call.method == "switchOnTorch") {
                    try {
                        cameraManager = getSystemService(Context.CAMERA_SERVICE) as CameraManager
                        cameraId = cameraManager.cameraIdList[0]
                        cameraManager.setTorchMode(cameraId, true)

                        result.success(true)
                    } catch (e: CameraAccessException) {
                        e.printStackTrace()
                    }
            }
            else if(call.method == "switchOffTorch") {
                try {
                    cameraManager.setTorchMode(cameraId, false)
                    result.success(true)
                } catch (e: CameraAccessException) {
                    e.printStackTrace()
                }
            }

        }
    }
}



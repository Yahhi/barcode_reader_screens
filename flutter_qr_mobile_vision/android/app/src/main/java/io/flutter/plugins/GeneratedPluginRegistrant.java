package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.github.rmtmckenzie.nativedeviceorientation.NativeDeviceOrientationPlugin;
import com.github.rmtmckenzie.qrmobilevision.QrMobileVisionPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    NativeDeviceOrientationPlugin.registerWith(registry.registrarFor("com.github.rmtmckenzie.nativedeviceorientation.NativeDeviceOrientationPlugin"));
    QrMobileVisionPlugin.registerWith(registry.registrarFor("com.github.rmtmckenzie.qrmobilevision.QrMobileVisionPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}

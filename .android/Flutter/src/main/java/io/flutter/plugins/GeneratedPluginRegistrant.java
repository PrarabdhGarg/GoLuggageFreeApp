package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import flutter.plugins.contactsservice.contactsservice.ContactsServicePlugin;
import io.flutter.plugins.firebaseanalytics.FirebaseAnalyticsPlugin;
import io.flutter.plugins.firebaseauth.FirebaseAuthPlugin;
import io.flutter.plugins.firebase.core.FirebaseCorePlugin;
import io.flutter.plugins.firebase.crashlytics.firebasecrashlytics.FirebaseCrashlyticsPlugin;
import io.flutter.plugins.firebasedynamiclinks.FirebaseDynamicLinksPlugin;
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin;
import rocks.biessek.fluttercountrypicker.FlutterCountryPickerPlugin;
import com.fuyumi.flutterstatusbarcolor.flutterstatusbarcolor.FlutterStatusbarcolorPlugin;
import io.github.ponnamkarthik.toast.fluttertoast.FluttertoastPlugin;
import com.baseflow.geolocator.GeolocatorPlugin;
import com.baseflow.googleapiavailability.GoogleApiAvailabilityPlugin;
import com.baseflow.location_permissions.LocationPermissionsPlugin;
import io.flutter.plugins.pathprovider.PathProviderPlugin;
import com.baseflow.permissionhandler.PermissionHandlerPlugin;
import com.razorpay.razorpay_flutter.RazorpayFlutterPlugin;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;
import com.tekartik.sqflite.SqflitePlugin;
import mo.dyna.statusbar.StatusbarPlugin;
import io.flutter.plugins.urllauncher.UrlLauncherPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    ContactsServicePlugin.registerWith(registry.registrarFor("flutter.plugins.contactsservice.contactsservice.ContactsServicePlugin"));
    FirebaseAnalyticsPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebaseanalytics.FirebaseAnalyticsPlugin"));
    FirebaseAuthPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebaseauth.FirebaseAuthPlugin"));
    FirebaseCorePlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.core.FirebaseCorePlugin"));
    FirebaseCrashlyticsPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.crashlytics.firebasecrashlytics.FirebaseCrashlyticsPlugin"));
    FirebaseDynamicLinksPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasedynamiclinks.FirebaseDynamicLinksPlugin"));
    FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
    FlutterCountryPickerPlugin.registerWith(registry.registrarFor("rocks.biessek.fluttercountrypicker.FlutterCountryPickerPlugin"));
    FlutterStatusbarcolorPlugin.registerWith(registry.registrarFor("com.fuyumi.flutterstatusbarcolor.flutterstatusbarcolor.FlutterStatusbarcolorPlugin"));
    FluttertoastPlugin.registerWith(registry.registrarFor("io.github.ponnamkarthik.toast.fluttertoast.FluttertoastPlugin"));
    GeolocatorPlugin.registerWith(registry.registrarFor("com.baseflow.geolocator.GeolocatorPlugin"));
    GoogleApiAvailabilityPlugin.registerWith(registry.registrarFor("com.baseflow.googleapiavailability.GoogleApiAvailabilityPlugin"));
    LocationPermissionsPlugin.registerWith(registry.registrarFor("com.baseflow.location_permissions.LocationPermissionsPlugin"));
    PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
    PermissionHandlerPlugin.registerWith(registry.registrarFor("com.baseflow.permissionhandler.PermissionHandlerPlugin"));
    RazorpayFlutterPlugin.registerWith(registry.registrarFor("com.razorpay.razorpay_flutter.RazorpayFlutterPlugin"));
    SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
    SqflitePlugin.registerWith(registry.registrarFor("com.tekartik.sqflite.SqflitePlugin"));
    StatusbarPlugin.registerWith(registry.registrarFor("mo.dyna.statusbar.StatusbarPlugin"));
    UrlLauncherPlugin.registerWith(registry.registrarFor("io.flutter.plugins.urllauncher.UrlLauncherPlugin"));
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

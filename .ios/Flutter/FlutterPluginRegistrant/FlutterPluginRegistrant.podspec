#
# Generated file, do not edit.
#

Pod::Spec.new do |s|
  s.name             = 'FlutterPluginRegistrant'
  s.version          = '0.0.1'
  s.summary          = 'Registers plugins with your flutter app'
  s.description      = <<-DESC
Depends on all your plugins, and provides a function to register them.
                       DESC
  s.homepage         = 'https://flutter.dev'
  s.license          = { :type => 'BSD' }
  s.author           = { 'Flutter Dev Team' => 'flutter-dev@googlegroups.com' }
  s.ios.deployment_target = '8.0'
  s.source_files =  "Classes", "Classes/**/*.{h,m}"
  s.source           = { :path => '.' }
  s.public_header_files = './Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'contacts_service'
  s.dependency 'firebase_analytics'
  s.dependency 'firebase_auth'
  s.dependency 'firebase_core'
  s.dependency 'firebase_crashlytics'
  s.dependency 'firebase_dynamic_links'
  s.dependency 'firebase_messaging'
  s.dependency 'flutter_country_picker'
  s.dependency 'flutter_statusbarcolor'
  s.dependency 'fluttertoast'
  s.dependency 'geolocator'
  s.dependency 'google_api_availability'
  s.dependency 'location_permissions'
  s.dependency 'path_provider'
  s.dependency 'permission_handler'
  s.dependency 'razorpay_flutter'
  s.dependency 'shared_preferences'
  s.dependency 'sqflite'
  s.dependency 'statusbar'
  s.dependency 'url_launcher'
end

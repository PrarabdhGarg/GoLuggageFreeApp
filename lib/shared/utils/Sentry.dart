import 'package:go_luggage_free/shared/utils/Constants.dart';
import 'package:sentry/sentry.dart';

class Sentry {
  Sentry._();

  static SentryClient _client;

  static SentryClient getSentryClient() {
    if(_client == null) {
      _client = new SentryClient(dsn: sentryDSN);
      return _client;
    }
    return _client;
  }
}
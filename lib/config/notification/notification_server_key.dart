import 'package:googleapis_auth/auth_io.dart';

class NotificationServerKey {
  Future<String> getServerKey() async {
    final scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging",
    ];

    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "track-all-prg",
          "private_key_id": "5fd4d5a0dfb0c0efe825d6933e2ab05422f35525",
          "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEuwIBADANBgkqhkiG9w0BAQEFAASCBKUwggShAgEAAoIBAQCpj+c9IAAvVKaf\nBDadbwYek9UC41tauMNaAvF9mhfFBhL+XfReViL7hqmI8pQsfGAHP8jQgWWefsUV\n2zAoE/olT7QINLo8WG40+A/6210ZCZTrKaMJWDpATmFgBnRztS9uOwZdBgXsMkR+\n1vH7RaLngHstvopL3U4REPZ+9JC1hL3i85PwcFhu3Z5HGbcBKtq0CCUewSV2CBtv\njUY6PzPO92R3SBV6eTvz/bQGoVwhxta1dpMYj/date2VVKRE7ytqzgTaivese4xx\nkr6Gdu4ZhugFc74P9/WuG961Ol6NWIz0Ww+b3JGjlyAoKh09inNXg6l8Q1LEYbSV\nVO5kvjVNAgMBAAECgf8vaaL/NIjYsz2OuV7hfBSkotxX3RBuYxDnhRXW89TcWBZ3\nifi1aDXf9IeeA4vrOdv1gEsRV8f9HvV9EbfQJ8Xf06mY9yVxj53sBxvGHrtUL5m0\nfVqurOec6Ph8IVHus3slF4bFUX8rzI0v6mqUwvlfl6LZ562ZXl215/MFDN2/ONS9\neloGOndcWilPw2hk/Kf+bB8vO5WtZiAZoHBilhXCbt97SI8cZXBwL2E6jlfk4J0Z\nqT8LQ8M9GpBj2o/c4dFW5lJXIiLN6SZFMu/1B+oMDow+GdjURNrP+UfbeXKYCIw+\nfS+fo6cqnj2Nq+j5wDyNMcgMZoSGiwQ6hbrKbRECgYEA326ZmspXDqCpEWyybcRY\n5I6KN1kDu4dnto1+ZWcYvibRtx49yR9XeSO3ffI490uvubuskoY2LvEHmFCG4HZK\nL7kyxI47dHyPfkoMWbohZGPshe/VCwZqyFW03jWlmRwXWJpqIvBdSp4WE6i/uMIH\n/2K5QpTtTnlu29LF+pJOCvECgYEAwkcjs//2wGWnNYsZ6QIwQLhu6YQZbwWh/l4G\n/WR+e5Kf/O0xfehBeE3kg9+W7OmQ+eOlmLkN4gfP0ilhwT6aNGtj1tWPq/DfZ86p\nHZveyhnXb53hIr86RACA5Rao1xRXDJ3CFknGaMvpF84cJMahlSWdZu3Whn6WT0uC\nSW0meB0CgYAcg9T+uEwcBc0N+D1dXO2rXbWuEqIzULifx7cV4e56diHVqPphrKpR\nP4mvfTZf+TzYC2ee25oWq5Q4kC5mfzJAnPYpt61G1I7Lo0+oM+UHFumcvlsGKS9/\nmdCXe2lC/R7NpAdfpiWB3GMc5zBwt/KlWUgjgzY2CbFoRKIXtIxZQQKBgQCeb3GY\na5gJk1znd4cr1NMRFNeurEIpnkhbrsa4gun7ULoUhEMmUPCDcdJ4ETF+B4RppdL4\nV4IQ4RoEZCcKd0k+ko2bOBKwwAERISIduW3ZF3Xv2qstsRGNP3PeX7pVnIrZCRat\nIoEiGZkABuBAxZQkk8ZnmHKowDdId2XLB66lqQKBgHa2Jt/d2xKRfQqctjUpPzOi\nfo1GTCyuHZVItN0DrgFXzdzs6q+YJT2JmfLBAESomb6BMH9KejpK4/QVG2q5mzej\no46WDIUbIDf79w80Gw3LMFi8VqoI873VqdDXtHrDgsJPPCxw9yLA1OqGSJuF3sSG\n4fWxPJI11snvNUsnco/b\n-----END PRIVATE KEY-----\n",
          "client_email": "firebase-adminsdk-fbsvc@track-all-prg.iam.gserviceaccount.com",
          "client_id": "101321683420848704195",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40track-all-prg.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        scopes);
    final serverKey = client.credentials.accessToken.data;
    return serverKey;
  }
}

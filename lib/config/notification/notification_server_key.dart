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
          "project_id": "track-all-42507",
          "private_key_id": "256db6fcc5d22fa2219e0c1b48be8d22de1271e0",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCoEtvINkQGoaUp\nJ9hSDcA7nHL5yjFUfmrU+4qrdRv0VSn1hwyPbDLG3TcmIpFQCImBgF3SLfvXMNrJ\n/vo0s92SZP/2aV6pn3F0EoaUXlAr15K6hfJ6HweT+yU7qwOPSZEL4jX6AhTMVeFR\nsmezakNqRnBMla9F3CbT5ZSB+bvwV0FjMmNtkT5/39sAePWm8EZBpOGatOoeURbd\nx6eAFiuGgz7UwAHr29WuftKezCeGg1vrPxXyEV1YBM/amY5YKa+JOdYX9zo4ssi4\ns2sUatkHwP5/qav/pTacOp6nv5d5Y4Yhm//FnroRmmQ7XHWnOVizxsytSFHwH7aY\n/7U9kaqFAgMBAAECggEAM7nWFSiKSAYwh9mA7EPaIR51jiWph+j+JP0jQMBicZBS\nQQOmnG8+s1A6nExwL1LpSsdAWKKZSrF47EjCJT0j2F2oHuRv40E0T/Yxn/DkuJF4\nUVpO9UGeee8Flvb7Ofp4ntEoLoC8eOSHWzbOTnvKMqdqAU/h6NynwHf7/AJpUj5v\n5JTbKZxGC9OC9Ig++Yr2k1m///q7y+F/mEsf1dHY+aY/3i+fMt1kI+ZOPdtugRm1\niKzkUwIMd5hdaDriYlKhuTwJOZFG7xWMO05X83B2/XX2M4lKzXmc+5IbeTRVPlqk\nRPgB0gC/WrsmpRaZl6CQU1JTwIRhe41BKU+fkQOBYwKBgQDnya7vUEPCO+AQwwlf\nqAUfkn7076pB5r63ggYz5D8sRGRp1vZfzYWux4U+71kdYck9NH0TtnbvMD3b/ZvY\nvMXcCOSZuciQgZxK/pMvMrcXe1nWk5W1xKCQ4tkI51pC7IonrfH0aFmglEj8YXDG\ngSBTurngbigdA7QR8O8z9cTelwKBgQC5oV+QCCoL0NVrSY+aPNvA8apAVw8nLzKG\noaZtgsA8X1RHlFbLKn6nSFH4twzI6QnFBjhB/PlbeGUwaUocLAHfKtb8FfS6c7D3\neYbeNTnNPTcp7xeuya0BtDBYGBcdI5X7t0rXVOK9yxc+gkua3QnB43Iun6ZqoETs\nFrNmtqX/QwKBgCvdxIiwBRLWaBJkBvseflG6VOKgFPXB6KgsKGZbtQT4sJRDRX9e\nEwW/5tzBSXlBD2fQ7jbz2lBsLdjbh0oed8eruy/ItEd88ApVYZ+WFoaQJrFwXu32\nl3i0JeUEe9WclIzr45Wgxg2Y4rM48bHvsCGIfjMWResvzz1x/qMzyR1jAoGAGJAh\n9Q0fgzC/DNNPDTnAWmef/6OFfcnhBa+eNh93EIYMwOwAECIvYDNRpXeTWYJ8qHWK\nPDEdTd1AhodoJxIrrTwd9n1xRLrKT/Tkw8KHQ4E2K3ZXy+kj23Xcb8vAQzrSPdyj\nKpsw5axaBwt2tadKAz31ffXiL3nFpPfcBVtl28ECgYBKSGD3/CNu4LbpfiNNVdOr\n/9F4S2IhKZzNnXtphHtzWMvIhC+Arft8vkr2wMn4/rrBowmq7MC9rM75HfcTTP94\norU+pPcsUo8Igr8wBDGX73sWdsoICk1KOiMXhW/NiXhhSJuD6GZLaxNrTKvy6hJ1\nTCfQXG72ohjhMEIHB2zXwQ==\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-74ddd@track-all-42507.iam.gserviceaccount.com",
          "client_id": "106429217820198700468",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-74ddd%40track-all-42507.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        scopes);
    final serverKey = client.credentials.accessToken.data;
    return serverKey;
  }

}

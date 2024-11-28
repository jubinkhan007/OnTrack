import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
/*final String accessKey = 'NKHLZGVLLLAIV62USI5G'; // Your access key
final String secretKey = '+hznHV41sb/5vlStEUczr0FZlS57hYWnNZh4HY6SSgk'; // Your secret key
final String bucketName = 'spro'; // Your DigitalOcean Space bucket name
final String region = 'sgp1'; // DigitalOcean Space region, for example 'sgp1' (Singapore)
final String endpoint = 'https://sgp1.digitaloceanspaces.com/';*/


/*class AwsTest {
  final String accessKey = ''; // Your access key
  final String secretKey = ''; // Your secret key
  final String bucketName = ''; // Your DigitalOcean Space bucket name
  final String region =
      'sgp1'; // DigitalOcean Space region, for example 'sgp1' (Singapore)
  final String endpoint =
      'https://sgp1.digitaloceanspaces.com/'; // Custom endpoint URL

  Future<void> uploadFile(File file) async {
    final key =
        'qpod/${basename(file.path)}'; // Define the file path in the bucket

    final date = DateTime.now().toUtc();
    final amzDate = formatDate(date); // Format the date in the correct format
    final shortDate = amzDate.split('T')[0];

    final headers = {
      'Host': '$bucketName.$endpoint',
      'x-amz-date': amzDate,
      'x-amz-acl': 'public-read',
      // If you want the file to be publicly accessible
    };

    const signedHeaders = 'host;x-amz-date;x-amz-acl';
    const payloadHash =
        'UNSIGNED-PAYLOAD'; // Using "unsigned payload" for simplicity

    final canonicalRequest = buildCanonicalRequest(
      'PUT',
      key,
      headers,
      signedHeaders,
      payloadHash,
    );

    final stringToSign = buildStringToSign(shortDate, canonicalRequest);

    final signature = signRequest(stringToSign, shortDate);

    //headers['Authorization'] = 'AWS4-HMAC-SHA256 Credential=$accessKey/$shortDate/us-east-1/s3/aws4_request, SignedHeaders=$signedHeaders, Signature=$signature';
    headers['Authorization'] =
        'AWS4-HMAC-SHA256 Credential=$accessKey/$shortDate/sgp1/s3/aws4_request, SignedHeaders=$signedHeaders, Signature=$signature';

    try {
      final response = await http.put(
        Uri.parse('$endpoint$bucketName/$key'),
        headers: headers,
        body: file.readAsBytesSync(),
      );

      if (response.statusCode == 200) {
        debugPrint('File uploaded successfully');
      } else {
        debugPrint('Failed to upload file: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error uploading file: $e');
    }
  }

  String formatDate(DateTime date) {
    final year = date.year;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hours = date.hour.toString().padLeft(2, '0');
    final minutes = date.minute.toString().padLeft(2, '0');
    final seconds = date.second.toString().padLeft(2, '0');
    final milliseconds = date.millisecond.toString().padLeft(3, '0');
    return "$year$month${day}T$hours$minutes$seconds${milliseconds}Z"; // Corrected the string concatenation
  }

  String buildCanonicalRequest(String method, String key,
      Map<String, String> headers, String signedHeaders, String payloadHash) {
    final canonicalHeaders =
        headers.entries.map((e) => '${e.key}:${e.value}').join('\n');
    return '$method\n/$key\n\n$canonicalHeaders\n\n$signedHeaders\n$payloadHash';
  }

  String buildStringToSign(String shortDate, String canonicalRequest) {
    final hashedCanonicalRequest =
        sha256.convert(utf8.encode(canonicalRequest)).toString();
    return 'AWS4-HMAC-SHA256\n$shortDate\n$shortDate/us-east-1/s3/aws4_request\n$hashedCanonicalRequest';
  }

  String signRequest(String stringToSign, String shortDate) {
    final secret = 'AWS4$secretKey';
    final dateKey =
        Hmac(sha256, utf8.encode(secret)).convert(utf8.encode(shortDate)).bytes;
    final regionKey =
        Hmac(sha256, dateKey).convert(utf8.encode('us-east-1')).bytes;
    final serviceKey = Hmac(sha256, regionKey).convert(utf8.encode('s3')).bytes;
    final signingKey =
        Hmac(sha256, serviceKey).convert(utf8.encode('aws4_request')).bytes;

    final signature =
        Hmac(sha256, signingKey).convert(utf8.encode(stringToSign)).toString();
    return signature;
  }

/*
  void main() async {
  final uploader = DigitalOceanSpaceUploader();
  final file = File('path_to_your_image.jpg'); // Provide the path to the file you want to upload
  await uploader.uploadFile(file);
  }
*/
}
*/


class AwsTest {
  final String accessKey = 'NKHLZGVLLLAIV62USI5G'; // Your access key
  final String secretKey = '+hznHV41sb/5vlStEUczr0FZlS57hYWnNZh4HY6SSgk'; // Your secret key
  final String bucketName = 'spro'; // Your DigitalOcean Space bucket name
  final String region = 'sgp1'; // DigitalOcean Space region, for example 'sgp1' (Singapore)
  final String endpoint = 'https://sgp1.digitaloceanspaces.com/';

  Future<void> uploadFile(File file) async {
    final key = 'qpod/${basename(file.path)}'; // Correct path for the file

    final date = DateTime.now().toUtc();
    final amzDate = formatDate(date); // Correctly formatted date
    final shortDate = amzDate.split('T')[0]; // This will give you the date part (YYYYMMDD)

    // Headers need to be ordered correctly
    final headers = {
      'Host': '$bucketName.$region.digitaloceanspaces.com',  // Correct format
      'x-amz-date': amzDate,  // Use correct date format
      'x-amz-acl': 'public-read',  // Permissions
    };

    // Ensure correct order of signed headers
    const signedHeaders = 'host;x-amz-date;x-amz-acl';  // Lowercase headers
    const payloadHash = 'UNSIGNED-PAYLOAD';

    // Build the canonical request with headers in the correct order
    final canonicalRequest = buildCanonicalRequest(
      'PUT',
      key,
      headers,
      signedHeaders,
      payloadHash,
    );

    // Build the string to sign with the correct short date
    final stringToSign = buildStringToSign(shortDate, canonicalRequest);
    final signature = signRequest(stringToSign, shortDate);

    // Add the signature to the Authorization header
    headers['Authorization'] = 'AWS4-HMAC-SHA256 Credential=$accessKey/$shortDate/sgp1/s3/aws4_request, SignedHeaders=$signedHeaders, Signature=$signature';


    try {
      // Send the HTTP PUT request
      final response = await http.put(
        Uri.parse('$endpoint$bucketName/$key'),
        headers: headers,
        body: file.readAsBytesSync(), // Upload the file as bytes
      );

      print('Uploading to: $endpoint $bucketName $key'); // Log the URL to confirm
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      print('Headers: $headers');
      print('Canonical Request: $canonicalRequest');
      print('Signed Headers: $signedHeaders');
      print('Authorization: ${headers['Authorization']}');

      if (response.statusCode == 200) {
        print('File uploaded successfully');
      } else {
        print('Failed to upload file: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  // Format the current date in the required format for AWS S3 (ISO8601)
  String formatDate(DateTime date) {
    final year = date.year;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hours = date.hour.toString().padLeft(2, '0');
    final minutes = date.minute.toString().padLeft(2, '0');
    final seconds = date.second.toString().padLeft(2, '0');
    return "$year$month${day}T$hours$minutes${seconds}Z"; // This is ISO8601 without milliseconds
  }

  // Build the canonical request required for signing
  String buildCanonicalRequest(String method, String key,
      Map<String, String> headers, String signedHeaders, String payloadHash) {
    // Convert header names to lowercase and join with newlines
    final canonicalHeaders = headers.entries
        .map((e) => '${e.key.toLowerCase()}:${e.value}')  // Ensure lowercase headers
        .join('\n');

    // Canonical Request Format
    return '$method\n/$key\n\n$canonicalHeaders\n\n$signedHeaders\n$payloadHash';
  }

  // Build the string to sign for signature generation
  String buildStringToSign(String shortDate, String canonicalRequest) {
    final hashedCanonicalRequest = sha256.convert(utf8.encode(canonicalRequest)).toString();
    return 'AWS4-HMAC-SHA256\n$shortDate\n$shortDate/sgp1/s3/aws4_request\n$hashedCanonicalRequest';
  }

  // Sign the request using the AWS signing process
  String signRequest(String stringToSign, String shortDate) {
    final secret = 'AWS4$secretKey';
    final dateKey = Hmac(sha256, utf8.encode(secret)).convert(utf8.encode(shortDate)).bytes;
    final regionKey = Hmac(sha256, dateKey).convert(utf8.encode(region)).bytes;
    final serviceKey = Hmac(sha256, regionKey).convert(utf8.encode('s3')).bytes;
    final signingKey = Hmac(sha256, serviceKey).convert(utf8.encode('aws4_request')).bytes;

    final signature = Hmac(sha256, signingKey).convert(utf8.encode(stringToSign)).toString();
    return signature;
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServices {
  static var client = http.Client();

  static Future<String> generateResponse1(String prompt, String model) async {
    var url = Uri.parse("https://api.wallie.ai"); // Updated the API URL

    try {
      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "query": prompt, // Use the 'query' field for the prompt
        }),
        /* customSecurityContext: SecurityContext(withTrustedRoots: false), */
      );

      // Log the request
      print('Request URL: ${url.toString()}');
      print('Request Body: ${json.encode({
        "query": prompt,
      })}');

      // Do something with the response
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final parsedResponse = jsonDecode(responseBody);

        // Log the response
        print('Response Status Code: ${response.statusCode}');
        print('Response Body: $parsedResponse');
        print('CODE1');

        return parsedResponse['sentiment'] as String;
      } else if (response.statusCode == 500) {
        // Handle 500 (Internal Server Error)
        print('Internal Server Error: ${response.reasonPhrase}');
        return 'Internal Server Error: ${response.reasonPhrase}';
      } else {
        // Handle other status codes
        print('API Error: ${response.reasonPhrase}');
        return 'API Error: ${response.reasonPhrase}';
      }
    } catch (e) {
      return 'An error occurred: $e';
    }
  }

  static Future<String> generateResponse2(String prompt) async {
    var url = Uri.parse("https://api.wallie.ai"); // Updated the API URL

    try {
      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "query": prompt,
        }),
        /* customSecurityContext: SecurityContext(withTrustedRoots: false), */
      );

      // Log the request
      print('Request URL: ${url.toString()}');
      print('Request Body: ${json.encode({
        "query": prompt,
      })}');

      // Do something with the response
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final parsedResponse = jsonDecode(responseBody);

        // Log the response
        print('Response Status Code: ${response.statusCode}');
        print('Response Body: $parsedResponse');
        print('CODE2');

        return parsedResponse['sentiment'] as String;
      } else if (response.statusCode == 500) {
        // Handle 500 (Internal Server Error)
        print('Internal Server Error: ${response.reasonPhrase}');
        return 'Internal Server Error: ${response.reasonPhrase}';
      } else {
        // Handle other status codes
        print('API Error: ${response.reasonPhrase}');
        return 'API Error: ${response.reasonPhrase}';
      }
    } catch (e) {
      return 'An error occurred: $e';
    }
  }
}

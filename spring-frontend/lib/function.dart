import 'package:http/http.dart' as http;

Future<String> fetchdata(String url) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the response
      // assuming it's in JSON format.
      final decoded = response.body;
      return decoded;
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any exceptions that occurred during the http call.
    print('Error: $e');
    throw Exception('Failed to load data. Error: $e');
  }
}

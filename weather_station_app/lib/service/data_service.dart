import 'dart:convert';
import 'package:http/http.dart' as http;

class DataService {
  Future<List<Map<String, dynamic>>> getData() async {
    try {
      // Replace with the URL of your PHP API
      String apiURL = 'http://localhost:8080/getAllWeatherStations';
      // String apiURL = 'http://192.168.1.28/lms/testapiflutter.php';

      final response = await http.get(Uri.parse(apiURL));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        List<dynamic> data = json as List<dynamic>;
        List<Map<String, dynamic>> output = [];

        // Add a counter to limit the number of fetched data to 50
        int counter = 0;

        for (var item in data) {
          // int id = int.parse(item['id'].toString() ?? '0');
          String date = item['date'].toString() ?? '';
          int hum_max = int.parse(item['hum_max'].toString() ?? '0');
          int hum_min = int.parse(item['hum_min'].toString() ?? '0');
          int hum_moy = int.parse(item['hum_moy'].toString() ?? '0');
          double temp_max = double.parse(item['temp_max'].toString() ?? '0');
          double temp_min = double.parse(item['temp_min'].toString() ?? '0');
          double temp_moy = double.parse(item['temp_moy'].toString() ?? '0');

          Map<String, dynamic> result = {
            'date': date,
            'hum_max': hum_max.toString(),
            'hum_min': hum_min.toString(),
            'hum_moy': hum_moy.toString(),
            'temp_max': temp_max.toString(),
            'temp_min': temp_min.toString(),
            'temp_moy': temp_moy.toString(),
          };

          output.add(result);

          counter++;
          if (counter >= 50) {
            break;
          }
        }

        return output;
      } else {
        print('Request failed with status: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print("An error occurred: $error");
      return [];
    }
  }
}

import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

class RssService {
  Future<List<RssItem>> getServiceData(String url) async {
    if (url == '') return null;
    final response = await http.get(
      Uri.parse(url),
    );
    final rssFeed = RssFeed.parse(response.body);
    return rssFeed.items;
  }
}

import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

class RssService {
  Future<List<RssItem>> getServiceData() async {
    final response = await http.get(
      Uri.parse(
        'https://emisoravoxdei.com/?format=feed&type=rss',
      ),
    );
    final rssFeed = RssFeed.parse(response.body);
    return rssFeed.items;
  }
}

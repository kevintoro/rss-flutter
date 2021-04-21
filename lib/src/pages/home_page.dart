import 'package:flutter/material.dart';
import 'package:rss_reader/src/services/rss_service.dart';
import 'package:webfeed/webfeed.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RssService service = new RssService();
    return Scaffold(
      appBar: AppBar(
        title: Text('Rss Data'),
        brightness: Brightness.dark,
      ),
      body: _createHome(context, service),
    );
  }

  Widget _createHome(BuildContext context, RssService service) {
    return FutureBuilder(
      future: service.getServiceData(),
      builder: (context, AsyncSnapshot<List<RssItem>> snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) => _createListTile(
              context,
              data[index],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _createListTile(BuildContext context, RssItem item) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5.0,
            spreadRadius: 2.0,
            offset: Offset(2.0, 5.0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          child: _createColumnItem(context, item),
        ),
      ),
    );
  }

  String _getImagePath(RssItem item) {
    final info = item.description.split('>');
    String path = "";
    info.forEach((element) {
      if (element.contains('img')) {
        var init = element.indexOf('src=') + 5;
        var temp = element.substring(init);
        var end = temp.indexOf('" ');
        path = temp.substring(0, end);
      }
    });
    return path;
  }

  _createColumnItem(BuildContext context, RssItem item) {
    final imagePath = _getImagePath(item);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(imagePath),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Fecha de publicación:\n ${item.pubDate}'),
            ],
          ),
          padding: EdgeInsets.all(20),
        ),
      ],
    );
  }
}

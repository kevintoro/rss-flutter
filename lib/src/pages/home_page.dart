import 'package:flutter/material.dart';
import 'package:rss_reader/src/services/rss_service.dart';
import 'package:webfeed/webfeed.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _currentUrl = '';
  @override
  Widget build(BuildContext context) {
    RssService service = new RssService();
    return Scaffold(
      appBar: AppBar(
        title: Text('Rss Data'),
        brightness: Brightness.dark,
      ),
      body: _createHome(context, service),
      floatingActionButton: _createFloating(context),
    );
  }

  Widget _createHome(BuildContext context, RssService service) {
    if (_currentUrl != '') {
      return _createFutureBuilder(context, service);
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.new_releases_rounded,
              color: Colors.grey,
              size: 80,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              child: Text(
                'No se ha cargado RSS, pulse el botón para abrir',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _createCard(BuildContext context, RssItem item) {
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
    return path.contains('http') ? path : null;
  }

  _createColumnItem(BuildContext context, RssItem item) {
    final imagePath = _getImagePath(item);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          image: imagePath == null
              ? AssetImage('assets/newspaper.png')
              : NetworkImage(imagePath),
        ),
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
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    'webview',
                    arguments:
                        '<div style="width:100%">${item.description}</div>',
                  );
                },
                child: Text('Ver noticia'),
              ),
            ],
          ),
          padding: EdgeInsets.all(20),
        ),
      ],
    );
  }

  Widget _createFutureBuilder(BuildContext context, RssService service) {
    return FutureBuilder(
      future: service.getServiceData(_currentUrl),
      builder: (context, AsyncSnapshot<List<RssItem>> snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) => _createCard(
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

  _createFloating(BuildContext context) {
    String temp;
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: TextField(
                autocorrect: false,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(labelText: 'URL'),
                onChanged: (value) {
                  temp = value;
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _currentUrl = temp;
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Abrir'),
                ),
              ],
            );
          },
        );
      },
      child: Icon(Icons.open_in_browser),
    );
  }
}

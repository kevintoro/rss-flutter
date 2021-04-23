import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Lector Rss',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        brightness: Brightness.dark,
        elevation: 0.0,
      ),
      body: _createHome(context, service),
      floatingActionButton: _createFloating(context),
    );
  }

  Widget _createHome(BuildContext context, RssService service) {
    if (_currentUrl != '') {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Text(
                'Noticias',
                style: GoogleFonts.roboto(
                  color: Colors.grey[950],
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _createFutureBuilder(context, service),
          ],
        ),
      );
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
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          'webview',
          arguments: item.link,
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: EdgeInsets.symmetric(vertical: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[350],
              blurRadius: 4.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: _createRow(item, context),
      ),
    );
  }

  String _getImagePath(RssItem item) {
    if (item.enclosure != null) {
      return item.enclosure.url;
    } else {
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
  }

  Widget _createFutureBuilder(BuildContext context, RssService service) {
    return FutureBuilder(
      future: service.getServiceData(_currentUrl),
      builder: (context, AsyncSnapshot<List<RssItem>> snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          return ListView.builder(
            itemCount: data.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
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

  Widget _createRow(RssItem item, BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imagePath = _getImagePath(item);
    return Row(
      children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              width: size.width * 0.55,
              child: Text(
                item.title,
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.grey[950],
                ),
              ),
            ),
          ],
        ),
        Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: FadeInImage(
              placeholder: AssetImage('assets/newspaper.png'),
              image: imagePath == null
                  ? AssetImage('assets/newspaper.png')
                  : NetworkImage(imagePath),
              width: size.width * 0.35,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

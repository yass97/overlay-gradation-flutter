import 'dart:convert';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Overlay Gradation App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const _ImageListPage(title: 'Overlay Gradation App'),
    );
  }
}

class _ImageListPage extends StatefulWidget {
  const _ImageListPage({required this.title});

  final String title;

  @override
  State<_ImageListPage> createState() => _ImageListPageState();
}

class _ImageListPageState extends State<_ImageListPage> {
  final _assets = <String>[];

  @override
  void initState() {
    super.initState();
    DefaultAssetBundle.of(context)
        .loadString('AssetManifest.json')
        .then((value) {
      Map<String, dynamic> manifest = json.decode(value);
      final assets =
          manifest.keys.where((key) => key.contains('.png')).toList();
      setState(() => _assets.addAll(assets));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          GridView.count(
            crossAxisCount: 3,
            children: _assets.map(_CardItem.new).toList(),
          ),
          Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Container(
                foregroundDecoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white.withOpacity(0.5), Colors.white],
                    stops: const [0, 0.3],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardItem extends StatelessWidget {
  _CardItem(this._assetPath) : _fileName = _assetPath.split('/').last;

  final String _assetPath;
  final String _fileName;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
            child: Image.asset(
              _assetPath,
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _fileName,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

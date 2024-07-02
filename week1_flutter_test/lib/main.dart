import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'contacts_tab.dart';
import 'camera_service.dart';
import 'gallery_tab.dart'; // GalleryTab import 추가
import 'home_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Camera App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<GalleryTabState> _galleryTabKey = GlobalKey<GalleryTabState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  void _onPictureTaken(String path) {
    _galleryTabKey.currentState?.addImage(path); // 사진을 찍으면 갤러리 탭에 추가
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera App'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ContactsTab(),
          HomeTab(cameras: cameras), // HomeTab에 cameras 매개변수 전달
          GalleryTab(key: _galleryTabKey),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: [
          Tab(icon: Icon(Icons.contacts), text: 'Contacts'),
          Tab(icon: Icon(Icons.camera_alt), text: 'Home'),
          Tab(icon: Icon(Icons.photo), text: 'Gallery')
        ],
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.grey,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: Colors.blue,
      ),
    );
  }
}
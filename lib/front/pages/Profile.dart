import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../back/Person.dart';
import 'SettingsScreen.dart';

class Profile extends StatefulWidget {

  final Person person;

  const Profile({super.key, required this.person});

  @override
  State<Profile> createState() => _State();
}

class _State extends State<Profile> {
  File? _image;

  Future getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      final File image = File(pickedFile.path);

      // Opcional: Guardar la imagen en el directorio de documentos de la aplicación
      final directory = await getApplicationDocumentsDirectory();
      const name = 'profile_pic.png';
      final imageFile = await image.copy('${directory.path}/$name');

      setState(() {
        _image = imageFile;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi ${widget.person.name}!'),
        automaticallyImplyLeading: false,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.settings, color: Color(0xFFfb901c), size: 31),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: SettingsScreen(),
      body:SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('No se ha seleccionado ninguna imagen.')
                : Image.file(_image!),
            ElevatedButton(
              onPressed: () => getImage(ImageSource.gallery),
              child: Text('Seleccionar de la galería'),
            ),
            ElevatedButton(
              onPressed: () => getImage(ImageSource.camera),
              child: Text('Tomar una foto'),
            ),
          ],
        ),
      ),

    );
  }
}

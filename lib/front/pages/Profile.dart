import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modern_form_line_awesome_icons/modern_form_line_awesome_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;


import '../../back/Person.dart';
import 'ProfileMenuWidget.dart';
import 'SettingsScreen.dart';
import 'UpdateProfileScreen.dart';

// Definiciones de las constantes (ajusta según sea necesario)
const String tProfileHeading = "Tu nombre de usuario";
const String tProfileSubHeading = "Tu correo electrónico";
const Color tPrimaryColor = Color(0xFFfb901c);
const Color tDarkColor = Colors.black12;
const String tEditProfile = "Editar Perfil";

class Profile extends StatefulWidget {

  final Person person;

  const Profile({super.key, required this.person});

  @override
  State<Profile> createState() => _State();
}

class _State extends State<Profile> {
  File? _image;

  @override
  void initState() {
    super.initState();
    loadProfileImage();
  }

  Future<void> loadProfileImage() async {
    String? imagePath = widget.person.profileImagePath;
    if (imagePath != null && await File(imagePath).exists()) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  void showImageSourceOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Elije una opción'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Tomar una foto'),
                onTap: () {
                  Navigator.of(context).pop();
                  getImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Seleccionar de la galería'),
                onTap: () {
                  Navigator.of(context).pop();
                  getImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }


  Future<void> getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      final File image = File(pickedFile.path);
      final directory = await getApplicationDocumentsDirectory();

      // Usar un timestamp para generar un nombre de archivo único
      final String fileName = 'profile_pic_${DateTime.now().millisecondsSinceEpoch}.png';
      final String imagePath = path.join(directory.path, fileName);
      final File imageFile = await image.copy(imagePath);

      setState(() {
        // Actualizar la ruta de la imagen y forzar la reconstrucción del widget Image
        _image = imageFile;
        widget.person.profileImagePath = imageFile.path;
        widget.person.save();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        automaticallyImplyLeading: false,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: ImageIcon(
                AssetImage('lib/front/assets/images/Carrot.png'),
                color: Color(0xFFfb901c),
                size: 60,
              ),
              onPressed: () {
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // -- IMAGE
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: _image != null
                          ? Image.file(
                        _image!,
                        key: UniqueKey(), // Clave única para forzar la reconstrucción
                      )
                          : const Image(image: AssetImage('lib/front/assets/images/profile.png')),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Color(0xFFfff0e8)),
                      child: IconButton(
                        icon: const Icon(
                          LineAwesomeIcons.pencil,
                          color: tPrimaryColor,
                          size: 20,
                        ),
                        onPressed: () => showImageSourceOptions(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(widget.person.name, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 10),

              // -- BUTTON
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateProfileScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFfff0e8), side: BorderSide.none, shape: const StadiumBorder()),
                  child: Text(tEditProfile, style: TextStyle(color: tPrimaryColor)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              // -- MENU
              ProfileMenuWidget(title: "Settings", icon: LineAwesomeIcons.cog, onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(),
                  ),
                );
              }),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(title: "Information", icon: LineAwesomeIcons.info, onPress: () {}),
              ProfileMenuWidget(
                title: "Logout",
                icon: LineAwesomeIcons.sign_out,
                textColor: Colors.red,
                endIcon: false,
                onPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Logout'),
                        content: Text('Are you sure you want to logout?\n\nIf you logout you will not receive notifications.'),
                        actions: <Widget>[
                          // Botón para cancelar
                          TextButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop(); // Cierra el diálogo
                            },
                          ),
                          // Botón para confirmar y navegar
                          TextButton(
                            child: Text('Yes'),
                            onPressed: () {
                              Navigator.of(context).pop(); // Cierra el diálogo
                              // Aquí puedes agregar la lógica para navegar a otra página o realizar el logout
                              // Por ejemplo: Navigator.of(context).pushReplacementNamed('/tuRuta');
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

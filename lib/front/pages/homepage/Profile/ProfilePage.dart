import 'dart:io';
import 'package:carrot/back/network/NetworkService.dart';
import 'package:carrot/back/network/NetworkUtility.dart';
import 'package:carrot/back/person/PersonRepository.dart';
import 'package:carrot/front/pages/WelcomePage.dart';
import 'package:carrot/front/pages/homepage/profile/Info.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modern_form_line_awesome_icons/modern_form_line_awesome_icons.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../back/person/Person.dart';
import 'ProfileMenuWidget.dart';
import 'SettingsScreen.dart';
import 'UpdateProfileScreen.dart';

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
    } else {
      print(imagePath);
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
                onTap: () async {
                  await getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Seleccionar de la galería'),
                onTap: () async {
                  await getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
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
      const name = 'profile_pic.png';
      final imageFile = await image.copy('${directory.path}/$name');

      setState(() {
        // Actualizar la ruta de la imagen y forzar la reconstrucción del widget Image
        _image = imageFile;
        widget.person.profileImagePath = imageFile.path;
        widget.person.save();
        NetworkService.uploadProfileImage(imageFile.path, widget.person.name);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {},
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
                            ? Image.file(_image!)
                            : const Image(
                                image: AssetImage(
                                    'lib/front/assets/images/profile.png'))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Color(0xFFfff0e8)),
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
              Text(
                  '${widget.person.name[0].toUpperCase()}${widget.person.name.substring(1).toLowerCase()}',
                  style: Theme.of(context).textTheme.headlineMedium),
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
                      backgroundColor: Color(0xFFfff0e8),
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: Text(tEditProfile,
                      style: TextStyle(color: tPrimaryColor)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              // -- MENU
              ProfileMenuWidget(
                  title: "Settings",
                  icon: LineAwesomeIcons.cog,
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SettingsScreen(person: widget.person),
                      ),
                    );
                  }),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                title: "Information",
                icon: LineAwesomeIcons.info,
                onLongPress: () {
                  _showSecretKeyDialog(context);
                },
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Information(),
                    ),
                  );
                },
              ),
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
                        content: Text(
                            'Are you sure you want to logout?\n\nIf you logout you will not receive notifications.'),
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
                              PersonRepository.clearSavedPerson();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WelcomePage()),
                                (Route<dynamic> route) =>
                                    false, // Esto removerá todas las rutas anteriores
                              );
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

  void _showSecretKeyDialog(BuildContext context) {
    final TextEditingController _secretKeyController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: AlertDialog(
            title: Text('Enter Secret Key'),
            content: TextField(
              controller: _secretKeyController,
              decoration: InputDecoration(hintText: 'Secret Key'),
              obscureText: false, // Para ocultar el texto ingresado
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Submit'),
                onPressed: () {
                  if (_secretKeyController.text == 'destroyallcarrots') {
                    Navigator.of(context).pop(); // Cierra el diálogo actual
                    _showCarrotAddMenu(
                        context); // Muestra el menú para agregar zanahorias
                  } else {
                    Navigator.of(context)
                        .pop(); // Cierra el diálogo si la clave es incorrecta
                    _showErrorSnackBar(context, "No valid key");
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCarrotAddMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Admin Menu'),
          content: Text('You can modify things here.'),
          actions: <Widget>[
            Column(
              children: [
                Row(
                  children: [
                    ElevatedButton(
                        child: Text('Add Carrots'),
                        onPressed: () async {
                          widget.person.setCarrots(await _selectDate(context));
                        }),
                    ElevatedButton(
                        child: Text('Update Carrots'),
                        onPressed: () async {
                          try {
                            int carrots =
                                await NetworkService.updateCarrotsFromServer(
                                    widget.person.name);
                            setState(() {
                              widget.person.carrots = carrots;
                            });
                          } catch (e) {
                            print('Error: $e');
                          }
                        }),
                  ],
                ),
                ElevatedButton(
                    child: Text('Reset gymDate'),
                    style: ButtonStyle(
                      alignment: Alignment.center,
                    ),
                    onPressed: () async {
                      widget.person.gymDate =
                          DateTime.now().subtract(Duration(days: 1));
                    }),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    final currentDate = await NetworkUtility.getCurrentDate();
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) {
      return currentDate;
    }

    return selectedDate;
  }
}

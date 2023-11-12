import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:game_booking/Controllers/games_provider.dart';
import 'package:game_booking/Models/game.dart';
import 'package:game_booking/translations/locale_keys.g.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class GameForm extends StatefulWidget {
  const GameForm({Key? key}) : super(key: key);

  @override
  State<GameForm> createState() => _GameFormState();
}

class _GameFormState extends State<GameForm> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  int maxPlayersNo = 12;
  DateTime bookingDate = DateTime.now().add(const Duration(days: 1));
  File? image;
  String imgURL = "";
  ScrollController scrollController = ScrollController(initialScrollOffset: 0);
  int id = -1;
  bool isOldGame = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    if (isOldGame) {
      return;
    }
    super.didChangeDependencies();
    if (ModalRoute.of(context)!.settings.arguments != null) {
      id = ModalRoute.of(context)!.settings.arguments as int;
      isOldGame = true;
      setWithOldData(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          !isOldGame ? LocaleKeys.newGame.tr() : LocaleKeys.editGame.tr(),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            child: Container(
              constraints: BoxConstraints(
                minHeight:
                    (MediaQuery.of(context).size.height - kToolbarHeight) * .95,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .05,
                vertical: MediaQuery.of(context).size.height * .01,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextFormField(
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == '') {
                          return LocaleKeys.requiredField.tr();
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: LocaleKeys.title.tr(),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .025,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.descriptionTextFieldHint.tr(),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .025,
                    ),
                    TextFormField(
                      controller: locationController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.locationTextFieldHint.tr(),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .025,
                    ),
                    maxPlayersNumberPicker(context),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .025,
                    ),
                    dateTimePicker(context),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .025,
                    ),
                    imagePicker(context),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .025,
                    ),
                    imageContainer(context),
                    (image == null)
                        ? const SizedBox()
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * .025,
                          ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .1,
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * .01,
            right: MediaQuery.of(context).size.width * .05,
            left: MediaQuery.of(context).size.width * .05,
            child: isOldGame
                ? oldGameControlButtons(context)
                : submitButton(context),
          ),
        ],
      ),
    );
  }

  Widget imageContainer(BuildContext context) {
    return (image == null)
        ? const SizedBox()
        : SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Image.file(image!),
          );
  }

  Widget imagePicker(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      height: MediaQuery.of(context).size.height * .075,
      child: ElevatedButton(
        onPressed: () => showImageModalSheet(context),
        child: Text(
          LocaleKeys.chooseImageButtonLabel.tr(),
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * .025,
          ),
        ),
      ),
    );
  }

  Widget maxPlayersNumberPicker(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          LocaleKeys.maxPlayersNoLabel.tr(),
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * .025,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              heroTag: 'decrement',
              elevation: 0,
              onPressed: () {
                setState(() {
                  if (maxPlayersNo != 1) {
                    maxPlayersNo--;
                  }
                });
              },
              child: const Icon(Icons.remove),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .025,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .07,
              child: Text(
                maxPlayersNo.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * .025,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .025,
            ),
            FloatingActionButton(
              heroTag: "increment",
              elevation: 0,
              onPressed: () {
                setState(() {
                  if (maxPlayersNo != 22) {
                    maxPlayersNo++;
                  }
                });
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }

  Widget submitButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      height: MediaQuery.of(context).size.height * .1,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            showWhatsAppInviteDialog(context);
          }
        },
        child: Text(
          LocaleKeys.submitButtonLabel.tr(),
          style: TextStyle(fontSize: MediaQuery.of(context).size.height * .05),
        ),
      ),
    );
  }

  Widget dateTimePicker(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * .4,
              height: MediaQuery.of(context).size.height * .075,
              child: ElevatedButton(
                onPressed: () async {
                  DateTime temp = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
                      ) ??
                      bookingDate;
                  bookingDate = DateTime(
                    temp.year,
                    temp.month,
                    temp.day,
                    bookingDate.hour,
                    bookingDate.minute,
                  );
                  setState(() {});
                },
                child: Text(
                  LocaleKeys.chooseDateButtonLabel.tr(),
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * .025,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .01,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .4,
              height: MediaQuery.of(context).size.height * .075,
              child: ElevatedButton(
                onPressed: () async {
                  TimeOfDay temp = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: DateTime.now().hour,
                          minute: DateTime.now().minute,
                        ),
                      ) ??
                      TimeOfDay(
                        hour: bookingDate.hour,
                        minute: bookingDate.minute,
                      );
                  bookingDate = DateTime(
                    bookingDate.year,
                    bookingDate.month,
                    bookingDate.day,
                    temp.hour,
                    temp.minute,
                  );
                  setState(() {});
                },
                child: Text(
                  LocaleKeys.chooseTimeButtonLabel.tr(),
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * .025,
                  ),
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * .4,
              height: MediaQuery.of(context).size.height * .075,
              child: ElevatedButton(
                onPressed: null,
                child: Text(
                  DateFormat.EEEE(context.locale.languageCode)
                      .add_d()
                      .add_MMM()
                      .format(bookingDate),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black87),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .01,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .4,
              height: MediaQuery.of(context).size.height * .075,
              child: ElevatedButton(
                onPressed: null,
                child: Text(
                  DateFormat.jm(context.locale.languageCode)
                      .format(bookingDate),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future pickImage(ImageSource source, BuildContext context) async {
    try {
      final imageFromPicker = await ImagePicker().pickImage(source: source);
      if (imageFromPicker == null) {
        Navigator.pop(context);
        return;
      }
      File savedImage = await saveImage(imageFromPicker.path);
      setState(() {
        image = savedImage;
        imgURL = savedImage.path;
      });
      Navigator.pop(context);
    } catch (e) {
      debugPrint(e.toString());
      Navigator.pop(context);
    }
  }

  void showImageModalSheet(BuildContext context) {
    showModalBottomSheet(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * .2,
      ),
      context: context,
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => pickImage(ImageSource.gallery, context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .1,
                ),
                const Icon(Icons.image_outlined),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .1,
                ),
                Text(
                  LocaleKeys.gallery.tr(),
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * .025,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => pickImage(ImageSource.camera, context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .1,
                ),
                const Icon(Icons.camera_alt),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .1,
                ),
                Text(
                  LocaleKeys.camera.tr(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * .025),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<File> saveImage(String imagePath) async {
    final cacheImage = File(imagePath);
    final Directory? savingDirectory = await getExternalStorageDirectory();
    final baseName = DateTime.now()
        .toString()
        .replaceAll("-", "")
        .replaceAll(":", "")
        .replaceAll(" ", "")
        .replaceAll(".", "");
    final name = "Image_$baseName";
    final newImage = File("${savingDirectory!.path}/$name.png");
    return cacheImage.copy(newImage.path);
  }

  void setWithOldData(BuildContext context) {
    Game oldGame = Provider.of<GamesProvider>(context, listen: false)
        .gamesList
        .firstWhere((element) => element.id == id);
    titleController.text = oldGame.title;
    descriptionController.text = oldGame.description ?? "";
    locationController.text = oldGame.location ?? "";
    maxPlayersNo = oldGame.maxPlayersNo;
    bookingDate = oldGame.date;
    imgURL = oldGame.imgURL ?? "";
    if (imgURL != "") {
      image = File(imgURL);
    }
  }

  Widget oldGameControlButtons(BuildContext context) {
    return Consumer<GamesProvider>(
      builder: (context, provider, child) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * .4,
            height: MediaQuery.of(context).size.height * .075,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                showWhatsAppInviteDialog(context);
              },
              child: Text(
                LocaleKeys.update.tr(),
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * .025,
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .01,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .4,
            height: MediaQuery.of(context).size.height * .075,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                provider.deleteGame(id);
                Navigator.pop(context);
              },
              child: Text(
                LocaleKeys.delete.tr(),
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * .025,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future whatsAppInvite(BuildContext context) async {
    String message = context.locale.languageCode == "en"
        ? '''
    Hi there! I'm sending you an invite to join my game : ${titleController.text}

    Date: ${DateFormat.EEEE(context.locale.languageCode).add_d().add_MMM().format(bookingDate)}
    Time: ${DateFormat.jm(context.locale.languageCode).format(bookingDate)}
    ${locationController.text != "" ? "Location: " + locationController.text : ""}
    Max players no: $maxPlayersNo Players
    ${descriptionController.text != "" ? "Game description: " + descriptionController.text : ""}

    I used Yalla Goal to make a booking for this game, wanna try it?
    you can download the app from here:
    https://www.yallaharek.com/yallagoal/download
    '''
        : '''
    مرحباً، أنا أرسل لك دعوة للانضمام إلى لعبتي : ${titleController.text}

    التاريخ: ${DateFormat.EEEE(context.locale.languageCode).add_d().add_MMM().format(bookingDate)}
    التوقيت: ${DateFormat.jm(context.locale.languageCode).format(bookingDate)}
    ${locationController.text != "" ? "Location: " + locationController.text : ""}
    عدد اللاعبين الأقصى: $maxPlayersNo لاعبين
    ${descriptionController.text != "" ? "وصف اللعبة: " + descriptionController.text : ""}

    استخدمت يلا غول لإنشاء حجز لهذا اللعبة, هل تريد تجربته؟
    يمكنك تحميل التطبيق من هنا:
    https://www.yallaharek.com/yallagoal/download
    ''';
    Uri whatsAppUri = Uri.parse("whatsapp://send?text=$message");
    try {
      await launchUrl(whatsAppUri);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(LocaleKeys.error.tr()),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * .3,
            width: MediaQuery.of(context).size.width * .6,
            child: Center(
              child: Text(
                LocaleKeys.noWhatsApp.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * .025),
              ),
            ),
          ),
        ),
      );
    }
  }

  void showWhatsAppInviteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<GamesProvider>(
          builder: (context, gamesProvider, child) => AlertDialog(
            content: Text(LocaleKeys.sendInvites.tr()),
            title: Icon(
              FontAwesomeIcons.whatsappSquare,
              color: const Color(0xFF25D366),
              size: MediaQuery.of(context).size.height * .1,
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  isOldGame
                      ? gamesProvider.updateGame(
                          id,
                          titleController.text,
                          descriptionController.text,
                          locationController.text,
                          maxPlayersNo,
                          bookingDate,
                          imgURL,
                        )
                      : gamesProvider.addNewGame(
                          titleController.text,
                          descriptionController.text,
                          locationController.text,
                          maxPlayersNo,
                          bookingDate,
                          imgURL,
                        );
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/", (route) => false);
                  whatsAppInvite(context);
                },
                child: Text(LocaleKeys.yes.tr()),
              ),
              ElevatedButton(
                onPressed: () {
                  isOldGame
                      ? gamesProvider.updateGame(
                          id,
                          titleController.text,
                          descriptionController.text,
                          locationController.text,
                          maxPlayersNo,
                          bookingDate,
                          imgURL,
                        )
                      : gamesProvider.addNewGame(
                          titleController.text,
                          descriptionController.text,
                          locationController.text,
                          maxPlayersNo,
                          bookingDate,
                          imgURL,
                        );
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/", (route) => false);
                },
                child: Text(LocaleKeys.no.tr()),
              ),
            ],
          ),
        );
      },
    );
  }
}

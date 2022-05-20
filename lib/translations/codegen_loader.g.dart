// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader {
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String, dynamic> ar = {
    "appTitle": "يلا غول",
    "noBookedGames": "لا يوجد حجوزات بعد!\nاضغط لإنشاء حجز جديد",
    "maximumPlayersNo": "لاعب",
    "sortBy": "فرز وفق",
    "title": "العنوان",
    "date": "التاريخ",
    "language": "اللغة",
    "english": "الإنكليزية",
    "arabic": "العربية",
    "newGame": "لعبة جديدة",
    "editGame": "تعديل اللعبة",
    "descriptionTextFieldHint": "وصف (اختياري)",
    "locationTextFieldHint": "موقع (اختياري)",
    "chooseImageButtonLabel": "اختر صورة (اختياري)",
    "maxPlayersNoLabel": "عدد اللاعبين الأقصى :",
    "submitButtonLabel": "تأكيد",
    "chooseDateButtonLabel": "اختر التاريخ",
    "chooseTimeButtonLabel": "اختر الوقت",
    "camera": "الكاميرا",
    "gallery": "معرض الصور",
    "update": "تحديث",
    "delete": "حذف",
    "error": "خطأ",
    "noWhatsApp": "لم نتمكن من العثور على واتساب مثبت على جهازك!",
    "requiredField": "هذا الحقل مطلوب",
    "sendInvites": "إرسال دعوات لأصدقائك عبر واتساب؟",
    "yes": "نعم",
    "no": "لا"
  };
  static const Map<String, dynamic> en = {
    "appTitle": "Yalla Goal",
    "noBookedGames": "No booked games yet!\nClick to make new booking",
    "maximumPlayersNo": "Maximum Players",
    "sortBy": "Sort By",
    "title": "Title",
    "date": "Date",
    "language": "Language",
    "english": "English",
    "arabic": "Arabic",
    "newGame": "New Game",
    "editGame": "Edit Game",
    "descriptionTextFieldHint": "Description (optional)",
    "locationTextFieldHint": "Location (optional)",
    "chooseImageButtonLabel": "Choose Image (optional)",
    "maxPlayersNoLabel": "Max Players :",
    "submitButtonLabel": "Submit",
    "chooseDateButtonLabel": "Choose Date",
    "chooseTimeButtonLabel": "Choose Time",
    "camera": "Camera",
    "gallery": "Gallery",
    "update": "Update",
    "delete": "Delete",
    "error": "Error",
    "noWhatsApp": "Couldn't find WhatsApp installed on your device!",
    "requiredField": "This field is required",
    "sendInvites": "Send invites to your friends via whatsapp?",
    "yes": "Yes",
    "no": "No"
  };
  static const Map<String, Map<String, dynamic>> mapLocales = {
    "ar": ar,
    "en": en
  };
}

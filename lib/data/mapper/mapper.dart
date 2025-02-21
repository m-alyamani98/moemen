

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:momen/app/utils/extensions.dart';
import 'package:momen/domain/models/quran/juz_model.dart';

import '../../app/utils/constants.dart';
import '../../domain/models/adhkar/adhkar_model.dart';
import '../../domain/models/prayer_timings/prayer_timings_model.dart';
import '../../domain/models/quran/quran_model.dart';
import '../../domain/models/quran/quran_search_model.dart';
import '../responses/adhkar/adhkar_response.dart';
import '../responses/hadith/hadith_response.dart';
import '../responses/prayer_timings/prayer_timings_response.dart';
import '../responses/quran/quran_response.dart';
import '../responses/quran/quran_search_response.dart';

extension AyahResponseMapper on AyahResponse {
  AyahModel toDomain() {
    return AyahModel(
      number: number.orZero(),
      text: text.orEmpty(),
      numberInSurah: numberInSurah.orZero(),
      juz: juz.orZero(),
      page: page.orZero(),
      hizbQuarter: hizbQuarter.orZero(),
    );
  }
}

extension QuranSearchResponseMapper on QuranSearchResponse {
  QuranSearchModel toDomain() {
    return QuranSearchModel(
      id: id.orZero(),
      text: text.orEmpty(),
      numberInSurah: int.parse(verseKey.split(":")[1]).orZero(),
      surahNumber: int.parse(verseKey.split(":")[0]).orZero(),
    );
  }
}

extension QuranResponseMapper on QuranResponse {
  QuranModel toDomain() {
    List<AyahModel> ayahs =
    (this.ayahs.map((ayahResponse) => ayahResponse.toDomain()))
        .cast<AyahModel>()
        .toList();

    // Group the ayahs by Juz
    List<JuzModel> juzs = _groupAyahsByJuz(ayahs);

    return QuranModel(
      number: number.orZero(),
      name: name.orEmpty(),
      englishName: englishName.orEmpty(),
      englishNameTranslation: englishNameTranslation.orEmpty(),
      revelationType: revelationType.orEmpty(),
      ayahs: ayahs,
      juzs: juzs,  // Pass the juzs here
    );
  }

  // Helper function to group Ayahs by Juz
  List<JuzModel> _groupAyahsByJuz(List<AyahModel> ayahs) {
    List<JuzModel> juzList = [];

    for (int juzNumber = 1; juzNumber <= 30; juzNumber++) {
      // Filter the ayahs that belong to the current Juz
      List<AyahModel> juzAyahs = ayahs.where((ayah) => ayah.juz == juzNumber).toList();

      // Create a JuzModel for this Juz if there are ayahs for it
      /*if (juzAyahs.isNotEmpty) {
        juzList.add(JuzModel(juzNumber: juzNumber, ayahs: juzAyahs));
      }*/
    }

    return juzList;
  }
}


extension AdhkarResponseMapper on AdhkarResponse {
  AdhkarModel toDomain() {
    return AdhkarModel(
      category: category.orEmpty(),
      count: count.orEmpty(),
      description: description.orEmpty(),
      reference: reference.orEmpty(),
      dhikr: dhikr.orEmpty(),
      icon: getIconForCategory(category.orEmpty()), // Set the icon based on the category
    );
  }

  IconData getIconForCategory(String category) {
    switch (category) {
      case "أذكار الصباح":
        return Icons.wb_sunny; // Morning icon
      case "أذكار المساء":
        return Icons.nightlight_round; // Evening icon
      case "أذكار النوم":
        return Icons.bed; // Sleep icon
      case "أذكار الاستيقاظ":
        return Icons.alarm; // Wake-up icon
      case "دعاء لبس الثوب":
        return Icons.checkroom; // Clothes icon
      case "دعاء لبس الثوب الجديد":
        return Icons.shopping_bag; // New clothes icon
      case "ما يقول إذا وضع الثوب":
        return Icons.wrap_text_outlined; // Wardrobe icon
      case "دعاء دخول الخلاء - الحمام":
        return Icons.wc; // Bathroom icon
      case "دعاء الخروج من الخلاء - الحمام":
        return Icons.exit_to_app; // Exit icon
      case "الذكر قبل الوضوء":
        return Icons.water_drop; // Water drop icon
      case "الذكر بعد الفراغ من الوضوء":
        return Icons.clean_hands; // Clean hands icon
      case "الذكر عند الخروج من المنزل":
        return Icons.home; // Home icon
      case "الذكر عند دخول المنزل":
        return Icons.home_work; // Home with garden icon
      case "دعاء الذهاب إلى المسجد":
        return Icons.mosque; // Mosque icon
      case "دعاء دخول المسجد":
        return Icons.mosque; // Mosque icon
      case "دعاء الخروج من المسجد":
        return Icons.directions_walk; // Walking icon
      case "أذكار الآذان":
        return Icons.volume_up; // Loudspeaker icon
      case "دعاء الاستفتاح":
        return Icons.wrap_text_sharp; // Hands icon
      case "دعاء الركوع":
        return Icons.arrow_downward; // Arrow down icon
      case "دعاء السجود":
        return Icons.arrow_downward; // Arrow down icon
      case "دعاء الجلسة بين السجدتين":
        return Icons.chair; // Chair icon
      case "دعاء سجود التلاوة":
        return Icons.book; // Book icon
      case "التشهد":
        return Icons.lightbulb; // Lightbulb icon
      case "الصلاة على النبي بعد التشهد":
        return Icons.star; // Star icon
      case "الدعاء بعد التشهد الأخير قبل السلام":
        return Icons.done_all; // Done all icon
      case "الأذكار بعد السلام من الصلاة":
        return Icons.wrap_text_sharp; // Candle icon
      case "دعاء صلاة الاستخارة":
        return Icons.help; // Help icon
      case "أذكار النوم":
        return Icons.bedtime; // Bedtime icon
      case "الدعاء إذا تقلب في الليل":
        return Icons.bed; // Bed icon
      case "دعاء الفزع في النوم و من بلي بالوحشة":
        return Icons.nightlight; // Nightlight icon
      case "ما يفعل من رأى الرؤيا أو الحلم في النوم":
        return Icons.wrap_text_sharp; // Dream icon
      case "دعاء قنوت الوتر":
        return Icons.wrap_text_sharp; // Prayer icon
      case "الذكر عقب السلام من الوتر":
        return Icons.star; // Star icon
      case "دعاء الهم والحزن":
        return Icons.mood_bad; // Sad mood icon
      case "دعاء الكرب":
        return Icons.emoji_emotions; // Emoji icon
      case "دعاء لقاء العدو و ذي السلطان":
        return Icons.wrap_text_sharp; // Swords icon
      case "دعاء من خاف ظلم السلطان":
        return Icons.wrap_text_sharp; // Crown icon
      case "الدعاء على العدو":
        return Icons.wrap_text_sharp; // Swords icon
      case "ما يقول من خاف قوما":
        return Icons.wrap_text_sharp; // Fear icon
      case "دعاء من أصابه وسوسة في الإيمان":
        return Icons.wrap_text_sharp; // Thought bubble icon
      case "دعاء قضاء الدين":
        return Icons.money; // Money icon
      case "دعاء الوسوسة في الصلاة و القراءة":
        return Icons.wrap_text_sharp; // Thought bubble icon
      case "دعاء من استصعب عليه أمر":
        return Icons.help; // Help icon
      case "ما يقول ويفعل من أذنب ذنبا":
        return Icons.wrap_text_sharp; // Sad icon
      case "دعاء طرد الشيطان و وساوسه":
        return Icons.wrap_text_sharp; // Devil icon
      case "الدعاء حينما يقع ما لا يرضاه أو غلب على أمره":
        return Icons.wrap_text_sharp; // Sad icon
      case "ﺗﻬنئة المولود له وجوابه":
        return Icons.wrap_text_sharp; // Baby icon
      case "ما يعوذ به الأولاد - رقية":
        return Icons.wrap_text_sharp; // Child icon
      case "الدعاء للمريض في عيادته":
        return Icons.wrap_text_sharp; // Hospital icon
      case "فضل عيادة المريض":
        return Icons.wrap_text_sharp; // Hospital icon
      case "دعاء المريض الذي يئس من حياته":
        return Icons.wrap_text_sharp; // Sad icon
      case "تلقين المحتضر":
        return Icons.wrap_text_sharp; // Sad icon
      case "دعاء من أصيب بمصيبة":
        return Icons.wrap_text_sharp; // Sad icon
      case "الدعاء عند إغماض الميت":
        return Icons.wrap_text_sharp; // Sad icon
      case "الدعاء للميت في الصلاة عليه":
        return Icons.wrap_text_sharp; // Sad icon
      case "الدعاء للفرط في الصلاة عليه":
        return Icons.wrap_text_sharp; // Baby icon
      case "دعاء التعزية":
        return Icons.wrap_text_sharp; // Sad icon
      case "الدعاء عند إدخال الميت القبر":
        return Icons.wrap_text_sharp; // Coffin icon
      case "الدعاء بعد دفن الميت":
        return Icons.wrap_text_sharp; // Coffin icon
      case "دعاء زيارة القبور":
        return Icons.wrap_text_sharp; // Coffin icon
      case "دعاء الريح":
        return Icons.wrap_text_sharp; // Wind icon
      case "دعاء الرعد":
        return Icons.thunderstorm; // Thunderstorm icon
      case "من أدعية الاستسقاء":
        return Icons.wrap_text_sharp; // Rain icon
      case "الدعاء إذا نزل المطر":
        return Icons.wrap_text_sharp; // Rain icon
      case "الذكر بعد نزول المطر":
        return Icons.wrap_text_sharp; // Rain icon
      case "من أدعية الاستصحاء":
        return Icons.wrap_text_sharp; // Sun icon
      case "دعاء رؤية الهلال":
        return Icons.wrap_text_sharp; // Moon icon
      case "الدعاء عند إفطار الصائم - الصوم":
        return Icons.wrap_text_sharp; // Food icon
      case "الدعاء قبل الطعام":
        return Icons.wrap_text_sharp; // Food icon
      case "الدعاء عند الفراغ من الطعام":
        return Icons.wrap_text_sharp; // Food icon
      case "دعاء الضيف لصاحب الطعام":
        return Icons.wrap_text_sharp; // Food icon
      case "التعريض بالدعاء لطلب الطعام أو الشراب":
        return Icons.wrap_text_sharp; // Food icon
      case "الدعاء إذا أفطر عند أهل بيت - طعام":
        return Icons.wrap_text_sharp; // Food icon
      case "دعاء الصائم إذا حضر الطعام ولم يفطر":
        return Icons.wrap_text_sharp; // Food icon
      case "ما يقول الصائم إذا سابه أحد":
        return Icons.wrap_text_sharp; // Food icon
      case "الدعاء عند رؤية باكورة الثمر":
        return Icons.wrap_text_sharp; // Fruit icon
      case "دعاء العطاس":
        return Icons.wrap_text_sharp; // Sneeze icon
      case "ما يقال للكافر إذا عطس فحمد الله":
        return Icons.wrap_text_sharp; // Sneeze icon
      case "الدعاء للمتزوج":
        return Icons.wrap_text_sharp; // Ring icon
      case "دعاء المتزوج و شراء الدابة":
        return Icons.wrap_text_sharp; // Horse icon
      case "الدعاء قبل إتيان الزوجة - الجماع":
        return Icons.wrap_text_sharp; // Heart icon
      case "دعاء الغضب":
        return Icons.wrap_text_sharp; // Angry icon
      case "دعاء من رأى مبتلى":
        return Icons.wrap_text_sharp; // Sad icon
      case "ما يقال في اﻟﻤﺠلس":
        return Icons.chair; // Chair icon
      case "كفارة اﻟﻤﺠلس":
        return Icons.chair; // Chair icon
      case "الدعاء لمن قال غفر الله لك":
        return Icons.wrap_text_sharp; // Hands icon
      case "الدعاء لمن صنع إليك معروفا":
        return Icons.handshake; // Handshake icon
      case "ما يعصم الله به من الدجال":
        return Icons.shield; // Shield icon
      case "الدعاء لمن قال إني أحبك في الله":
        return Icons.wrap_text_sharp; // Heart icon
      case "الدعاء لمن عرض عليك ماله":
        return Icons.money; // Money icon
      case "الدعاء لمن أقرض عند القضاء":
        return Icons.money; // Money icon
      case "دعاء الخوف من الشرك":
        return Icons.wrap_text_sharp; // Fear icon
      case "الدعاء لمن قال بارك الله فيك":
        return Icons.wrap_text_sharp; // Hands icon
      case "دعاء كراهية الطيرة":
        return Icons.cancel; // Cancel icon
      case "دعاء الركوب":
        return Icons.wrap_text_sharp; // Car icon
      case "دعاء السفر":
        return Icons.wrap_text_sharp; // Airplane icon
      case "دعاء دخول القرية أو البلدة":
        return Icons.house; // House icon
      case "دعاء دخول السوق":
        return Icons.shopping_cart; // Shopping cart icon
      case "الدعاء إذا تعس المركوب":
        return Icons.wrap_text_sharp; // Car icon
      case "دعاء المسافر للمقيم":
        return Icons.house; // House icon
      case "دعاء المقيم للمسافر":
        return Icons.wrap_text_sharp; // Airplane icon
      case "التكبير و التسبيح في سير السفر":
        return Icons.wrap_text_sharp; // Car icon
      case "دعاء المسافر إذا أسحر":
        return Icons.wrap_text_sharp; // Sunrise icon
      case "الدعاء إذا نزل مترلا في سفر أو غيره":
        return Icons.wrap_text_sharp; // Camping icon
      case "ذكر الرجوع من السفر":
        return Icons.house; // House icon
      case "ما يقول من أتاه أمر يسره أو يكرهه":
        return Icons.wrap_text_sharp; // Smile icon
      case "فضل الصلاة على النبي صلى الله عليه و سلم":
        return Icons.star; // Star icon
      case "إفشاء السلام":
        return Icons.handshake; // Handshake icon
      case "كيف يرد السلام على الكافر إذا سلم":
        return Icons.handshake; // Handshake icon
      case "الدعاء عند سماع صياح الديك ونهيق الحمار":
        return Icons.wrap_text_sharp; // Rooster icon
      case "دعاء نباح الكلب بالليل":
        return Icons.wrap_text_sharp; // Dog icon
      case "الدعاء حينما يقع ما لا يرضاه أو غلب على أمره":
        return Icons.wrap_text_sharp; // Sad icon
      case "ما يفعل من أتاه أمر يسره":
        return Icons.wrap_text_sharp; // Smile icon
      case "ما يقول من أحس وجعا في جسده":
        return Icons.wrap_text_sharp; // Pain icon
      case "دعاء من خشي أن يصيب شيئا بعينه":
        return Icons.wrap_text_sharp; // Eye icon
      case "ما يقال عند الفزع":
        return Icons.wrap_text_sharp; // Fear icon
      case "ما يقول عند الذبح أو النحر":
        return Icons.wrap_text_sharp; // Sheep icon
      case "ما يقول لرد كيد مردة الشياطين":
        return Icons.wrap_text_sharp; // Devil icon
      case "الاستغفار و التوبة":
        return Icons.wrap_text_sharp; // Hands icon
      case "التسبيح، التحميد، التهليل، التكبير":
        return Icons.star; // Star icon
      case "كيف كان النبي يسبح؟":
        return Icons.star; // Star icon
      case "من أنواع الخير والآداب الجامعة":
        return Icons.star; // Star icon
      case "الرُّقية الشرعية من القرآن الكريم":
        return Icons.book; // Book icon
      case "الرُّقية الشرعية من السنة النبوية":
        return Icons.book; // Book icon
      default:
        return Icons.book; // Default icon
    }
  }
}


extension WeekdayResponseMapper on WeekdayResponse? {
  WeekdayModel toDomain() {
    return WeekdayModel(
      en: this?.en.orEmpty() ?? Constants.empty,
      ar: this?.ar.orEmpty() ?? Constants.empty,
    );
  }
}

extension MonthResponseMapper on MonthResponse? {
  MonthModel toDomain() {
    return MonthModel(
      number: this?.number.orZero() ?? Constants.zero,
      en: this?.en.orEmpty() ?? Constants.empty,
      ar: this?.ar.orEmpty() ?? Constants.empty,
    );
  }
}

extension HijriResponseMapper on HijriResponse? {
  HijriModel toDomain() {
    return HijriModel(
      date: this?.date.orEmpty() ?? Constants.empty,
      format: this?.format.orEmpty() ?? Constants.empty,
      day: this?.day.orEmpty() ?? Constants.empty,
      weekday: this?.weekday.toDomain(),
      month: this?.month.toDomain(),
      year: this?.year.orEmpty() ?? Constants.empty,
    );
  }
}

extension GregorianResponseMapper on GregorianResponse? {
  GregorianModel toDomain() {
    return GregorianModel(
      date: this?.date.orEmpty() ?? Constants.empty,
      format: this?.format.orEmpty() ?? Constants.empty,
      day: this?.day.orEmpty() ?? Constants.empty,
      weekday: this?.weekday.toDomain(),
      month: this?.month.toDomain(),
      year: this?.year.orEmpty() ?? Constants.empty,
    );
  }
}

extension TimingsResponseMapper on TimingsResponse? {
  TimingsModel toDomain() {
    return TimingsModel(
      fajr: this?.fajr.orEmpty() ?? Constants.empty,
      sunrise: this?.sunrise.orEmpty() ?? Constants.empty,
      dhuhr: this?.dhuhr.orEmpty() ?? Constants.empty,
      asr: this?.asr.orEmpty() ?? Constants.empty,
      maghrib: this?.maghrib.orEmpty() ?? Constants.empty,
      isha: this?.isha.orEmpty() ?? Constants.empty,
    );
  }
}

extension DateResponseMapper on DateResponse? {
  DateModel toDomain() {
    return DateModel(
      readable: this?.readable.orEmpty() ?? Constants.empty,
      timestamp: this?.readable.orEmpty() ?? Constants.empty,
      hijri: this?.hijri.toDomain(),
      gregorian: this?.gregorian.toDomain(),
    );
  }
}

extension PrayerTimingsDataResponseMapper on PrayerTimingsDataResponse? {
  PrayerTimingsDataModel toDomain() {
    return PrayerTimingsDataModel(
      timings: this?.timings.toDomain(),
      date: this?.date.toDomain(),
    );
  }
}

extension PrayerTimingsResponseMapper on PrayerTimingsResponse? {
  PrayerTimingsModel toDomain() {
    return PrayerTimingsModel(
      code: this?.code.orZero() ?? Constants.zero,
      status: this?.status.orEmpty() ?? Constants.empty,
      data: this?.data.toDomain(),
    );
  }
}

const String assetPath = "assets/";
const String jsonPath = "assets/json";
const String imagePath = "assets/images";
const String pillarsPath = "assets/images/pillars";

sealed class ImageAsset {
  //Bot Nav Icons
  static const String homeIcon = "$imagePath/home-ic.svg";
  static const String quranIcon = "$imagePath/quran-ic.svg";
  static const String hadithIcon = "$imagePath/hadith-ic.svg";
  static const String prayerIcon = "$imagePath/mosque-ic.svg";
  static const String adhkarIcon = "$imagePath/adhkar-ic.svg";
  static const String launcherIcon = "$imagePath/islamic_ic.png";
}

sealed class JsonAsset {
  static const String quranAsset = "$jsonPath/quran.json";
  static const String adhkarAsset = "$jsonPath/adhkar.json";
}

class Decoder {
  // Year_Index to Concert Year
  static String yearToConcertYear(String year_index) {
    return year_index.substring(0, 4);
  }

  static String songNameToPure(String songName) {
    String sub = songName.substring(3);
    int spaceIndex = sub.indexOf(' '); //has space
    String result;
    if (spaceIndex >= 0) {
      result = sub.substring(0, spaceIndex);
    } else {
      result = sub;
    }
    return result;
  }

  // Year_Index to Concert Name
  static String yearToConcertName(String year_index) {
    switch (year_index) {
      case "1972_0":
        return '72全国フォーク音楽祭 全国大会';
      case "1976_0":
        return '近畿大学工学部大学祭';
      case "1978_0":
        return '1978年・春のツアー';
      case "1978_1":
        return '1978年・秋のツアー';
      case "1979_0":
        return '1979年・春のツアー';
      case "1979_1":
        return '1979年・秋のツアー';
      case "1980_0":
        return '1980年・春のツアー';
      case "1980_1":
        return '1980年・秋のツアー';
      case "1981_0":
        return '寂しき友へ';
      case "1981_1":
        return '寂しき友へ II';
      case "1982_0":
        return '浮汰姫';
      case "1983_0":
        return '蕗く季節に';
      case "1984_0":
        return '明日を撃て！';
      case "1984_1":
        return '月光の宴';
      case "1985_0":
        return 'のぅさんきゅう';
      case "1985_1":
        return '歌暦 Page 85';
      case "1986_0":
        return '五番目の季節';
      case "1986_1":
        return '歌暦 Page 86 恋唄';
      case "1987_0":
        return 'SUPPIN VOL.1';
      case "1989_0":
        return '野ウサギのように';
      case "1990_0":
        return 'Night Wings';
      case "1992_0":
        return 'カーニヴァル1992';
      case "1993_0":
        return 'EAST ASIA';
      case "1995_0":
        return 'LOVE OR NOTHING';
      case "1997_0":
        return 'パラダイス・カフェ';
      case "1998_0":
        return 'CONCERT TOUR \'98 試行錯誤';
      case "2001_0":
        return 'XXIc. 1st. 中島みゆき in KEIO';
      case "2005_0":
        return 'TOUR 2005';
      case "2007_0":
        return 'TOUR 2007 歌旅';
      case "2010_0":
        return 'TOUR2010';
      case "2012_0":
        return '縁会2012～3';
      case "2015_0":
        return '一会（いちえ）2015~2016';
      case "2020_0":
        return 'ラスト・ツアー 「 結果オーライ」';
      default:
        return 'No live';
    }
  }
}

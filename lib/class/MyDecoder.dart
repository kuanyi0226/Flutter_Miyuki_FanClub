class MyDecoder {
  // Year_Index to Concert Year
  static String yearToConcertYear(String year_index) {
    if (year_index.startsWith('y')) {
      return year_index.substring(1, 5);
    } else {
      return year_index.substring(0, 4);
    }
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
    if (year_index.startsWith('y')) {
      switch (year_index) {
        case "y1989":
          return '夜会 1989';
        case "y1990":
          return '夜会 1990';
        case "y1991":
          return '夜会VOL.3「KAN-TAN（邯鄲）」';
        case "y1992":
          return '夜会VOL.4「金環蝕」';
        case "y1993":
          return '夜会VOL.5「花の色はうつりにけりないたづらに わが身世にふるながめせし間に」';
        case "y1994":
          return '夜会VOL.6「シャングリラ」';
        case "y1995":
          return '夜会VOL.7「 ２／２ 」';
        case "y1996":
          return '夜会VOL.8「問う女」';
        case "y1997":
          return '夜会VOL.9「 ２／２ 」';
        case "y1998":
          return '夜会VOL.10「海嘯」';
        case "y2000":
          return '夜会VOL.11「ウィンター・ガーデン」';
        case "y2002":
          return '夜会VOL.12「ウィンター・ガーデン」';
        case "y2004":
          return '夜会VOL.13「24時着 ０時発」';
        case "y2006":
          return '夜会VOL.14「24時着00時発」';
        case "y2008":
          return '夜会VOL.15～夜物語～「元祖・今晩屋」';
        case "y2009":
          return '夜会VOL.16～夜物語～「本家・今晩屋」';
        case "y2011":
          return '夜会VOL.17「 ２／２ 」';
        case "y2013":
          return '夜会工場 VOL.1';
        case "y2014":
          return '夜会VOL.18─橋の下のアルカディア';
        case "y2016":
          return '夜会VOL.19─橋の下のアルカディア';
        case "y2017":
          return '夜会工場 VOL.2';
        case "y2019":
          return '夜会VOL.20「リトル・トーキョー」';
        default:
          return 'No live';
      }
    } else {
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
          return 'TOUR \'98 試行錯誤';
        case "2001_1":
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

  //Return song list
  static List<String> getYakaiSongList({required String yakai}) {
    switch (yakai) {
      //Yakai
      case "y1989":
        return [
          '01	泣きたい夜に',
          '02	毒をんな',
          '03	杏村から',
          '04	０３時',
          '05	時は流れて',
          '06	群衆',
          '07	あり、か',
          '08	黄砂に吹かれて',
          '09	わかれうた',
          '10	悪女',
          '11	あした',
          '12	気にしないで',
          '13	MEGAMI',
          '14	あわせ鏡',
          '15	鳥になって',
          '16	十二月',
          '17	二隻の舟',
        ];
      case "y1990":
        return [
          '01	二隻の舟',
          '02	彼女によろしく',
          '03	ミルク32',
          '04	流浪の詩',
          '05	窓ガラス',
          '06	うそつきが好きよ',
          '07	「元気ですか」',
          '08	クレンジング_クリーム',
          '09	月の赤ん坊',
          '10	断崖─親愛なる者へ─',
          '11	孤独の肖像',
          '12	強がりはよせヨ',
          '13	北の国の習い',
          '14	ショウ・タイム',
          '15	Maybe',
          '16	ふたりは',
        ];
      case "y1991":
        return [
          '01	涙─Made_in_tears─',
          '02	トーキョー迷子',
          '03	タクシー_ドライバー',
          '04	キツネ狩りの歌',
          '05	僕は青い鳥',
          '06	ロンリー_カナリア',
          '07	ひとり遊び',
          '08	萩野原',
          '09	キツネ狩りの歌',
          '10	わかれうた',
          '11	ひとり上手',
          '12	さよならの鐘',
          '13	LA-LA-LA',
          '14	サーチライト',
          '15	キツネ狩りの歌',
          '16	B.G.M.',
          '17 シュガー',
          '18 黄色い犬',
          '19 キツネ狩りの歌',
          '20 ふたつの炎',
          '21 傾斜',
          '22 二隻の舟',
          '23 傾斜',
          '24 殺してしまおう',
          '25 雪',
          '26 I_love_him',
          '27 I_love_him',
          '28 I_love_him （Instrumental）',
          '29 I_love_him （Instrumental）',
        ];
      case "y1992":
        return [
          '01	インストゥルメンタル「金環蝕」',
          '02	C.Q.',
          '03	砂の船',
          '04	ほうせんか',
          '05	歌をあなたに',
          '06	泣かないでアマテラス',
          '07	エレーン',
          '08	遠雷',
          '09	冬を待つ季節',
          '10	泣かないでアマテラス',
          '11	世迷い言',
          '12	熱病',
          '13	最悪',
          '14	遠雷',
          '15	冬を待つ季節',
          '16	泣かないでアマテラス',
          '17 真直な線',
          '18 やまねこ',
          '19 新曾根崎心中',
          '20 泣かないでアマテラス',
          '21 EAST_ASIA',
          '22 泣かないでアマテラス',
          '23 二隻の舟',
          '24 DIAMOND_CAGE',
          '25 インストゥルメンタル「金環蝕」',
          '26 泣かないでアマテラス',
        ];
      case "y1993":
        return [
          '01	雨のテーマ （Instrumental）',
          '02	どこにいても',
          '03	雨が空を捨てる日は',
          '04	家出',
          '05	バス通り',
          '06	笑わせるじゃないか',
          '07	人待ち歌',
          '08	信じ難いもの',
          '09	サッポロSNOWY',
          '10	ノスタルジア',
          '11	船を出すのなら九月',
          '12	遍路',
          '13	まつりばやし',
          '14	３分後に捨ててもいい',
          '15	りばいばる',
          '16	二隻の舟',
          '17 雨月の使者',
          '18 孤独の肖像1st.',
          '19 雨のテーマ （Instrumental）',
          '20 彼女の生き方',
          '21 テキーラを飲みほして',
          '22 たとえ世界が空から落ちても',
          '23 くらやみ乙女',
          '24 愛よりも',
          '25 人待ち歌',
          '26 夜曲',
          '27 人待ち歌 （Instrumental）',
        ];
      case "y1994":
        return [
          '01	思い出させてあげる （Instrumental）',
          '02	怜子',
          '03	煙草',
          '04	噂',
          '05	波の上',
          '06	南三条',
          '07	縁',
          '08	あの娘',
          '09	朝焼け',
          '10	五才の頃',
          '11	F.O.',
          '12	忘れてはいけない',
          '13	思い出させてあげる',
          '14	思い出させてあげる',
          '15	あり、か',
          '16	春までなんぼ （Instrumental）',
          '17 子守歌',
          '18 グッバイガール',
          '19 黄砂に吹かれて',
          '20 思い出させてあげる',
          '21 友情',
          '22 シャングリラ',
          '23 思い出させてあげる',
          '24 春までなんぼ',
          '25 波の上',
          '26 二隻の舟',
          '27 生きてゆくおまえ',
          '28 誕生',
          '29 生きてゆくおまえ',
          '30 シャングリラ （Instrumental）',
        ];
      case "y1995":
        return [
          '01	TOURIST',
          '02	LAST_SCENE',
          '03	TOURIST',
          '04	誰かが私を憎んでいる',
          '05	１人旅のススメ',
          '06	拾われた猫のように',
          '07	奇妙な音楽',
          '08	誰かが私を憎んでいる',
          '09	NEVER_CRY_OVER_SPILT_MILK',
          '10	奇妙な音楽',
          '11	この思いに偽りはなく',
          '12	１人で生まれて来たのだから',
          '13	TOURIST',
          '14	TOURIST',
          '15	途方に暮れて',
          '16	ハリネズミ',
          '17 市場は眠らない',
          '18 TOURIST',
          '19 拾われた猫のように',
          '20 竹の歌',
          '21 紅い河',
          '22 ７月のジャスミン',
          '23 自白',
          '24 目撃者の証言',
          '25 幸せになりなさい',
          '26 二隻の舟',
          '27 幸せになりなさい',
          '28 紅い河',
          '29 市場は眠らない （Instrumental）',
        ];
      case "y1996":
        return [
          '01	羊の言葉',
          '02	コマーシャル',
          '03	ＪＢＣのテーマ',
          '04	エコー',
          '05	SMILE,_SMILE',
          '06	台風情報 （Instrumental）',
          '07	エコー',
          '08	誰だってナイフになれる （Instrumental）',
          '09	SMILE,_SMILE',
          '10	RAIN',
          '11	ＪＢＣのテーマ',
          '12	公然の秘密',
          '13	エコー',
          '14	誰だってナイフになれる',
          '15	女という商売',
          '16	二隻の舟',
          '17 あなたの言葉がわからない',
          '18 血の音が聞こえる',
          '19 未明に',
          '20 異国の女 （Instrumental）',
          '21 ＪＢＣのテーマ',
          '22 未明に （Instrumental）',
          '23 PAIN',
          '24 RAIN （Instrumental）',
        ];
      default:
        return [];
    }
  }
}

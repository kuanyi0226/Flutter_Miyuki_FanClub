import 'package:flutter/material.dart';
import 'package:project5_miyuki/materials/MyText.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.about_app)),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              //What is the Privacy Policy
              Text(
                (AppLocalizations.of(context)!.language == 'English')
                    ? '1. About ${APPNAME_JP}(${APPNAME_EN})'
                    : (AppLocalizations.of(context)!.language == '日本語')
                        ? '一、 ${APPNAME_JP}(${APPNAME_EN})とは'
                        : '一、 關於${APPNAME_JP}(${APPNAME_EN})',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                (AppLocalizations.of(context)!.language == 'English')
                    ? '${APPNAME_EN} (miyukisamafansclub@gmail.com) is an APP to gather all the 中島みゆき fans in the world holding by an "Non-official" fan club in TW.(You can also contact me via Instagram:@miyukisama.fans.club).\n\n' +
                        'Everyone can share their thoughts about any of her songs with other fans. Let\'s make this community greater! Let more people know 中島みゆきさん. '
                    : (AppLocalizations.of(context)!.language == '日本語')
                        ? '${APPNAME_JP}(miyukisamafansclub@gmail.com)は世界中の中島みゆきファンを集め、中島みゆきさんのことを広めるためのアプリです。台湾の非公式ファンクラブによって開発・運営されています。掲示板の利用、ライブやアルバムなどの情報を調べることができます。'
                        : '${APPNAME_JP}(miyukisamafansclub@gmail.com)是用來匯聚全世界中島美雪粉絲的非官方粉絲俱樂部。每位粉絲都能夠在此平台分享對於中島美雪歌曲的想法，或是參與過演唱會的經驗。平台中也整理了許多關於中島美雪的資訊，使用者可以盡情調閱。一起來讓更多人認識中島美雪吧！',
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 20),
              //What information do we collect?
              Text(
                (AppLocalizations.of(context)!.language == 'English')
                    ? '2. About 中島みゆき(Nakajima Miyuki)'
                    : (AppLocalizations.of(context)!.language == '日本語')
                        ? '二、中島みゆきについて'
                        : '二、關於中島美雪',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                (AppLocalizations.of(context)!.language == 'English')
                    ? 'Miyuki Nakajima (中島 みゆき, Nakajima Miyuki)(born February 23, 1952, Sapporo, Hokkaidō, Japan)is a Japanese singer-songwriter and radio personality. She has released 44 studio albums, 46 singles, 6 live albums and multiple compilations as of January 2020. Her sales have been estimated at more than 21 million copies.' +
                        'In the mid-1970s, Nakajima signed to Canyon Records and launched her recording career with her debut single, "Azami Jō no Lullaby" (アザミ嬢のララバイ). Rising to fame with the hit "The Parting Song (Wakareuta)", released in 1977, she has since seen a successful career as a singer-songwriter, primarily in the early 1980s. Four of her singles have sold more than one million copies in the last two decades, including "Earthly Stars (Unsung Heroes)", a theme song for the Japanese television documentary series Project X.' +
                        'Nakajima performed in experimental theater ("Yakai") every year-end from 1989 through 2019. The idiosyncratic acts featured scripts and songs she wrote, and have continued irregularly in recent years.' +
                        'In addition to her work as a solo artist, Nakajima has written over 90 compositions for numerous other singers, and has produced several chart-toppers. Many cover versions of her songs have been performed by Asian (particularly Taiwan and Hong Kong) singers. She is the only musician to have participated in the National Language Council of Japan.\n\n'
                    : (AppLocalizations.of(context)!.language == '日本語')
                        ? '中島みゆき（なかじま みゆき、1952年（昭和27年）2月23日）は日本のシンガーソングライターで、ラジオパーソナリティ。1970年代半ばにキャニオン・レコードに所属し、デビューシングル「アザミ嬢のララバイ」でレコーディングキャリアを開始した。1977年にリリースされたヒット曲「わかれうた」で一躍注目され、1980年代初頭から成功したシンガーソングライターとされる。\n' +
                            '2020年1月時点で、44枚のスタジオアルバム、46枚のシングル、6枚のライブアルバム、そして複数のコンピレーションアルバムをリリースしている。過去20年間で4枚のシングルが100万枚以上売れ、総売上は2100万枚を超えると推定されている。その中には、テレビドキュメンタリーシリーズ「プロジェクトX」のテーマ曲「地上の星」などの代表作が含まれる。なお、中島は90曲以上の提供曲を作曲し、いくつかのトップチャートの楽曲をプロデュースしている。楽曲はアジアの歌手（特に台湾と香港）によってカバーされることも多い。\n' +
                            '1989年から2019年まで、毎年年末に実験演劇「夜会」を行っていた。その独特な舞台劇は中島が書いた脚本と歌で構成されており、近年も不定期に開催されている。\n' +
                            'また、中島は国語審議会に参加した唯一の音楽家である。\n\n'
                        : '中島美雪（藝名採用與本名讀音相同的平假名寫法中島 みゆき，1952年2月23日—），日本創作女歌手、音樂家、詞曲作家、主持人。她出生於日本北海道札幌市，於1975年以《薊花姑娘的搖籃曲》 (アザミ嬢のララバイ) 出道，事業黃金期是20世紀80年代。官方粉絲俱樂部有「でじなみ」「なみふく」兩個。數十年來，中島美雪的歌曲被大量翻唱和改編，其中不乏一些港台歌手的著名曲目。\n自1989年開始，中島美雪開創新的舞台形式--夜会(Yakai)，她稱之為語言的實驗場所，透過精湛的演技和動人的歌聲，每一次的夜会都帶給觀眾不一樣的體驗。\n\n',
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 20),
              //What information do we collect?
              Text(
                (AppLocalizations.of(context)!.language == 'English')
                    ? '3. Development team'
                    : (AppLocalizations.of(context)!.language == '日本語')
                        ? '三、開発チーム'
                        : '三、開發團隊',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                (AppLocalizations.of(context)!.language == 'English')
                    ? 'administrator: Kevin\n' +
                        'Founder & Main Developer: Kevin\n' +
                        'Translator： リンゴ\n'
                    : (AppLocalizations.of(context)!.language == '日本語')
                        ? '管理者: Kevin\n' +
                            '創設者 & メイン開発者： Kevin\n' +
                            '翻訳者： リンゴ\n'
                        : '管理員: Kevin\n' + '創辦人 & 主要開發者： Kevin\n' + '翻譯： リンゴ\n',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:project5_miyuki/materials/MyText.dart';
import 'package:project5_miyuki/materials/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('プライバシーポリシー\nPrivacy Policy')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              //What is the Privacy Policy
              Text(
                (AppLocalizations.of(context)!.language == 'English')
                    ? '1. What is the Privacy Policy?'
                    : (AppLocalizations.of(context)!.language == '日本語')
                        ? '一、	プライバシーポリシーとは'
                        : '一、何為隱私政策',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                (AppLocalizations.of(context)!.language == 'English')
                    ? '(Effective June 27, 2023)\n\n' +
                        'In the privacy policy, we will tell you what kinds of data ${APPNAME_EN} collect. Also, you will know how we use it.\n' +
                        'Here we promise you, any of your data will only be use in this APP: ${APPNAME_EN}.\n'
                    : (AppLocalizations.of(context)!.language == '日本語')
                        ? '(効力発生日2023年6月27日)\n\n' +
                            'このプライバシー ポリシーは、雪クラブが収集する情報、情報を収集する理由について理解を深めていただくためのものです。\n' +
                            '収集する情報は雪クラブでのみ使用することを約束します。\n'
                        : '(生效日期：2023年6月27日)\n\n' +
                            '在本隱私政策中，會說明我們收集了哪些個人資訊，以及說明我們如何使用它\n' +
                            '首先，我們能向您保證，在本平台上收集的個人資訊只會在本平台(Yuki Club)上使用，不會用作其他外部用途。\n',
                style: TextStyle(fontSize: 15),
              ),
              //What information do we collect?
              Text(
                (AppLocalizations.of(context)!.language == 'English')
                    ? '2. What information does Yuki Club collect?'
                    : (AppLocalizations.of(context)!.language == '日本語')
                        ? '二、雪クラブが収集する情報'
                        : '二、Yuki Club收集的資訊',
                style: TextStyle(fontSize: 20),
              ),
              Container(
                color: theme_dark_grey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    (AppLocalizations.of(context)!.language == 'English')
                        ? '(1) Your Email\n' +
                            '(2) Your UserName(You can change it in "Profile")\n' +
                            '(3) The amount of YUKI Coin you have in this app\n' +
                            '(4) Whether you are vip(Not for sale)\n' +
                            '(5) The Comments you commented in the public homepage or a song page\n' +
                            '(6) The Resources you want to share via Google Survey Sheet\n' +
                            '(7) The Images or Video you uploaded\n\n'
                        : (AppLocalizations.of(context)!.language == '日本語')
                            ? '(1) Eメールアドレス\n' +
                                '(2) Eメールアドレス\n' +
                                '(3) ユキコイン(YUKI Coin)の残高\n' +
                                '(4) VIP認証（購入不可）\n' +
                                '(5) コメントの内容\n' +
                                '(6) Google スプレッドシートを通じて共有したいリソース\n' +
                                '(7) アップロードした画像または動画\n\n'
                            : '(1)電子郵件\n' +
                                '(2) 用戶名稱(您可以隨時在"設定"中更改)\n' +
                                '(3) 在此應用程式中擁有的YUKI幣(YUKI Coin)\n' +
                                '(4) 是否為Vip身分(無法購買)\n' +
                                '(5) 在此平台上的留言\n' +
                                '(6) 透過Google表單所分享的資源\n' +
                                '(7) 上傳至本平台的照片或影片\n',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              SizedBox(height: 20),
              //Notification
              Text(
                (AppLocalizations.of(context)!.language == 'English')
                    ? '3. Please Note That...'
                    : (AppLocalizations.of(context)!.language == '日本語')
                        ? '三、ご注意'
                        : '三、注意事項',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                (AppLocalizations.of(context)!.language == 'English')
                    ? '(1) Please do not leave inappropriate comments or engage in illegal behavior on this platform.\n' +
                        '(2) Vip means the friends of developer, you can not get Vip by cash(we will not sell the vip!)\n' +
                        '(3) (Important!!!) We can not see your password in backend, so only you can see or modify it through "Forgot Password"\n'
                    : (AppLocalizations.of(context)!.language == '日本語')
                        ? '(1) 匿名掲示板での不適切な発言や違法行為はご遠慮ください\n' +
                            '(2) VIP認証を取得したいお客様は、開発者のメールアドレスにお問い合わせください。\n' +
                            '(3) バックエンドではお客様のパスワードを見ることができません。\n' +
                            'パスワードの変更は「パスワードを忘れた場合」からのみ行うことができます。\n\n'
                        : '(1)請勿在本平台留下不適當的發言，或是做出違法的行為\n' +
                            '(2) Vip僅代表您是開發者的友人，您無法使用現金購買Vip(我們也不會出售該資格)，若需要Vip資格請聯繫管理員\n' +
                            '(3) (重要!!!) 我們無法從後台看到您設定的密碼，若要更改請前往"忘記密碼"\n\n',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ));
  }
}

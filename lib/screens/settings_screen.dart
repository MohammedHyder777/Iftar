import 'package:flutter/material.dart';
import 'package:iftar/main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Localizations.localeOf(context).languageCode == 'ar'
            ? const Text('الإعدادت')
            : const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12.5, 12.5, 12.5, 0),
        child: ListView(
          children: const [
            LanguageSetting(),
          ],
        ),
      ),
    );
  }
}

//*//////// Language Group /////////////////////////////////////////////////////
class LanguageSetting extends StatefulWidget {
  const LanguageSetting({super.key});

  @override
  State<LanguageSetting> createState() => _LanguageSettingState();
}

class _LanguageSettingState extends State<LanguageSetting> {
  Locale currentLocale = Localizations.localeOf(mykeyNavigator.currentContext!);
  @override
  Widget build(BuildContext context) {
    
    print('On build: $currentLocale');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('اختر لغة العرض:', style: TextStyle(fontSize:  16),),
        ListTile(
          title: const Text('العربية'),
          leading: Radio<Locale>(
            value: const Locale('ar'),
            groupValue: currentLocale,
            onChanged: (value) {
              setState(() => currentLocale = value!);
              MyApp.setLocale(context, currentLocale);
            },
          ),
        ),
        ListTile(
          title: const Text('English'),
          leading: Radio<Locale>(
            value: const Locale('en'),
            groupValue: currentLocale,
            onChanged: (value) {
              setState(() => currentLocale = value!);
              MyApp.setLocale(context, currentLocale);
            },
          ),
        )
      ],
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/gen/locale_keys.g.dart';
import 'package:flutter/material.dart';

class LanguageDialog extends StatefulWidget {
  const LanguageDialog({super.key});

  @override
  State<LanguageDialog> createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  Locale? selectedLocale;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      selectedLocale = context.locale;
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentLocale = context.locale;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(LocaleKeys.select_language.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<Locale>(
            activeColor: theme.colorScheme.primary,
            value: const Locale('en'),
            groupValue: selectedLocale,
            title: Text(LocaleKeys.language_english.tr()),
            onChanged: (value) => setState(() => selectedLocale = value),
          ),
          RadioListTile<Locale>(
            activeColor: theme.colorScheme.primary,
            value: const Locale('ar'),
            groupValue: selectedLocale,
            title: Text(LocaleKeys.language_arabic.tr()),
            onChanged: (value) => setState(() => selectedLocale = value),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            LocaleKeys.cancel.tr(),
            style: TextStyle(color: theme.colorScheme.primary),
          ),
        ),
        TextButton(
          onPressed: () async {
            if (selectedLocale != null && selectedLocale != currentLocale) {
              await context.setLocale(selectedLocale!);
            }
            if (context.mounted) Navigator.pop(context);
          },
          child: Text(
            LocaleKeys.ok.tr(),
            style: TextStyle(color: theme.colorScheme.primary),
          ),
        ),
      ],
    );
  }
}

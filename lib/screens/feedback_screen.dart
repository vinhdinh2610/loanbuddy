import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});
  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  static const _gold = Color(0xFFE8A020);
  static const _bg = Color(0xFFF5F0E8);

  final _emailCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final l = AppLocalizations.of(context)!;
    if (_messageCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.feedbackValidation),
          backgroundColor: const Color(0xFF1A1A1A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _sending = true);

    final email = _emailCtrl.text.trim();
    final message = _messageCtrl.text.trim();
    final subject = Uri.encodeComponent('Góp ý LoanBuddy${email.isNotEmpty ? " - $email" : ""}');
    final body = Uri.encodeComponent(
        '${email.isNotEmpty ? "Từ: $email\n\n" : ""}$message');

    final uri = Uri.parse(
        'mailto:vinhdinh2610@gmail.com?subject=$subject&body=$body');

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        if (mounted) {
          _emailCtrl.clear();
          _messageCtrl.clear();
          final lm = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(lm.feedbackSuccess),
              backgroundColor: const Color(0xFF4CAF50),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        if (mounted) {
          final lm = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(lm.feedbackNoEmail),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final lm = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(lm.feedbackError),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
          children: [
            Text(l.feedbackTitle,
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A))),
            const SizedBox(height: 4),
            Text(l.feedbackSubtitle,
                style: const TextStyle(fontSize: 14, color: Color(0xFF888888))),
            const SizedBox(height: 24),

            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14)),
              child: TextField(
                controller: _emailCtrl,
                decoration: InputDecoration(
                  hintText: l.feedbackEmailHint,
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400, fontSize: 14),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14)),
              child: TextField(
                controller: _messageCtrl,
                decoration: InputDecoration(
                  hintText: l.feedbackContentHint,
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400, fontSize: 14),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.all(16),
                ),
                maxLines: 10,
                minLines: 10,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _sending ? null : _send,
              style: ElevatedButton.styleFrom(
                  backgroundColor: _gold,
                  foregroundColor: const Color(0xFF1A1A1A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
              child: _sending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF1A1A1A)))
                  : Text(l.feedbackButton,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(height: 14),

            Center(
              child: Text(
                l.feedbackFooter,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12, color: Colors.grey.shade400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:email_validator/email_validator.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:win_ui/core/providers/auth_state.dart';
import 'package:win_ui/core/services/info_bar_service.dart';
import 'package:win_ui/widgets/card_highlight.dart';
import 'package:win_ui/widgets/page.dart';
import 'package:win_ui/widgets/pane_profile_card.dart';

class YourInfoPage extends StatefulWidget {
  const YourInfoPage({Key? key}) : super(key: key);

  @override
  State<YourInfoPage> createState() => _YourInfoPageState();
}

class _YourInfoPageState extends State<YourInfoPage> with PageMixin {
  bool selected = true;
  String? comboboxValue;
  Widget spacer = const SizedBox(height: 4.0);
  Widget bigSpacer = const SizedBox(height: 30.0);
  bool emailError = false;
  bool passValidationErr = false;

  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _emailController.addListener(() => validateEmail());
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void validateEmail() {
    String email = _emailController.text;
    if (email.isEmpty) {
      setState(() => emailError = false);
      return;
    }
    setState(() {
      emailError = !EmailValidator.validate(_emailController.text);
    });
  }

  void updateUserName(BuildContext context, String name) async {
    if (_fullNameController.text.isEmpty) {
      InfoBarService.showInfoBar(
        context,
        InfoBarContent(
          title: 'Info',
          contnet: 'Please enter your name',
          barSeverity: InfoBarSeverity.warning,
        ),
      );
      return;
    }
    AuthState state = Provider.of<AuthState>(context, listen: false);
    final bool res = await state.updateName(name);
    if (res) {
      // ignore: use_build_context_synchronously
      InfoBarService.showInfoBar(
        context,
        InfoBarContent(
          title: 'Success',
          contnet: 'Name has been updated.',
          barSeverity: InfoBarSeverity.success,
        ),
      );
      _fullNameController.clear();
      return;
    }
    // ignore: use_build_context_synchronously
    InfoBarService.showInfoBar(
      context,
      InfoBarContent(
        title: 'Error',
        contnet: 'An error occured while updating your name, please try again.',
        barSeverity: InfoBarSeverity.error,
      ),
    );
  }

  void updateEmail(BuildContext context) async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      InfoBarService.showInfoBar(
        context,
        InfoBarContent(
          title: 'Info',
          contnet: 'Please enter email and password.',
          barSeverity: InfoBarSeverity.warning,
        ),
      );
      return;
    }
    if (!EmailValidator.validate(_emailController.text)) {
      InfoBarService.showInfoBar(
        context,
        InfoBarContent(
          title: 'Error',
          contnet: 'Please enter a valid email.',
          barSeverity: InfoBarSeverity.error,
        ),
      );
      return;
    }
    AuthState state = Provider.of<AuthState>(context, listen: false);
    final bool res = await state.updateEmail(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (res) {
      // ignore: use_build_context_synchronously
      InfoBarService.showInfoBar(
        context,
        InfoBarContent(
          title: 'Success',
          contnet: 'Email has been updated.',
          barSeverity: InfoBarSeverity.success,
        ),
      );
      _emailController.clear();
      _passwordController.clear();
      return;
    }
    // ignore: use_build_context_synchronously
    InfoBarService.showInfoBar(
      context,
      InfoBarContent(
        title: 'Error',
        contnet: 'An error occured while updating your email, please try again.',
        barSeverity: InfoBarSeverity.error,
      ),
    );
  }

  void updatePassword(BuildContext context) async {
    if (_currentPasswordController.text.isEmpty || _newPasswordController.text.isEmpty) {
      InfoBarService.showInfoBar(
        context,
        InfoBarContent(
          title: 'Info',
          contnet: 'Please enter both current and new passwords.',
          barSeverity: InfoBarSeverity.warning,
        ),
      );
      return;
    }
    if (_currentPasswordController.text.length < 8) {
      InfoBarService.showInfoBar(
        context,
        InfoBarContent(
          title: 'Error',
          contnet: 'Incorrect password, please check your password.',
          barSeverity: InfoBarSeverity.error,
        ),
      );
      return;
    }
    if (_newPasswordController.text.length < 8) {
      InfoBarService.showInfoBar(
        context,
        InfoBarContent(
          title: 'Error',
          contnet: 'Password should have have minimum length of Eight characters.',
          barSeverity: InfoBarSeverity.error,
        ),
      );
      return;
    }
    AuthState state = Provider.of<AuthState>(context, listen: false);
    final bool res = await state.updatePassword(
      password: _newPasswordController.text,
      oldPassword: _currentPasswordController.text,
    );
    if (res) {
      // ignore: use_build_context_synchronously
      InfoBarService.showInfoBar(
        context,
        InfoBarContent(
          title: 'Success',
          contnet: 'Password has been updated.',
          barSeverity: InfoBarSeverity.success,
        ),
      );
      _currentPasswordController.clear();
      _newPasswordController.clear();
      return;
    }
    // ignore: use_build_context_synchronously
    InfoBarService.showInfoBar(
      context,
      InfoBarContent(
        title: 'Error',
        contnet: 'An error occured while updating your password, please try again.',
        barSeverity: InfoBarSeverity.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    final theme = FluentTheme.of(context);
    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Your info')),
      children: [
        Consumer<AuthState>(builder: (context, state, child) {
          if (!state.isLoggedIn) return Container();
          return const PaneProfileCard(showLargeCard: true, onTap: null);
        }),
        bigSpacer,
        Text('Adjust your photo', style: theme.typography.bodyStrong),
        spacer,
        spacer,
        FluentCard(
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 18.0, left: 10.0),
                  child: Icon(FluentIcons.camera),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Take a photo', style: theme.typography.body),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 120,
                  child: Button(
                    child: const Text('Open Camera'),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
        ),
        spacer,
        FluentCard(
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 18.0, left: 10.0),
                  child: Icon(FluentIcons.fabric_folder),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Choose a file', style: theme.typography.body),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 120,
                  child: Button(
                    child: const Text('Browse files'),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
        ),
        bigSpacer,
        Text('Update data', style: theme.typography.bodyStrong),
        spacer,
        spacer,
        FluentExpandingCard(
          leading: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(FluentIcons.edit_contact),
          ),
          title: Text('Update name', style: theme.typography.body),
          content: Align(
            alignment: AlignmentDirectional.topStart,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300,
                  child: TextBox(
                    controller: _fullNameController,
                    placeholder: 'Full Name',
                    expands: false,
                    keyboardType: TextInputType.name,
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 130,
                  child: FilledButton(
                    child: const Text('Update Name'),
                    onPressed: () => updateUserName(context, _fullNameController.text),
                  ),
                )
              ],
            ),
          ),
        ),
        spacer,
        FluentExpandingCard(
          leading: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(FluentIcons.edit_mail),
          ),
          title: Text('Update email', style: theme.typography.body),
          content: Align(
            alignment: AlignmentDirectional.topStart,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300,
                  child: TextBox(
                    controller: _emailController,
                    placeholder: 'Email',
                    expands: false,
                    keyboardType: TextInputType.emailAddress,
                    highlightColor: emailError ? Colors.red : null,
                    style: emailError ? const TextStyle(color: Color(0xFFEB7A5B)) : null,
                  ),
                ),
                spacer,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 300,
                      child: PasswordBox(
                        controller: _passwordController,
                        placeholder: 'Password',
                        revealMode: PasswordRevealMode.peekAlways,
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 130,
                      child: FilledButton(
                        onPressed: () => updateEmail(context),
                        child: const Text('Update Email'),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        spacer,
        FluentExpandingCard(
          leading: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(FluentIcons.rename),
          ),
          title: Text('Update password', style: theme.typography.body),
          content: Align(
            alignment: AlignmentDirectional.topStart,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300,
                  child: PasswordBox(
                    controller: _currentPasswordController,
                    placeholder: 'Current Password',
                    revealMode: PasswordRevealMode.peekAlways,
                  ),
                ),
                spacer,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 300,
                      child: PasswordBox(
                        controller: _newPasswordController,
                        placeholder: 'New Password',
                        revealMode: PasswordRevealMode.peekAlways,
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 130,
                      child: FilledButton(
                        onPressed: () => updatePassword(context),
                        child: const Text('Update Password'),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        bigSpacer,
      ],
    );
  }
}

import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:win_ui/core/providers/auth_state.dart';
import 'package:win_ui/core/services/info_bar_service.dart';
import 'package:win_ui/widgets/page.dart';
import 'package:email_validator/email_validator.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with PageMixin {
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool emailError = false;

  final spacer = const SizedBox(height: 5);

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailController.addListener(() => validateEmail());
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void validateEmail() {
    String email = _emailController.text;
    if (email.isEmpty) {
      setState(() {
        emailError = false;
      });
      return;
    }
    setState(() {
      emailError = !EmailValidator.validate(_emailController.text);
    });
  }

  void _signup() {
    if (_passwordController.text.length < 8) {
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
    state.signUp(
      name: _fullNameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    // final theme = FluentTheme.of(context);

    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('SignUp')),
      children: [
        TextBox(
          controller: _fullNameController,
          placeholder: 'Full Name',
          expands: false,
          keyboardType: TextInputType.name,
        ),
        spacer,
        TextBox(
          controller: _emailController,
          placeholder: 'Email',
          expands: false,
          keyboardType: TextInputType.emailAddress,
          highlightColor: emailError ? Colors.red : null,
          style: emailError ? const TextStyle(color: Color(0xFFEB7A5B)) : null,
        ),
        spacer,
        PasswordBox(
          controller: _passwordController,
          revealMode: PasswordRevealMode.peekAlways,
          placeholder: 'Password',
        ),
        spacer,
        spacer,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: _signup,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text('SignUp'),
              ),
            )
          ],
        ),
      ],
    );
  }
}

import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:win_ui/core/providers/auth_state.dart';
import 'package:win_ui/widgets/page.dart';
import 'package:email_validator/email_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with PageMixin {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool emailError = false;

  final spacer = const SizedBox(height: 5);

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailController.addListener(() => validateEmail());
  }

  @override
  void dispose() {
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

  void _login() {
    AuthState state = Provider.of<AuthState>(context, listen: false);
    state.login(email: _emailController.text, password: _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    // final theme = FluentTheme.of(context);

    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Login')),
      children: [
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
              onPressed: _login,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text('Login'),
              ),
            )
          ],
        ),
      ],
    );
  }
}

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merosathi/bloc/authentication/bloc.dart';
import 'package:merosathi/bloc/login/bloc.dart';
import 'package:merosathi/repositories/userRepository.dart';
import 'package:merosathi/ui/constants.dart';
import 'package:merosathi/ui/pages/signUp.dart';
import 'package:merosathi/ui/widgets/fade_animation.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  LoginForm({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Login Failed"),
                Icon(Icons.error),
              ],
            )));
        }
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Logging in..."),
                CircularProgressIndicator(),
              ],
            )));
        }
        if (state.isSuccess) {
          print("isSuccess");
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {

        return  Scaffold(
      body: CustomPaint(
        painter: BackgroundSignIn(),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                children: <Widget>[
                  _getHeader(),
                  _getTextFields(state),
                  _getSignIn(state),
                  _getBottomRow(context),
                ],
              ),
            ),
            _getBackBtn(),
          ],
        ),
      ),
    );
      }),
    );
  
  }
  _getBackBtn() {
  return Positioned(
    top: 35,
    left: 25,
    child: Icon(
      Icons.arrow_back_ios,
      color: Colors.white,
    ),
  );
}

_getBottomRow(context) {
  return Expanded(
    flex: 1,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          onTap: (){
            Navigator.of(context).push(
                            MaterialPageRoute(builder: (context){
                              return SignUp(userRepository: _userRepository);
                            }));
          
          },
                  child: Text(
            'Sign up',
            style: GoogleFonts.raleway(fontSize: 15,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,)
            
          ),
        ),
        Text(
          'Forgot Password',
          style: GoogleFonts.raleway(fontSize: 15,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,)
            
          
        ),
      ],
    ),
  );
}


_getSignIn(LoginState state) {
  return Expanded(
    flex: 1,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Sign in',
          style: GoogleFonts.raleway(fontSize: 25, fontWeight: FontWeight.w500 ),
          
        ),
        GestureDetector(
            onTap: () { 
              
            _onFormSubmitted();

            },
            child: CircleAvatar(
            backgroundColor: Colors.grey.shade800,
            radius: 40,
            child: Icon(
             EvaIcons.heartOutline ,
              color: Colors.red,
            ),
          ),
        )
      ],
    ),
  );
}

_getTextFields(LoginState state) {
  return Expanded(
    flex: 4,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: _emailController,
          autovalidate: true,
          validator: (_) {
         return !state.isEmailValid ? "Invalid Email" : null;
            },
          decoration: InputDecoration(labelText: 'Email', labelStyle: GoogleFonts.raleway()),
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: _passwordController,
          autovalidate: true,
           autocorrect: false,
          obscureText: true,
          validator: (_) {
             return !state.isPasswordValid ? "Invalid Password" : null;
          },
          decoration: InputDecoration(labelText: 'Password', labelStyle: GoogleFonts.raleway()),
        ),
        SizedBox(
          height: 25,
        ),
      ],
    ),
  );
}

_getHeader() {
  return Expanded(
    flex: 3,
    child: Container(
      alignment: Alignment.bottomLeft,
      child: Text(
        'Welcome\nBack',
        style: GoogleFonts.raleway(color: Colors.white, fontSize: 40,)
        //  TextStyle(color: Colors.white, fontSize: 40, fontFamily:),
      ),
    ),
  );
}


  
  

  void _onEmailChanged() {
    _loginBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onFormSubmitted() {
    _loginBloc.add(LoginWithCredentialsPressed(
        email: _emailController.text, password: _passwordController.text));
  }
}


class BackgroundSignIn extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var sw = size.width;
    var sh = size.height;
    var paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, sw, sh));
    paint.color = Colors.grey.shade100;
    canvas.drawPath(mainBackground, paint);

    Path blueWave = Path();
    blueWave.lineTo(sw, 0);
    blueWave.lineTo(sw, sh * 0.5);
    blueWave.quadraticBezierTo(sw * 0.5, sh * 0.45, sw * 0.2, 0);
    blueWave.close();
    paint.color = Colors.red.shade300;
    canvas.drawPath(blueWave, paint);

    Path greyWave = Path();
    greyWave.lineTo(sw, 0);
    greyWave.lineTo(sw, sh * 0.1);
    greyWave.cubicTo(
        sw * 0.95, sh * 0.15, sw * 0.65, sh * 0.15, sw * 0.6, sh * 0.38);
    greyWave.cubicTo(sw * 0.52, sh * 0.52, sw * 0.05, sh * 0.45, 0, sh * 0.4);
    greyWave.close();
    paint.color = Colors.black87;
    canvas.drawPath(greyWave, paint);

    Path yellowWave = Path();
    yellowWave.lineTo(sw * 0.7, 0);
    yellowWave.cubicTo(
        sw * 0.6, sh * 0.05, sw * 0.27, sh * 0.01, sw * 0.18, sh * 0.12);
    yellowWave.quadraticBezierTo(sw * 0.12, sh * 0.2, 0, sh * 0.2);
    yellowWave.close();
    paint.color = Colors.pink.shade300;
    canvas.drawPath(yellowWave, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

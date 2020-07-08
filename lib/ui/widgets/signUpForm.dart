import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merosathi/bloc/authentication/authentication_bloc.dart';
import 'package:merosathi/bloc/authentication/authentication_event.dart';
import 'package:merosathi/bloc/signup/bloc.dart';
import 'package:merosathi/repositories/userRepository.dart';

class SignUpForm extends StatefulWidget {
  final UserRepository _userRepository;

  SignUpForm({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignUpBloc _signUpBloc;
  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isSignUpButtonEnabled(SignUpState state) {
    return isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    //_signUpBloc = SignUpBloc(userRepository: _userRepository);
    _signUpBloc = BlocProvider.of<SignUpBloc>(context);


    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<SignUpBloc, SignUpState>(
      
      listener: (BuildContext context, SignUpState state) {
        if (state.isFailure) {
          Scaffold.of(context)
          ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Sign Up Failed"),
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
                Text("Signing Up..."),
                CircularProgressIndicator(),
              ],
            )));
        }

        if (state.isSuccess) {
          print("isSuccess");
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<SignUpBloc, SignUpState>(
        builder: ( context,  state) {
          return Scaffold(
      body: CustomPaint(
        painter: BackgroundSignUp(),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                children: <Widget>[
                  _getHeader(),
                  _getTextFields(state),
                  _getSignIn(),
                  _getBottomRow(context),
                ],
              ),
            ),
            _getBackBtn()
          ],
        ),
      ),
    );
        },
      ),
    );
  }

  _getBackBtn() {
  return Positioned(
      top: 35,
      left: 25,
      child: GestureDetector(
        onTap: () {  Navigator.pop(context);
        },
              child: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
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
            Navigator.pop(context);
          },
                  child: Text(
            'Sign in',
            style: GoogleFonts.raleway(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        Text(
          '',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    ),
  );
}

_getSignIn() {
  return Expanded(
    flex: 1,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Sign up',
          style: GoogleFonts.raleway(color: Colors.white,fontSize: 25, fontWeight: FontWeight.w500)
          
        ),
        GestureDetector(
            onTap: () {
               _onFormSubmitted(); 
            },
            child: CircleAvatar(
            backgroundColor: Colors.grey.withOpacity(.8),
            radius: 40,
            child: Icon(
              FontAwesomeIcons.kissWinkHeart,
              
              color: Colors.red,
            ),
          ),
        )
      ],
    ),
  );
}

_getTextFields(SignUpState state) {
  return Expanded(
    flex: 4,
    child: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          TextField(
            
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              labelText: 'Name', labelStyle: GoogleFonts.raleway(color: Colors.white)),
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            controller: _emailController,
            autovalidate: true,
            validator: (_) {
              return !state.isEmailValid ? "Invalid Email" : null;
            },
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              labelText: 'Email', labelStyle: GoogleFonts.raleway(color: Colors.white)),
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
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              labelText: 'Password', labelStyle: GoogleFonts.raleway(color: Colors.white)),
          ),
          SizedBox(
            height: 25,
          ),
        ],
      ),
    ),
  );
}

_getHeader() {
  return Expanded(
    flex: 3,
    child: Container(
      alignment: Alignment.bottomLeft,
      child: Text(
        'Create\nAccount',
        style: GoogleFonts.raleway(color: Colors.white, fontSize: 40),
      ),
    ),
  );
}


  void _onEmailChanged() {
    _signUpBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _signUpBloc.add(
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
    _signUpBloc.add(SignUpWithCredentialsPressed(
        email: _emailController.text, password: _passwordController.text));
  }
}

class BackgroundSignUp extends CustomPainter {
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
    blueWave.lineTo(sw, sh * 0.65);
    blueWave.cubicTo(sw * 0.8, sh * 0.8, sw * 0.55, sh * 0.8, sw * 0.45, sh);
    blueWave.lineTo(0, sh);
    blueWave.close();
    paint.color = Colors.red.shade300;
    canvas.drawPath(blueWave, paint);

    Path greyWave = Path();
    greyWave.lineTo(sw, 0);
    greyWave.lineTo(sw, sh * 0.3);
    greyWave.cubicTo(sw * 0.65, sh * 0.45, sw * 0.25, sh * 0.35, 0, sh * 0.5);
    greyWave.close();
    paint.color = Colors.orangeAccent;
    canvas.drawPath(greyWave, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
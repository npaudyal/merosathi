import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:merosathi/bloc/authentication/authentication_bloc.dart';
import 'package:merosathi/bloc/authentication/authentication_event.dart';
import 'package:merosathi/bloc/signup/bloc.dart';
import 'package:merosathi/repositories/userRepository.dart';
import 'package:merosathi/ui/widgets/or_divider.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

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

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn =  GoogleSignIn();
  final FacebookLogin fbLogin =  FacebookLogin();

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
         // print("isSuccess");
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
           Navigator.popUntil(context, ModalRoute.withName("/"));
        }
      },
      child: BlocBuilder<SignUpBloc, SignUpState>(
        builder: ( context,  state) {
           return Scaffold(
      body: SingleChildScrollView(
        child: CustomPaint(
          painter: BackgroundSignIn(),
                  child: Container(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                   
                   _getHeader(),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.1,vertical: size.width*0.1),
                      height: MediaQuery.of(context).size.height * 0.70,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors:  [Colors.black12, Colors.black],
                          begin: Alignment.topCenter, end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)
                        )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          
                         Spacer(),
                             
                TextFormField(
                          controller: _emailController,
                         autovalidate: true,
                        validator: (_) {
                        return !state.isEmailValid ? "Invalid Email" : null;
                             },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.lightGreen, width:3),
                              
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.white, width:3)
                            ),
                            border: InputBorder.none,

                            contentPadding:
                                EdgeInsets.symmetric(horizontal: size.width / 20,vertical: size.width/30),
                            labelStyle: GoogleFonts.ubuntu(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                            
                            hintText: "Email",
                            hintStyle: GoogleFonts.ubuntu(
                              color: Colors.black38,
                            ),
                            fillColor: Colors.black,
                           
                            focusColor: Colors.white,
                            
                            
                          ),
                          cursorColor: Colors.black,
                          textAlign: TextAlign.left,
                        ),
                      
    
                          SizedBox(height: 10),
                  
                    TextFormField(
                          controller: _passwordController,
                          autovalidate: true,
                          autocorrect: false,
                          obscureText: true,
                          validator: (_) {
                            return !state.isPasswordValid ? "Invalid Password" : null;
                         },
                         
                          decoration: InputDecoration(
                            
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightGreen, width: 3),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          border: InputBorder.none,
                            enabledBorder:  OutlineInputBorder(
                            
                              borderRadius: BorderRadius.circular(30,
                              ),
                              
                              
                              
                              borderSide:  BorderSide(color: Colors.white, width: 3),
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: size.width / 20,vertical: size.width/30),
                            labelStyle: GoogleFonts.ubuntu(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            
                            hintText: "Password",
                            hintStyle: GoogleFonts.ubuntu(
                              color: Colors.black38,
                            ),
                            fillColor: Colors.black,
                            
                            focusColor: Colors.white,
                            
                            
                          ),
                          cursorColor: Colors.black,
                          textAlign: TextAlign.left,
                        ),
                  
                
                SizedBox(height: size.height * 0.02),
       
                 Center(
                   child: Container(
                              height: size.width* 0.1,
                              width: size.width*0.4,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.green
                              ),
                              child: GestureDetector(
                                onTap: () {
                                      _onFormSubmitted(); 
                                      
                                },
                                child: Center(
                                  child: Text("Sign Up", style: GoogleFonts.ubuntu(color: Colors.white),)
                                ),
                              ),
                            ),
                 ),

                 SizedBox(height: size.height * 0.02,),

                   Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Already have an account? ",
                            style: GoogleFonts.ubuntu(fontSize:15, color: Colors.white),
                            ),

                            
                            


                             GestureDetector(
                              onTap: () {
                          Navigator.of(context).pop();
            
            
                              },
                              child: Container(
                                height: size.width * 0.08,
                                width: size.width /4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.transparent
                                  
                                ),
                                child: Center(child: Text("Log In", style: GoogleFonts.ubuntu(color:Colors.blue, fontSize: 16),)),
                              ),
                            ),


                          ],
                            ),


                        
                      OrDivider(),

                      _buildSocialBtnRow(),



           
                         

                        

                         

                          
                        ],
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    },
      ),
    );
  }

  _googleSignIn() async {

      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      try{
      final FirebaseUser user = (await firebaseAuth.signInWithCredential(credential)).user;
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
       Navigator.popUntil(context, ModalRoute.withName("/"));

          
      } catch (e) {

      }


  }

  _facebookLogin() async {

    await fbLogin.logIn(['email', 'public_profile', "user_friends"]).then((result){
      switch(result.status) {
        case FacebookLoginStatus.loggedIn:
        AuthCredential cred = FacebookAuthProvider.getCredential(accessToken:result.accessToken.token);
       FirebaseAuth.instance.signInWithCredential(cred)
        .then((user) {
       BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
       Navigator.popUntil(context, ModalRoute.withName("/"));
        }).catchError((e) {
          print(e);
        });
        break;
        default:
      }

    

    }).catchError((e) {
        print(e);
    });

  }


_getHeader() {
  return Expanded(
    
    child: Container(
      
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
            Navigator.of(context).pop();
          }),

          Center(
              
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'Welcome to JODI',
                style: GoogleFonts.shadowsIntoLight(color: Colors.white, fontSize: 40,),
                textAlign: TextAlign.center,
                //  TextStyle(color: Colors.white, fontSize: 40, fontFamily:),
              ),
            ),
          ),
          
        ],
      ),
    ),
  );
}
 Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.0,
        width: 50.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

 Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () => _facebookLogin(),
            AssetImage(
              'assets/images/facebook.jpg',
              
            ),
          ),
          _buildSocialBtn(
            () => _googleSignIn(),
            AssetImage(
              'assets/images/google.jpg',
            ),
          ),
        ],
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
        email: _emailController.text.trim(), password: _passwordController.text));
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
    paint.color = Colors.blue.shade900;
    canvas.drawPath(blueWave, paint);

    Path greyWave = Path();
    greyWave.lineTo(sw, 0);
    greyWave.lineTo(sw, sh * 0.1);
    greyWave.cubicTo(
        sw * 0.95, sh * 0.15, sw * 0.65, sh * 0.15, sw * 0.6, sh * 0.38);
    greyWave.cubicTo(sw * 0.52, sh * 0.52, sw * 0.05, sh * 0.45, 0, sh * 0.4);
    greyWave.close();
    paint.color = Colors.black;
    canvas.drawPath(greyWave, paint);

    Path yellowWave = Path();
    yellowWave.lineTo(sw * 0.7, 0);
    yellowWave.cubicTo(
        sw * 0.6, sh * 0.05, sw * 0.27, sh * 0.01, sw * 0.18, sh * 0.12);
    yellowWave.quadraticBezierTo(sw * 0.12, sh * 0.2, 0, sh * 0.2);
    yellowWave.close();
    paint.color = Colors.deepOrange;
    canvas.drawPath(yellowWave, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

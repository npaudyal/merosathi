import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merosathi/bloc/authentication/bloc.dart';
import 'package:merosathi/bloc/login/bloc.dart';
import 'package:merosathi/repositories/userRepository.dart';

import 'package:merosathi/ui/widgets/or_divider.dart';

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
                Text("Please check your email and password!"),
                Icon(Icons.error),
              ],
            ),
             backgroundColor: Colors.red,
            ));
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
            ),
            
            ));
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {


      return Scaffold(
              body: Stack(
                children:<Widget> [
                  Container
                  (
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xff414141), Color(0xff000000



)],
                      begin: Alignment.topCenter, end: Alignment.bottomCenter
                       )
                      
                    ),


                  ),
 GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: EdgeInsets.only(top: 55),
              child: ListView(
                  children: <Widget>[
                    Text(
                      'Welcome to',
                      style: GoogleFonts.pacifico(
                        color: Colors.white60,
                        fontSize: 45,
                         fontWeight: FontWeight.w200,
                       
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Jodi.",
                      style: GoogleFonts.loversQuarrel(
                        color: Colors.white,
                        fontSize: 45,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.white
                        ),
                        controller: _emailController,
                        autovalidate: true,
                       
                              validator: (_) {
                                
                          return !state.isEmailValid ? "Invalid Email" : null;
                               },
                           cursorColor: Colors.white,
                        decoration: InputDecoration(
                         
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.pink,
                              width: 2.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.pink,
                              width: 2.5,
                            ),
                          ),
                          labelText: 'E-mail',
                          
                          labelStyle: TextStyle(
                            color:Colors.grey,
                            fontWeight: FontWeight.w300,
                          ),
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color:Colors.grey
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: TextFormField(
                        autovalidate: true,
                         validator: (_) {
                          return !state.isPasswordValid
                              ? "Invalid Password"
                              : null;
                        },
                        controller: _passwordController,
                        obscureText: true,
                        cursorColor: Colors.white,
                        style: TextStyle(
                          color: Colors.white
                        ),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.pink,
                              width: 2.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.pink,
                              width: 2.5,
                            ),
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w300,
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 25),
                      height: 55,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isLoginButtonEnabled(state) ? Colors.green: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: FlatButton(
                        onPressed: isLoginButtonEnabled(state)
                                ? _onFormSubmitted
                                : null,
                        child: Text(
                          'Log In',
                          style: GoogleFonts.ubuntu(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                    ),

             
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                   
                   OrDivider(),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 30, top: 15),
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                            color: Color(0xFFF25652),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: _buildSocialBtn(
                () {
                  _loginBloc.add(
                    LoginWithFacebookPressed(),
                  );
    
                    },
                AssetImage(
                  'assets/facebook.png',
                  
                ),
                          ),
                          
                         
                        ),
                        SizedBox(width: size.width * 0.05), 
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                            color: Color(0xFFF25652),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child:  _buildSocialBtn(
                () {
                  _loginBloc.add(
                    LoginWithGooglePressed(),
                  );
                  
                },
                AssetImage(
                  'assets/google.png',
                ),
              ),
                        ),
                      ],
                    ),
                   
                  ],
                ),
              ),
            ),
                ],
        
        ),
      );

   


      }),
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
            () {
              _loginBloc.add(
                LoginWithFacebookPressed(),
              );
    
                },
            AssetImage(
              'assets/images/facebook.jpg',
              
            ),
          ),
          _buildSocialBtn(
            () {
              _loginBloc.add(
                LoginWithGooglePressed(),
              );
              
            },
            AssetImage(
              'assets/images/google.jpg',
            ),
          ),
        ],
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
        email: _emailController.text.trim(), password: _passwordController.text));
  }
}


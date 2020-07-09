
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:merosathi/bloc/authentication/authentication_bloc.dart';
import 'package:merosathi/bloc/authentication/authentication_event.dart';
import 'package:merosathi/bloc/profile/bloc.dart';
import 'package:merosathi/repositories/userRepository.dart';
import 'package:merosathi/ui/widgets/button_tapped.dart';
import 'package:merosathi/ui/widgets/button_untapped.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';

class ProfileForm extends StatefulWidget {
  final UserRepository _userRepository;

  ProfileForm({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final int _totalPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  static TextEditingController _nameController = TextEditingController();

  
     String country,
      heightP,
      gender,
      community,
      interestedIn,
      salary,
      gotra,
      bio,
      job,
      insta,
      religion;
  String education;
  String name="";
  DateTime age;
  
  
  
  File photo, photo2, photo3, photo4, photo5, photo6, photo7;
  GeoPoint location;
  ProfileBloc _profileBloc;

  bool tapped = false;

  bool isButtonPressed = false;

  bool  isButtonPressed2 = false;

  bool isButtonPressed3 = false;

  bool isButtonPressed4 = false;

  bool isButtonPressed5 = false;

    bool isButtonPressed6 = false;

  bool isButtonPressed7 = false;

    bool isButtonPressed8 = false;
   bool isButtonPressed9 = false;
    bool isButtonPressed10 = false;
      bool isButtonPressed11 = false;




  bool _hindu = false;
  bool _christian = false;
  bool _muslim = false;
  bool _jewish = false;
  bool _sikh = false;
  bool _buddhist = false;

  bool _other = false;

  bool _us =false;
  bool _nepal =false;
  bool _uk =false;
  bool _canada =false;
  bool _aus =false;
  bool _india =false;
  bool _other1 =false;

  bool _brahmin = false;
  bool _chettri = false;
  bool _gurung = false;
  bool _magar = false;
  bool _rai = false;
  bool _limbu = false;
  bool _sunni = false;
  bool _shia = false;
  bool _gujrati = false;
  bool _tamil = false;
  bool _telugu = false;
  bool _malayali = false;
  bool _jatt = false;
  bool _punjabi = false;
  bool _sindhi = false;
  bool _bengali = false;
  bool _kami = false;
  bool _newar = false;
  bool _tamang = false;
  bool _tharu = false;
  bool _sarki = false;
   bool _thakuri = false;
    bool _other2 = false;


  bool _four = false;
  bool _five = false;
  bool _sadefive = false;
  bool _fiveten = false;
  bool _cha = false;
  bool _badi = false;

  bool letsgo = false;

  bool isButtonPressed12 = false;

  bool get isFilled =>
      _nameController.text.isNotEmpty &&
      gender != null &&
      interestedIn != null &&



      photo != null &&
      age != null;

  bool isButtonEnabled(ProfileState state) {
    return isFilled && !state.isSubmitting;
  }

  bool _isChecked = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;
  bool _isChecked5 = false;
  bool _isChecked6 = false;

  FirebaseAuth _auth;

  
  _getlocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    location = GeoPoint(position.latitude, position.longitude);
  }

  _onSubmitted() async {
    await _getlocation();
    _profileBloc.add(Submitted(
        name: _nameController.text,
        age: age,
        location: location,
        gender: gender,
        interestedIn: interestedIn,
        photo: photo,
        country: country,
        community: community,
        heightP: heightP,
        bio: bio,
        gotra: gotra,
        salary: salary,
        religion: religion,
        job: job,
        insta:insta,
        live:live,
        

        education: education));
  }

  UserRepository get _userRepository => widget._userRepository;

  int selected_radio_gen;
  int selected_radio_tile_gen;

  int selected_radio_int;
  int selected_radio_tile_int;

  bool locationshare = false;
  bool live = false;

  setSelectedRadioGen(int val) {
    setState(() {
      selected_radio_gen = val;
    });
  }

  setSelectedRadioTileGen(int val) {
    setState(() {
      selected_radio_tile_gen = val;
    });
  }

  setSelectedRadioInt(int val) {
    setState(() {
      selected_radio_int = val;
    });
  }

  setSelectedRadioTileInt(int val) {
    setState(() {
      selected_radio_tile_int = val;
    });
  }

  @override
  void initState() {
    selected_radio_gen = 0;
    selected_radio_tile_gen = 0;
    selected_radio_int = 0;
    selected_radio_tile_int = 0;

    _getlocation();
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    super.initState();
  }

  

  bool isPressed = false;
  bool isPressed2 = false;
  bool isPressed3 = false;
  bool isPressed4 = false;
  bool isPressed5 = false;
  bool isPressed6 = false;
  bool isPressed7 = false;
  bool isPressed8 = false;
  bool isPressed9 = false;

  List<String> image = ['img1.png', 'img2.png', 'img3.png'];

 
  uploadImage(File photo, String name) async {
    
    String uid = (await FirebaseAuth.instance.currentUser()).uid;

    final StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("userPhotos")
        .child(uid)
        .child(name);

     storageReference.putFile(photo);
  }

  TextEditingController _jobController = TextEditingController();
  TextEditingController _salaryController = TextEditingController();
  TextEditingController _schoolController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _gotraController = TextEditingController();
    TextEditingController _instaController = TextEditingController();





Widget bioPage() {
  Size size = MediaQuery.of(context).size;
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
    ),
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Colors.black, Colors.grey,  Colors.grey],
          begin: Alignment.topCenter, end:Alignment.bottomCenter,
          
          )
      ),
     height: size.height,
     width: size.width,
      child: SingleChildScrollView(
              child: Column(


  
               children: <Widget>[

      
              Padding(
                padding: EdgeInsets.only(right: size.width/2.2),
                child: Text("What do you do?", style: GoogleFonts.ubuntu(color: Colors.deepOrangeAccent, fontSize: 25),
                textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: 10,),

              Container(
                height: size.height*0.06,
                width: size.width/1.1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30)

                ),
                child: Padding(
                  padding:  EdgeInsets.only(left: size.width/36),
                  child: TextField(
                    controller: _jobController,
                    decoration: InputDecoration(
                     border: InputBorder.none,
                    
                     labelStyle: GoogleFonts.ubuntu(
                       color: Colors.black87,
                       fontSize: 13,
                     ),
                     hintText: "Your day job...",
                     focusColor: Colors.orangeAccent,
                     

                    ),
                    cursorColor: Colors.black,
                    textAlign: TextAlign.left,

                    
                  ),
                ),
              ),

              SizedBox(height:20),
               Padding(
                padding: EdgeInsets.only(right: size.width /4.5),
                child: Text("How much do you make?", style: GoogleFonts.ubuntu(color: Colors.deepOrange, fontSize: 25),
                ),
              ),
              SizedBox(height: 10,),

               Container(
                height: size.height*0.06,
                width: size.width/1.1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30)

                ),
                child: Padding(
                  padding:  EdgeInsets.only(left: size.width/36),
                  child: TextField(
                    controller: _salaryController,
                    decoration: InputDecoration(
                     border: InputBorder.none,
                    
                     labelStyle: GoogleFonts.ubuntu(
                       color: Colors.black87,
                       fontSize: 13,
                     ),
                     hintText: "....",
                     focusColor: Colors.orangeAccent,
                     

                    ),
                    cursorColor: Colors.black,
                    textAlign: TextAlign.left,

                    
                  ),
                ),
              ),
              SizedBox(height:20),
               Padding(
                padding:  EdgeInsets.only(right: size.width/1.5),
                child: Text("School?", style: GoogleFonts.ubuntu(color: Colors.deepOrange, fontSize: 25),
                ),
              ),
              SizedBox(height: 20,),

               Container(
                height: size.height*0.06,
                width: size.width/1.1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30)

                ),
                child: Padding(
                  padding:  EdgeInsets.only(left: size.width/36),
                  child: TextField(
                    controller: _schoolController,
                    decoration: InputDecoration(
                     border: InputBorder.none,
                    
                     labelStyle: GoogleFonts.ubuntu(
                       color: Colors.black87,
                       fontSize: 13,
                     ),
                     hintText: "University of ...",
                     focusColor: Colors.orangeAccent,
                     

                    ),
                    cursorColor: Colors.black,
                    textAlign: TextAlign.left,

                    
                  ),
                ),
              ),
               SizedBox(height:10),
               Padding(
                padding:  EdgeInsets.only(right: size.width/1.4),
                child: Text("Gotra?", style: GoogleFonts.ubuntu(color: Colors.deepOrange, fontSize: 25),
                ),
              ),
              SizedBox(height: 20,),
               Container(
                height: size.height*0.06,
                width: size.width/1.1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30)

                ),
                child: Padding(
                  padding:  EdgeInsets.only(left: size.width/36),
                  child: TextField(
                  controller: _gotraController,
                    decoration: InputDecoration(
                     border: InputBorder.none,
                    
                     labelStyle: GoogleFonts.ubuntu(
                       color: Colors.black87,
                       fontSize: 13,
                     ),
                     hintText: "Who knows...",
                     focusColor: Colors.orangeAccent,
                     

                    ),
                    cursorColor: Colors.black,
                    textAlign: TextAlign.left,

                    
                  ),
                ),
              ),
               SizedBox(height:10),
               Padding(
                padding:  EdgeInsets.only(right: size.width/1.27),
                child: Text("Bio", style: GoogleFonts.ubuntu(color: Colors.deepOrange, fontSize: 25),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                height: size.height*0.15,
                width: size.width/1.1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30)

                ),
                child: Padding(
                  padding:  EdgeInsets.only(left:size.width/35),
                  child: TextField(
                    controller: _bioController,
                    decoration: InputDecoration(
                     border: InputBorder.none,
                    
                     labelStyle: GoogleFonts.ubuntu(
                       color: Colors.black87,
                       fontSize: 13,
                     ),
                     hintText: "Something interesting about you...",
                     focusColor: Colors.orangeAccent,
                     

                    ),
                    cursorColor: Colors.black,
                    textAlign: TextAlign.left,

                    
                  ),
                ),

              ),

 SizedBox(height: 10,),
 Padding(
                padding:  EdgeInsets.only(right: size.width/2.5),
                child: Text("Instagram handle", style: GoogleFonts.ubuntu(color: Colors.deepOrange, fontSize: 25),
                ),
              ),

               SizedBox(height: 10,),


               Container(
                height: size.height*0.06,
                width: size.width/1.1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30)

                ),
                child: Padding(
                  padding:  EdgeInsets.only(left:size.width/35),
                  child: TextField(
                    controller: _instaController,
                    decoration: InputDecoration(
                     border: InputBorder.none,
                    
                     labelStyle: GoogleFonts.ubuntu(
                       color: Colors.black87,
                       fontSize: 13,
                     ),
                     hintText: "@",
                     focusColor: Colors.orangeAccent,
                     

                    ),
                    cursorColor: Colors.black,
                    textAlign: TextAlign.left,

                    
                  ),
                ),

              ),


             letsgo == false ? buttonUnTappedWithText(context, Colors.deepOrange, Colors.deepOrange,  () {

               setState(() {
                 letsgo = !letsgo;
                 job=_jobController.text;
                 bio = _bioController.text;
                 education = _schoolController.text;
                 gotra= _gotraController.text;
                 salary = _salaryController.text;
                 insta = _instaController.text;
                 _onSubmitted();
                 Navigator.pop(context);
               });

                print(job);
                print(education);
                print(gotra);
                print(bio);
                print(salary);
             }, "Lets get Started",) : buttonTapped(context, () {

             }),
              

              
        
        ],
        ),
      ),
    ),

  );

}


 

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
  
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Profile Creation Unsuccessful"),
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
                Text("Submitting"),
                CircularProgressIndicator(),
              ],
            )));
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
    
        
          return LiquidSwipe(
            enableSlideIcon: true,
            enableLoop: false,
            positionSlideIcon: 0.38,
            waveType: WaveType.liquidReveal,
            pages: <Container>[
              Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
       
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.red],
          begin: Alignment.topRight, end:Alignment.bottomLeft,
          ),
          
      ),
     
              
                  child: SingleChildScrollView(
               child: Stack(
         
          children: <Widget>[

           
            Padding(
                      padding: EdgeInsets.only(top: size.width/3.3, left: size.width/12.34),
                      child: Text(
                        "Hello there, ",
                        style:
                            GoogleFonts.ubuntu(color: Colors.white, fontSize: 30),
                      )),
            SizedBox(height: 10),
            Padding(
                      padding: EdgeInsets.only(top: size.width/2.68,left: 35),
                      child: Text(
                        "Nice to meet you ",
                        style: GoogleFonts.ubuntu(
                            color: Colors.white, fontSize: 30),
                      )),
            SizedBox(height: size.height / 2.7),
            Padding(
                    padding:  EdgeInsets.only(left: size.width/12.34),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height:10),
                        Padding(
                          padding:  EdgeInsets.only(top: size.width/0.83,right:size.width/8.64),
                          child: Column(
                               children: <Widget>[
                                TextFormField(
                                      
                                      controller: _nameController,
                                      onChanged: (val) {
                                        setState(() {
                                          name = _nameController.text;
                                        });
                                      },
                                      
                                     
                                      cursorColor: Colors.white,
                                    style: TextStyle(color: Colors.white70, fontSize: 21),
                                    decoration: InputDecoration(
                                       
                                        disabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        labelStyle:
                                            TextStyle(color: Colors.white, fontSize: 18),
                                        //labelText: '',
                                        hintText: "",
                                        hintStyle:
                                            TextStyle(color: Colors.white54, fontSize: 18),
                                        ),
                                   ),
                                 
                                 SizedBox(height:10),
                            
                            Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    RichText(text: TextSpan(
                                      text: "Your name", 
                                     style: TextStyle(fontSize: 14, color: Colors.white38),
                                      
                                      children:[
                                        TextSpan(text:" *",
                                        style: GoogleFonts.ubuntu(color: Colors.white),),
                                      ],
                                    )),
                                    

                                     

                                    Text(
                                      '${_nameController.text.length} / 32',
                                      style: TextStyle(fontSize: 14, color: Colors.white38),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                            ),
                        
                               ],
                             ),
                          
                      
                        
                          
                            
                        
                        
                        ),
                      ],
                    ),
            ),
             Padding(
               padding: EdgeInsets.only(left:size.width /1.2),
               child: ClipPath(
                         clipper: SidebarClipper(),
                        
                            child: Container(
                                
                                width: size.width * 0.2,
                                 height: MediaQuery.of(context).size.height,
                                 decoration: BoxDecoration(
       
                                gradient: LinearGradient(
                                  colors: [Colors.white,Colors.white54, Colors.white38],
                                  begin: Alignment.topRight, end:Alignment.bottomLeft,
                                  ),
                                  
                              ),
     
                          
                        ),
                      ),
             ),
           Positioned(
             bottom: size.width/14.4,
             left:size.width/6.17,

             child: SingleChildScrollView(
                 child:  (_nameController.text.isEmpty || _nameController.text.length<3) ? buttonUnTapped(context,Colors.transparent,Colors.transparent, () {
                   
               }): isButtonPressed==false ? buttonUnTapped(context, Colors.red, Colors.red[200], () {
                   
                  setState(() {
                   name = _nameController.text;
                    isButtonPressed =!isButtonPressed;
                  });

                  print(name);

                  
                  
                 
                  
                  
                 


                   
               }
               ): buttonUnTapped(context, Colors.grey, Colors.blueGrey, () {}),

               
                    


             ),
           ),
          ],
        ),
                  ),
              
            
      
    ),
     
              
              
              //Birthday Page

                  Container(
      height: double.infinity,
      width: double.infinity,
    
      decoration: BoxDecoration(
       
        gradient: LinearGradient(
          colors: [Colors.white, Colors.white, ],
          begin: Alignment.topRight, end:Alignment.bottomLeft,
          ),
          
      ),
     
     
              
        child: SingleChildScrollView(
        child: Stack(
         
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Container(
                    height: size.height*0.1,
                    width:size.width,
               decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/flags.jpg'),
          fit: BoxFit.cover,
        ),
      ),
              ),
            ),

            
            Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width / 7.5, vertical: size.height/4.53),
                      child: Text(
                        "When's your birthday? ",
                        style:
                            GoogleFonts.ubuntu(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w200),
                      )),
            
            Padding(
                    padding:  EdgeInsets.only(top: size.height /2.33, left: size.width/10),
                    child:  Container(
                               
                                width: MediaQuery.of(context).size.width/1.3 ,
                                height: 50,
                                child: RaisedButton(

                                  onPressed: () {
                                    DatePicker.showDatePicker(
                                      context,
                                      showTitleActions: true,
                                      minTime: DateTime(1900, 1, 1),
                                      maxTime: DateTime(
                                          DateTime.now().year - 19, 1, 1),
                                      onConfirm: (date) {
                                        setState(() {
                                          age = date;
                                        });
                                      },
                                    );
                                  },
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                    side: BorderSide(color: Colors.pink.shade500),
                                  ),
                                  child: Text(
                                      age == null ? "Choose a date*" : "${age.month}/${age.day}/${age.year}",
                                      style: GoogleFonts.ubuntu(fontSize: 20)),
                                ),
                              ),
            ),
             Padding(
               padding: EdgeInsets.only(left:size.height/2.21),
               child: ClipPath(
                         clipper: SidebarClipper(),
                        
                            child: Container(
                                
                                width: size.width *0.2,
                                 height: MediaQuery.of(context).size.height,
                                  decoration: BoxDecoration(
       
                              gradient: LinearGradient(
                                colors: [Colors.pink, Colors.orange, ],
                                begin: Alignment.topRight, end:Alignment.bottomLeft,
                                ),
                                
                            ),
                                 
                          
                        ),
                      ),
             ),
           Positioned(
             bottom: size.width/14.4,
             left:size.width/6.17,
             child: SingleChildScrollView(
                 child:  (age==null) ? buttonUnTapped(context,Colors.transparent,Colors.transparent, () {
                   
               }): isButtonPressed2==false ? buttonUnTapped(context, Colors.pink.shade300, Colors.deepOrangeAccent, () {
                   
                  setState(() {
                  
                    isButtonPressed2 =!isButtonPressed2;
                  });

                  print(age);
                  
                 
                  
                  
                 


                   
               }
               ): buttonUnTapped(context, Colors.grey, Colors.pink.shade100, () {}),

               
                    


             ),
           ),
          ],
        ),
                  ),
              
            
      
    ),





              
                  Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
       
                              gradient: LinearGradient(
                                colors: [Colors.pink, Colors.orange, ],
                                begin: Alignment.topRight, end:Alignment.bottomLeft,
                                ),
                                
                            ),
      
        
     
              
      child: SingleChildScrollView(
      child: Stack(
         
          children: <Widget>[

            
            Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width/14.4, vertical: size.width/3.92),
                      child: Text(
                        "*I am a: ",
                        style:
                            GoogleFonts.ubuntu(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
                      )),
                     
              SizedBox(height: 10),
           
            
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: size.width/2.7),
                      child: RadioListTile(
                          title: Text("Male",
                              style: GoogleFonts.ubuntu(
                                  color: Colors.white60,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.026)),
                          value: 1,
                          groupValue: selected_radio_tile_gen,
                          onChanged: (val) {
                            setSelectedRadioTileGen(val);
                            setState(() {
                              gender = "Male";
                            });
                          },
                          activeColor: Colors.black),
                    ),
                    //   Padding(
                    //   padding: EdgeInsets.symmetric(vertical: 210),
                    //   child: Divider(color: Colors.black, height: 4,),
                    // ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: size.width/2.06),
                      child: RadioListTile(
                        title: Text("Female",
                            style: GoogleFonts.ubuntu(
                                color: Colors.white60,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.026)),
                        value: 2,
                        groupValue: selected_radio_tile_gen,
                        onChanged: (val) {
                          setSelectedRadioTileGen(val);
                          setState(() {
                            gender = "Female";
                          });
                        },
                        activeColor: Colors.black,
                      ),
                    ),
                    //  Padding(
                    //   padding: EdgeInsets.symmetric(vertical: 260),
                    //   child: Divider(color: Colors.black, height: 4,),
                    // ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: size.width/1.67),
                      child: RadioListTile(
                        title: Text("Other",
                            style: GoogleFonts.ubuntu(
                                color: Colors.white60,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.026)),
                        value: 3,
                        groupValue: selected_radio_tile_gen,
                        onChanged: (val) {
                          setSelectedRadioTileGen(val);
                          setState(() {
                            gender = "Transexual";
                          });
                        },
                        activeColor: Colors.black,
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(vertical: 310),
                    //   child: Divider(color: Colors.black, height: 4,),
                    // ),
                    SizedBox(height: 30),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width/21.6,vertical: size.width/1.24),
                      child: Text(
                        "*Interested in: ",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ubuntu(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ),

                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: size.width/1.08),
                      child: RadioListTile(
                        title: Text("Male",
                            style: GoogleFonts.ubuntu(
                                color: Colors.white60,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.026)),
                        value: 4,
                        groupValue: selected_radio_tile_int,
                        onChanged: (val) {
                          setSelectedRadioTileInt(val);
                          setState(() {
                            interestedIn = "Male";
                          });
                        },
                        activeColor: Colors.black,
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(vertical: 450),
                    //   child: Divider(color: Colors.black, height: 4,),
                    // ),
                    
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: size.width/0.96),
                       
                      child: RadioListTile(
                        title: Text("Female",
                            style: GoogleFonts.ubuntu(
                                color: Colors.white60,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.026)),
                        value: 5,
                        groupValue: selected_radio_tile_int,
                        onChanged: (val) {
                          setSelectedRadioTileInt(val);
                          setState(() {
                            interestedIn = "Female";
                          });
                        },
                        activeColor: Colors.black,
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(vertical: 500),
                    //   child: Divider(color: Colors.black, height: 4,),
                    // ),
                    
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: size.width/0.864),
                      child: RadioListTile(
                        title: Text("Other",
                            style: GoogleFonts.ubuntu(
                                color: Colors.white60,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.026)),
                        value: 6,
                        groupValue: selected_radio_tile_int,
                        onChanged: (val) {
                          setSelectedRadioTileInt(val);
                          setState(() {
                            interestedIn = "Transexual";
                          });
                        },
                        activeColor: Colors.black,
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(vertical: 550),
                    //   child: Divider(color: Colors.black, height: 4,),
                    // ),
             Padding(
               padding: EdgeInsets.only(left:size.width/1.2),
               child: ClipPath(
                         clipper: SidebarClipper(),
                        
                            child: Container(
                                
                                width: size.width * 0.2,
                                 height: MediaQuery.of(context).size.height,
                                 decoration: BoxDecoration(
       
                              gradient: LinearGradient(
                                colors: [Colors.teal, Colors.redAccent],
                                begin: Alignment.topRight, end:Alignment.bottomLeft,
                                ),
                                
                            ),
      
                                 
                          
                        ),
                      ),
             ),
           Padding(
              padding: EdgeInsets.only( right: size.width/21.6, top:size.width/0.63),
             child: SingleChildScrollView(
                 child:  (gender==null) ? buttonUnTapped(context,Colors.transparent,Colors.transparent, () {
                   
               }): isButtonPressed3==false ? buttonUnTapped(context, Colors.yellow.shade400, Colors.redAccent, () {
                   
                  setState(() {
                  
                    gender = gender;
                    interestedIn = interestedIn;
                    isButtonPressed3 = !isButtonPressed3;
                  });

                  print(gender);
                  print(interestedIn);

                  
                  
                 


                   
               }
               ): buttonUnTapped(context, Colors.grey, Colors.grey, () {}),

               
                    


             ),
           ),
          ],
        ),
                  ),
              
            
      
    ),

              //Photo Page

                 Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
       
   gradient: LinearGradient(
    colors: [Colors.green, Colors.redAccent, ],
    begin: Alignment.topRight, end:Alignment.bottomLeft,
     ),
                                
),
      
      
        
     
              
      child: SingleChildScrollView(
      child: Stack(
         
          children: <Widget>[

           
            Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width/6.5, vertical: size.width/4.5),
                      child: Text(
                        "*Attach a Profile Picture ",
                        style:
                            GoogleFonts.quicksand(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w800),
                      )),
            
                  Padding(
                    padding:  EdgeInsets.only(top:size.width/2.27, left:size.width/20),
                    child: GestureDetector(
                                onTap: () async {
                                   File getPic = await ImagePicker.pickImage(source: ImageSource.gallery,
                                           imageQuality: 100
                                           );
                                  if (getPic != null) {
                                    // await compressImage();
                                    photo = getPic;
                                    setState(() {
                                      photo = photo;
                                    });
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  width: size.width / 2.3,
                                  height: size.height / 3,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: Colors.deepPurple, width: 7),
                                      image: DecorationImage(
                                          image: photo == null
                                              ? AssetImage(
                                                  'assets/images/addImage.jpg')
                                              : FileImage(photo),
                                          fit: BoxFit.cover)),
                                 
                                ),
                              ),
                  ),
                   Padding(
                     padding:  EdgeInsets.only(top:size.width/1.6, left:size.width/2.0),
                     child: Column(
                                children: <Widget>[
                                  Text(
                                    "Your photo must clearly",
                                    overflow: TextOverflow.visible,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.ubuntu(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black87,
                                        fontSize: 16
                                        ),
                                  ),
                                  Text(
                                    " show your full face, without",
                                    overflow: TextOverflow.visible,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.ubuntu(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black87,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    "props and other people.",
                                    overflow: TextOverflow.visible,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.ubuntu(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black87,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                   ),
                    Padding(
                      padding: EdgeInsets.only(top: 480,right: 8 ),
                      child: Center(
                          child: Text(
                            ' "Having a profile Picture increases the chance of getting a match"  - Common Sense ',
                            style: GoogleFonts.openSans(
                              color: Colors.white70,
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                             
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ),

                  Positioned(

                     bottom: size.width/14.4,
                      left:size.width/6.17,
                    child: photo==null ? buttonUnTapped(context,Colors.transparent, Colors.transparent, () {})
                    : isButtonPressed4 == false ? buttonUnTapped(context, Colors.deepPurple.shade400, Colors.red.shade400, () {
                        setState(() {
                          isButtonPressed4 = !isButtonPressed4;
                        });
                        print("Got photo");
                    }) : buttonTapped(context, (){}),
                    ),

                     
             
             Padding(
               padding: EdgeInsets.only(left:size.width/1.2),
               child: ClipPath(
                         clipper: SidebarClipper(),
                        
                            child: Container(
                                
                                width: size.width * 0.2,
                                 height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(
       
                              gradient: LinearGradient(
                                colors: [Colors.red, Colors.indigo, ],
                                begin: Alignment.topRight, end:Alignment.bottomLeft,
                                ),
                                
                            ),
      
                                 
                          
                        ),
                      ),
             ),
          ],
      ),
      ),
                 ),

              // Gallary to Pictures

              
                 Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
       
                              gradient: LinearGradient(
                                colors: [Colors.red, Colors.indigo, ],
                                begin: Alignment.topRight, end:Alignment.bottomLeft,
                                ),
                                
                            ),
        
     
              
      child: SingleChildScrollView(
      child: Stack(
         
          children: <Widget>[

            Padding(
                      padding: EdgeInsets.symmetric(vertical: size.width/8.64, horizontal: size.width/2.4),
                      child: Icon(Icons.landscape, color:Colors.white, size: 30,),
                    ),
            
              Padding(
                padding:  EdgeInsets.all(size.width/54),
                child: Column(
                      children: <Widget>[
                        // Image.asset(
                        //   imgUrl,
                        //   height: 300,
                        // ),
                        SizedBox(
                          height: size.width/5.4,
                        ),

                        Text(
                          "Let's add more pictures",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.ubuntu(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Don't make it vulger folks, we are watching you",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.ubuntu(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                        ),

                        SizedBox(
                          height: size.width/8.64,
                        ),

                        
                        Row(
                          children: <Widget>[
                            SizedBox(width: size.width/7.2),

                            GestureDetector(
                              onTap: () async {
                                File getPic = await ImagePicker.pickImage(source: ImageSource.gallery,
                                              imageQuality: 40
                                               );
                                if (getPic != null) {
                                  //await compressImage();
                                   
                                   photo3 = getPic;
                                  setState(() {
                                        photo3 = photo3;
                                      });

                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(35),
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  width: size.width / 3.5,
                                  height: size.height / 4.5,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: photo3 == null
                                              ? AssetImage(
                                                  'assets/images/addImage.jpg')
                                              : FileImage(photo3),
                                          fit: BoxFit.cover)),
                                  
                                ),
                              ),
                            ),

                            SizedBox(width: size.width/14.4),
                            //photo4

                            GestureDetector(
                              onTap: () async {
                                 File getPic = await ImagePicker.pickImage(source: ImageSource.gallery,
                                              imageQuality: 40
                                              );
                                if (getPic != null) {
                                  //await compressImage();
                                  
                                  photo4 = getPic;
                                  setState(() {
                                        photo4 = photo4;
                                      });
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(35),
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  width: size.width / 3.5,
                                  height: size.height / 4.5,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: photo4 == null
                                              ? AssetImage(
                                                  'assets/images/addImage.jpg')
                                              : FileImage(photo4),
                                          fit: BoxFit.cover)),
                                  
                                ),
                              ),
                            ),

                            //photo4:
                          ],
                        ),

                        SizedBox(height: size.width/14.4),

                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                //photo 5:

                                SizedBox(width: size.width/7.2),

                                GestureDetector(
                                  onTap: () async {
                                     File getPic = await ImagePicker.pickImage(source: ImageSource.gallery,
                                                  imageQuality: 40
                                                   );
                                    if (getPic != null) {
                                      //await compressImage();
                                     
                                      photo6 = getPic;
                                      setState(() {
                                        photo6 = photo6;
                                      });
                                    }
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(35),
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      width: size.width / 3.5,
                                      height: size.height / 4.5,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: photo6 == null
                                                  ? AssetImage(
                                                      'assets/images/addImage.jpg')
                                                  : FileImage(photo6),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                                ),

                                //photo7

                                SizedBox(width: size.width/14.4),

                                GestureDetector(
                                  onTap: () async {
                                     File getPic = await ImagePicker.pickImage(source: ImageSource.gallery,
                                                    imageQuality: 40
                                                    );
                                    if (getPic != null) {
                                      //await compressImage();
                                      
                                      photo7 = getPic;
                                      setState(() {
                                        photo7 = photo7;
                                      });
                                    }
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(35),
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      width: size.width / 3.5,
                                      height: size.height / 4.5,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: photo7 == null
                                                  ? AssetImage(
                                                      'assets/images/addImage.jpg')
                                                  : FileImage(photo7),
                                              fit: BoxFit.cover)),
                                      
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
      ],
      ),
              ),
               Padding(
               padding: EdgeInsets.only(left:size.width/1.2),
               child: ClipPath(
                         clipper: SidebarClipper(),
                        
                            child: Container(
                                
                                width: size.width*0.2,
                                 height: MediaQuery.of(context).size.height,
                                 decoration: BoxDecoration(
       
                              gradient: LinearGradient(
                                colors: [Colors.white, Colors.white24, Colors.white60],
                                begin: Alignment.topRight, end:Alignment.bottomLeft,
                                ),
                                
                            ),
                                 
                          
                        ),
                      ),
             ),

              Positioned(
                bottom: size.width/14.4,
             left:size.width/6.17,
                
                child: isButtonPressed5 == false ? buttonUnTapped(context, Colors.deepOrange.shade400, Colors.white, () async {
                      setState(() {
                        isButtonPressed5 = !isButtonPressed5;
                      });
                      try{
                               await uploadImage(photo3, "photo2");
                               await uploadImage(photo4, "photo3");

                              await uploadImage(photo6, "photo4");
                              await uploadImage(photo7, "photo5");
                              print("Gallary");
                      } catch (e) {

                      }
                }):  buttonTapped(context, () {}),

               

              )
          ],
                 ),
      ),
                 ),

          
//Religion

      Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
       
                              gradient: LinearGradient(
                                colors: [Colors.red, Colors.black],
                                begin: Alignment.topRight, end:Alignment.bottomLeft,
                                ),
                                
                            ),
                                 
      
        
     
              
      child: SingleChildScrollView(
      child: Stack(
         
          children: <Widget>[

    
            
            Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width/19.7, vertical: size.width/5),
                      child: Text(
                        "Select your Religion: ",
                        style:
                            GoogleFonts.ubuntu(color: Colors.white,fontSize: 25, fontWeight: FontWeight.w600),
                      )),
                      

                      Padding(
                        padding: EdgeInsets.only(left:5, top: size.width/2.7),
                        child: Column(
                          children: <Widget>[
                           
                            Card(
                              
                              shadowColor: Colors.black,
                              margin: EdgeInsets.only(right:5),
                               shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              color: Colors.white,
                              child: Column(
                                
                                children: <Widget>[
                                  ListTile(
                                title:Text("Hindu", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                                onTap: () {
                                  setState(() {
                                    religion ="Hindu";
                                    _hindu =!_hindu;
                                  });
                              },
                                trailing: _hindu ? Icon(Icons.check, color: Colors.blue.shade900): Text(""),
                                ),
                                Divider(
                                  
                                ),
                                ListTile(
                                title:Text("Cristian", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                                onTap: () {
                                  setState(() {
                                    religion ="Christian";
                                    _christian =!_christian;
                                  });
                              },
                                trailing: _christian ? Icon(Icons.check, color: Colors.blue.shade900): Text(""),
                                ),
                                 Divider(
                                  
                                ),
                                ListTile(
                                title:Text("Muslim", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                                onTap: () {
                                  setState(() {
                                    religion ="Muslim";
                                    _muslim =!_muslim;
                                  });
                              },
                                trailing: _muslim ? Icon(Icons.check, color: Colors.blue.shade900): Text(""),
                                ),
                                 Divider(
                                  
                                ),
                                 ListTile(
                                title:Text("Buddhist", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                                onTap: () {
                                  setState(() {
                                    religion ="Buddhist";
                                    _buddhist =!_buddhist;
                                  });
                              },
                                trailing: _buddhist ? Icon(Icons.check, color: Colors.blue.shade900): Text(""),
                                ),
                                 Divider(
                                  
                                ),
                                ListTile(
                                title:Text("Sikh", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                                onTap: () {
                                  setState(() {
                                    religion ="Sikh";
                                    _sikh =!_sikh;
                                  });
                              },
                                trailing: _sikh ? Icon(Icons.check, color:Colors.blue.shade900): Text(""),
                                ),
                                 Divider(
                                  
                                ),
                                ListTile(
                                title:Text("Jewish", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                                onTap: () {
                                  setState(() {
                                    religion ="Jewish";
                                    _jewish =!_jewish;
                                  });
                              },
                                trailing: _jewish ? Icon(Icons.check, color: Colors.blue.shade900): Text(""),
                                ),
                                 Divider(
                                  
                                ),
                                ListTile(
                                title:Text("Other", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                                onTap: () {
                                  setState(() {
                                    religion ="Other";
                                    _other =!_other;
                                  });
                              },
                                trailing: _other ? Icon(Icons.check, color: Colors.blue.shade900): Text(""),
                                ),

                                
                                



                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
            
                 
                  Positioned(

                    bottom: size.width/14.4,
                    left:size.width/6.17,
                    child: religion==null ? buttonUnTapped(context,Colors.transparent, Colors.transparent, () {})
                    : isButtonPressed6 == false ? buttonUnTapped(context, Colors.black26, Colors.redAccent, () {
                        setState(() {
                          isButtonPressed6 = !isButtonPressed6;
                        });
                        print(religion);
                    }) : buttonTapped(context, (){}),
                    ),

                     
             
             Padding(
               padding: EdgeInsets.only(left:size.width/1.2),
               child: ClipPath(
                         clipper: SidebarClipper(),
                        
                            child: Container(
                                
                                width: size.width * 0.2,
                                 height: MediaQuery.of(context).size.height,
                                 color: Colors.black
                                 
                          
                        ),
                      ),
             ),
          ],
      ),
      ),
                 ),

           
//Select your country

    Container(
      height: double.infinity,
      width: double.infinity,
     decoration: BoxDecoration(
       
                              gradient: LinearGradient(
                                colors: [Colors.black, Colors.red],
                                begin: Alignment.topRight, end:Alignment.bottomLeft,
                                ),
                                
                            ),
                                 
      
        
     
              
      child: SingleChildScrollView(
      child: Stack(
         
          children: <Widget>[

    
            
            Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width/17.7, vertical: size.width/5),
                      child: Text(
                        "Where were you raised? ",
                        style:
                            GoogleFonts.ubuntu(color: Colors.deepOrange,fontSize: 25, fontWeight: FontWeight.w600),
                      )),
                      

                      Padding(
                        padding:  EdgeInsets.only(left:5, top: size.width/2.7),
                        child: Column(
                          children: <Widget>[
                           
                            Card(
                              
                              shadowColor: Colors.white,

                              margin: EdgeInsets.only(right:5),
                               shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              color: Colors.black12.withOpacity(0.8),
                              child: Column(
                                
                                children: <Widget>[
                                ListTile(
                                title:Text("United States", style: GoogleFonts.ubuntu(color: Colors.white, fontSize: 20),),
                                onTap: () {
                                  setState(() {
                                    country ="United States";
                                    _us =!_us;
                                  });
                              },
                                trailing: _us ? Icon(Icons.check, color: Colors.white): Text(""),
                                ),
                                Divider(
                                  
                                ),
                                ListTile(
                                title:Text("Nepal", style: GoogleFonts.ubuntu(color: Colors.white, fontSize: 20),),
                                onTap: () {
                                  setState(() {
                                    country ="Nepal";
                                    _nepal =!_nepal;
                                  });
                              },
                                trailing: _nepal ? Icon(Icons.check, color: Colors.white): Text(""),
                                ),
                                 Divider(
                                  
                                ),
                                ListTile(
                                title:Text("Canada", style: GoogleFonts.ubuntu(color: Colors.white, fontSize: 20),),
                                onTap: () {
                                  setState(() {
                                    country ="Canada";
                                    _canada =!_canada;
                                  });
                              },
                                trailing: _canada ? Icon(Icons.check, color: Colors.white): Text(""),
                                ),
                                 Divider(
                                  
                                ),
                                 ListTile(
                                title:Text("UK", style: GoogleFonts.ubuntu(color: Colors.white, fontSize: 20),),
                                onTap: () {
                                  setState(() {
                                    country ="UK";
                                    _uk =!_uk;
                                  });
                              },
                                trailing: _uk ? Icon(Icons.check, color: Colors.white): Text(""),
                                ),
                                 Divider(
                                  
                                ),
                                ListTile(
                                title:Text("Australia", style: GoogleFonts.ubuntu(color: Colors.white, fontSize: 20),),
                                onTap: () {
                                  setState(() {
                                    country ="Australia";
                                    _aus =!_aus;
                                  });
                              },
                                trailing: _aus ? Icon(Icons.check, color:Colors.white): Text(""),
                                ),
                                 Divider(
                                  
                                ),
                                ListTile(
                                title:Text("India", style: GoogleFonts.ubuntu(color: Colors.white, fontSize: 20),),
                                onTap: () {
                                  setState(() {
                                    country ="India";
                                    _india =!_india;
                                  });
                              },
                                trailing: _india ? Icon(Icons.check, color: Colors.white): Text(""),
                                ),
                                 Divider(
                                  
                                ),
                                ListTile(
                                title:Text("Other", style: GoogleFonts.ubuntu(color: Colors.white, fontSize: 20),),
                                onTap: () {
                                  setState(() {
                                    country ="Other";
                                    _other1 =!_other1;
                                  });
                              },
                                trailing: _other1 ? Icon(Icons.check, color: Colors.white): Text(""),
                                ),

                                
                                



                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
            
                 
                  Positioned(

                    bottom: size.width/14.4,
                     left:size.width/6.17,
                      child: country==null ? buttonUnTapped(context,Colors.transparent,Colors.transparent, () {})
                    : isButtonPressed7 == false ? buttonUnTapped(context, Colors.white, Colors.deepOrange, () {
                        setState(() {
                          isButtonPressed7 = !isButtonPressed7;
                        });
                    }) : buttonTapped(context, (){}),
                    ),

                     
             
             Padding(
               padding: EdgeInsets.only(left:size.width/1.2),
               child: ClipPath(
                         clipper: SidebarClipper(),
                        
                            child: Container(
                                
                                width: size.width * 0.2,
                                 height: MediaQuery.of(context).size.height,
                                 color: Colors.white
                                 
                          
                        ),
                      ),
             ),
          ],
      ),
      ),
                 ),



// Select your community

    Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
       
                              gradient: LinearGradient(
                                colors: [Colors.white,Colors.black],
                                begin: Alignment.topRight, end:Alignment.bottomLeft,
                                ),
                                
                            ),
                                 
        
      child: Stack(
            children: <Widget>[  
      Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width/19.7, vertical: size.width/5),
          child: Text(
            "Select your community: ",
            style:
                GoogleFonts.ubuntu(color: Colors.deepOrange,fontSize: 25, fontWeight: FontWeight.w600),
          ),
          ),
          

          Padding(
            padding:  EdgeInsets.only(top: size.width/3),
            child: SingleChildScrollView(
                          child: Column(
                
                children: <Widget>[
                 
                 country == "Nepal" ? Card(
                    
                    shadowColor: Colors.black,

                    margin: EdgeInsets.only(left: 5, right:5),
                     shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.white70.withOpacity(0.8),
                    child: SingleChildScrollView(
                      child: Column(
                       children: <Widget>[
                          ListTile(
                       title:Text("Brahmin", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                       onTap: () {
                         setState(() {
                           community ="Brahmin";
                           _brahmin =!_brahmin;
                         });
                        },
                       trailing: _brahmin ? Icon(Icons.check, color: Colors.deepPurple): Text(""),
                       ),
                       Divider(
                         
                       ),
                       ListTile(
                       title:Text("Chettri", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                       onTap: () {
                         setState(() {
                           community ="Chettri";
                           _chettri =!_chettri;
                         });
                        },
                       trailing: _chettri ? Icon(Icons.check, color: Colors.deepPurple): Text(""),
                       ),
                        Divider(
                         
                       ),
                       ListTile(
                       title:Text("Gurung", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                       onTap: () {
                         setState(() {
                           community ="Gurung";
                           _gurung =!_gurung;
                         });
                        },
                       trailing: _gurung ? Icon(Icons.check, color: Colors.deepPurple): Text(""),
                       ),
                        Divider(
                         
                       ),
                        ListTile(
                       title:Text("Tamang", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                       onTap: () {
                         setState(() {
                           community ="Tamang";
                           _tamang =!_tamang;
                         });
                        },
                       trailing: _tamang ? Icon(Icons.check, color: Colors.deepPurple): Text(""),
                       ),
                        Divider(
                         
                       ),
                       ListTile(
                       title:Text("Newar", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                       onTap: () {
                         setState(() {
                           community ="Newar";
                           _newar =!_newar;
                         });
                        },
                       trailing: _newar ? Icon(Icons.check, color:Colors.deepPurple): Text(""),
                       ),
                        Divider(
                         
                       ),
                       ListTile(
                       title:Text("Tharu", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                       onTap: () {
                         setState(() {
                           community ="Tharu";
                           _tharu =!_tharu;
                         });
                        },
                       trailing: _tharu ? Icon(Icons.check, color:Colors.deepPurple): Text(""),
                       ),
                        Divider(
                         
                       ),
                       ListTile(
                       title:Text("Magar", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                       onTap: () {
                         setState(() {
                           community ="Magar";
                           _magar =!_magar;
                         });
                        },
                       trailing: _magar ? Icon(Icons.check, color: Colors.deepPurple): Text(""),
                       ),
                        Divider(
                         
                       ),
                       ListTile(
                       title:Text("Other", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                       onTap: () {
                         setState(() {
                           community ="Other";
                           _other2 =!_other2;
                         });
                        },
                       trailing: _other2 ? Icon(Icons.check, color: Colors.deepPurple): Text(""),
                       ),
                       ],
                      ),
                    ),
                 ): country == "India" ? Card(
                    
                    shadowColor: Colors.black,

                    margin: EdgeInsets.only(left: 5, right:5),
                     shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.white70.withOpacity(0.8),
                    child: SingleChildScrollView(
                      child: Column(
                       children: <Widget>[
              
                       ListTile(
                       title:Text("Gujrati", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                       onTap: () {
                         setState(() {
                           community ="Gujrati";
                           _gujrati =!_gujrati;
                         });
                        },
                       trailing: _gujrati ? Icon(Icons.check, color: Colors.black): Text(""),
                       ),
                       Divider(
                         
                       ),
                       ListTile(
                       title:Text("Jatt", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                       onTap: () {
                         setState(() {
                           community ="Jatt";
                           _jatt =!_jatt;
                         });
                        },
                       trailing: _jatt ? Icon(Icons.check, color: Colors.black): Text(""),
                       ),
                       Divider(
                         
                       ),
                       ListTile(
                       title:Text("Punjabi", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                       onTap: () {
                         setState(() {
                           community ="Punjabi";
                           _punjabi =!_punjabi;
                         });
                        },
                       trailing: _punjabi ? Icon(Icons.check, color: Colors.black): Text(""),
                       ),
                        Divider(
                         
                       ),
                       ListTile(
                       title:Text("Sunni", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                       onTap: () {
                         setState(() {
                           community ="Sunni";
                           _sunni =!_sunni;
                         });
                        },
                       trailing: _sunni ? Icon(Icons.check, color: Colors.black): Text(""),
                       ),
                        Divider(
                         
                       ),
                       ListTile(
                       title:Text("Shia", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                       onTap: () {
                         setState(() {
                           community ="Shia";
                           _shia =!_shia;
                         });
                        },
                       trailing: _shia ? Icon(Icons.check, color: Colors.black): Text(""),
                       ),
                        Divider(
                         
                       ),
                       ListTile(
                       title:Text("Sindhi", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                       onTap: () {
                         setState(() {
                           community ="Sindhi";
                           _sindhi =!_sindhi;
                         });
                        },
                       trailing: _sindhi ? Icon(Icons.check, color: Colors.black): Text(""),
                       ),
                        Divider(
                         
                       ),
                       ListTile(
                       title:Text("Bengali", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                       onTap: () {
                         setState(() {
                           community ="Bengali";
                           _bengali =!_bengali;
                         });
                        },
                       trailing: _bengali ? Icon(Icons.check, color: Colors.black): Text(""),
                       ),
                        Divider(
                         
                       ),
                       ListTile(
                       title:Text("Tamil", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                       onTap: () {
                         setState(() {
                           community ="Tamil";
                           _tamil =!_tamil;
                         });
                        },
                       trailing: _tamil ? Icon(Icons.check, color: Colors.black): Text(""),
                       ),
                        Divider(
                         
                       ),
                       

                       ],
                        ),
                    ),
                  ) : Card(
                    
                    shadowColor: Colors.black,

                    margin: EdgeInsets.only(left: 5, right:5),
                     shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.white70.withOpacity(0.8),
                    child: SingleChildScrollView(
                      child: Column(
                       children: <Widget>[
                          ListTile(
                       title:Text("Brahmin", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                       onTap: () {
                         setState(() {
                           community ="Brahmin";
                           _brahmin =!_brahmin;
                         });
                        },
                       trailing: _brahmin ? Icon(Icons.check, color: Colors.deepPurple): Text(""),
                       ),
                       Divider(
                         
                       ),
                       ListTile(
                       title:Text("Chettri", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                       onTap: () {
                         setState(() {
                           community ="Chettri";
                           _chettri =!_chettri;
                         });
                        },
                       trailing: _chettri ? Icon(Icons.check, color: Colors.deepPurple): Text(""),
                       ),
                        Divider(
                         
                       ),
                       ListTile(
                       title:Text("Gurung", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                       onTap: () {
                         setState(() {
                           community ="Gurung";
                           _gurung =!_gurung;
                         });
                        },
                       trailing: _gurung ? Icon(Icons.check, color: Colors.deepPurple): Text(""),
                       ),
                        Divider(
                         
                       ),
                       ListTile(
                       title:Text("Gujrati", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                       onTap: () {
                         setState(() {
                           community ="Gujrati";
                           _gujrati =!_gujrati;
                         });
                        },
                       trailing: _gujrati ? Icon(Icons.check, color: Colors.black): Text(""),
                       ),
                       Divider(
                         
                       ),
                       ListTile(
                       title:Text("Jatt", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                       onTap: () {
                         setState(() {
                           community ="Jatt";
                           _jatt =!_jatt;
                         });
                        },
                       trailing: _jatt ? Icon(Icons.check, color: Colors.black): Text(""),
                       ),
                       Divider(
                         
                       ),
                       ListTile(
                       title:Text("Punjabi", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                       onTap: () {
                         setState(() {
                           community ="Punjabi";
                           _punjabi =!_punjabi;
                         });
                        },
                       trailing: _punjabi ? Icon(Icons.check, color: Colors.black): Text(""),
                       ),
                        Divider(
                         
                       ),
                       ListTile(
                       title:Text("Sunni", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                       onTap: () {
                         setState(() {
                           community ="Sunni";
                           _sunni =!_sunni;
                         });
                        },
                       trailing: _sunni ? Icon(Icons.check, color: Colors.black): Text(""),
                       ),
                        Divider(
                         
                       ),
                        ListTile(
                       title:Text("Other", style: GoogleFonts.ubuntu(color: Colors.black, fontSize: 20),),
                       onTap: () {
                         setState(() {
                           community ="Other";
                           _other2 =!_other2;
                         });
                        },
                       trailing: _other2 ? Icon(Icons.check, color: Colors.deepPurple): Text(""),
                       ),
                       Divider(
                         
                       ),
                       ],
                      ),
                    ),
                  ),


                  
                  
                  
                ],
                  ),
            ),
          ),
        
             
      Positioned(

            bottom: size.width/14.4,
             left:size.width/6.17,
        child: community==null ? buttonUnTapped(context,Colors.transparent, Colors.transparent, () {})
        : isButtonPressed8 == false ? buttonUnTapped(context, Colors.deepOrange, Colors.orange, () {
            setState(() {
              isButtonPressed8 = !isButtonPressed8;
            });
            print(community);
        }) : buttonTapped(context, (){}),
        ),

         
         
         Padding(
           padding: EdgeInsets.only(left:size.width /1.2),
           child: ClipPath(
             clipper: SidebarClipper(),
            
                child: Container(
                    
                    width: size.width * 0.2,
                     height: MediaQuery.of(context).size.height,
                     color: Colors.black
                     
              
            ),
          ),
         ),
      ],
          ),
      ),
                 
// Height

    Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
       
                              gradient: LinearGradient(
                                colors: [Colors.black, Colors.white],
                                begin: Alignment.topRight, end:Alignment.bottomLeft,
                                ),
                                
                            ),
                                 
      
        
     
              
      child: SingleChildScrollView(
      child: Stack(
         
          children: <Widget>[

    
            
            Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width/19.63, vertical: size.width/5),
                      child: Text(
                        "How tall are you? ",
                        style:
                            GoogleFonts.ubuntu(color: Colors.deepOrange,fontSize: 25, fontWeight: FontWeight.w600),
                      )),
                      

                      Padding(
                        padding: EdgeInsets.only(left:5, top: size.width/2.7),
                        child: Column(
                          children: <Widget>[
                           
                            Card(
                              
                              shadowColor: Colors.white,

                              margin: EdgeInsets.only(right:5),
                               shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              color: Colors.black12.withOpacity(0.8),
                              child: Column(
                                
                                children: <Widget>[
                                ListTile(
                                title:Text("4'7 - 4'10", style: GoogleFonts.ubuntu(color: Colors.white, fontSize: 20),),
                                onTap: () {
                                  setState(() {
                                    heightP ="4'7 - 4'10";
                                    _four =!_four;
                                  });
                              },
                                trailing: (_four && heightP !=null) ? Icon(Icons.check, color: Colors.white): Text(""),
                                ),
                                Divider(
                                  
                                ),
                                ListTile(
                                title:Text("4'10 - 5'5", style: GoogleFonts.ubuntu(color: Colors.white, fontSize: 20),),
                                onTap: () {
                                  setState(() {
                                    heightP ="4'10 - 5'5";
                                    _five =!_five;
                                  });
                              },
                                trailing: (_five && heightP !=null) ? Icon(Icons.check, color: Colors.white): Text(""),
                                ),
                                 Divider(
                                  
                                ),
                                ListTile(
                                title:Text("5'5 - 5'8", style: GoogleFonts.ubuntu(color: Colors.white, fontSize: 20),),
                                onTap: () {
                                  setState(() {
                                    heightP ="5'5 - 5'8";
                                    _sadefive =!_sadefive;
                                  });
                              },
                                trailing: (_sadefive && heightP !=null) ? Icon(Icons.check, color: Colors.white): Text(""),
                                ),
                                 Divider(
                                  
                                ),
                                 ListTile(
                                title:Text("5'8 - 6'", style: GoogleFonts.ubuntu(color: Colors.white, fontSize: 20),),
                                onTap: () {
                                  setState(() {
                                    heightP="5'8 - 6'";
                                    _fiveten =!_fiveten;
                                  });
                              },
                                trailing: (_fiveten && heightP !=null)? Icon(Icons.check, color: Colors.white): Text(""),
                                ),
                                 Divider(
                                  
                                ),
                                ListTile(
                                title:Text("6' - 6'5", style: GoogleFonts.ubuntu(color: Colors.white, fontSize: 20),),
                                onTap: () {
                                  setState(() {
                                    heightP ="6' - 6'5";
                                    _cha =!_cha;
                                  });
                              },
                                trailing: (_cha && heightP !=null)? Icon(Icons.check, color:Colors.white): Text(""),
                                ),
                                 Divider(
                                  
                                ),
                                ListTile(
                                title:Text("6'5 + ", style: GoogleFonts.ubuntu(color: Colors.white, fontSize: 20),),
                                onTap: () {
                                  setState(() {
                                    heightP ="6'5 + ";
                                    _badi =!_badi;
                                  });
                              },
                                trailing: (_badi && heightP !=null) ? Icon(Icons.check, color: Colors.white): Text(""),
                                ),
                                

                                
                                



                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
            
                 
                  Positioned(

                     bottom: size.width/14.4,
             left:size.width/6.17,
                    child: heightP==null ? buttonUnTapped(context, Colors.transparent, Colors.transparent,() {})
                    : isButtonPressed9 == false ? buttonUnTapped(context, Colors.black, Colors.white,  () {
                        setState(() {
                          isButtonPressed9 = !isButtonPressed9;
                        });
                        print(heightP);
                        
                    }) : buttonTapped(context, (){}),
                    ),

                     
             
             Padding(
               padding: EdgeInsets.only(left:size.width/1.2),
               child: ClipPath(
                         clipper: SidebarClipper(),
                        
                            child: Container(
                                
                                width: size.width * 0.2,
                                 height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(
       
                              gradient: LinearGradient(
                                colors: [Colors.white, Colors.red,Colors.black],
                                begin: Alignment.topRight, end:Alignment.bottomLeft,
                                ),
                                
                            ),
                                 
                          
                        ),
                      ),
             ),
          ],
      ),
      ),
     ),


    
             
//Looking For

 Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
       
                              gradient: LinearGradient(
                                colors: [Colors.black, Colors.red,Colors.black],
                                begin: Alignment.topRight, end:Alignment.bottomLeft,
                                ),
                                
                            ),
     
              
      child: SingleChildScrollView(
      child: Stack(
         
          children: <Widget>[

    
            
            Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width/28.8, vertical: size.width/5),
                      child: Text(
                        "What are you looking for in here? ",
                        style:
                            GoogleFonts.ubuntu(color: Colors.deepOrangeAccent,fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                      
                      ),
                      
                      

                      Padding(
                        padding:  EdgeInsets.only(left:10, top: size.width/2.7, right:size.width/17.28),
                        child: Column(
                          children: <Widget>[
                           
                           Center(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isChecked = true;
                            });
                          },
                          onDoubleTap: () {
                            setState(() {
                              _isChecked = false;
                            });
                          },
                          child: Container(
                            height: size.width/3.6,
                            width: size.width / 1.09,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                colorFilter: !_isChecked
                                    ? ColorFilter.mode(
                                        Colors.black.withOpacity(0.5),
                                        BlendMode.dstATop)
                                    : ColorFilter.mode(
                                        Colors.black.withOpacity(1),
                                        BlendMode.dstATop),
                                image:
                                    ExactAssetImage('assets/images/casual.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsets.only(left: size.width/43.2, top: size.width/5.4),
                              child: Text("Casual",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.ubuntu(
                                      color: Colors.white,
                                      fontSize: size.width / 18)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.width/43.2),

                      Center(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isChecked2 = true;
                            });
                          },
                          onDoubleTap: () {
                            setState(() {
                              _isChecked2 = false;
                            });
                          },
                          child: Container(
                            height: size.width/3.6,
                            width: size.width / 1.09,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                colorFilter: !_isChecked2
                                    ? ColorFilter.mode(
                                        Colors.black.withOpacity(0.5),
                                        BlendMode.dstATop)
                                    : ColorFilter.mode(
                                        Colors.black.withOpacity(1),
                                        BlendMode.dstATop),
                                image: ExactAssetImage(
                                    'assets/images/dating2.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsets.only(left: size.width/43.2, top: size.width/5.4),
                              child: Text("Dating",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.ubuntu(
                                      color: Colors.white,
                                      fontSize: size.width / 18)),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: size.width/43.2),

                      Center(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isChecked3 = true;
                            });
                          },
                          onDoubleTap: () {
                            setState(() {
                              _isChecked3 = false;
                            });
                          },
                          child: Container(
                            height: size.width/3.6,
                            width: size.width / 1.09,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                colorFilter: !_isChecked3
                                    ? ColorFilter.mode(
                                        Colors.black.withOpacity(0.5),
                                        BlendMode.dstATop)
                                    : ColorFilter.mode(
                                        Colors.black.withOpacity(1),
                                        BlendMode.dstATop),
                                image: ExactAssetImage(
                                    'assets/images/dating3.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsets.only(left: size.width/43.2, top: size.width/5.4),
                              child: Text("Long term",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.ubuntu(
                                      color: Colors.white,
                                      fontSize: size.width / 18)),
                            ),
                          ),
                        ),
                      ),
                           
                                
                          ],
                        ),
                      ),
            
                 
                  Positioned(

                     bottom: size.width/14.4,
             left:size.width/6.17,
                    child: isButtonPressed10 == false ? buttonUnTapped(context, Colors.deepOrange, Colors.deepOrange, () {
                        setState(() {
                          isButtonPressed10 = !isButtonPressed10;
                        });
                        
                    }) : buttonTapped(context, (){}),
                    ),

                     
             
             Padding(
               padding: EdgeInsets.only(left:size.width/1.2),
               child: ClipPath(
                         clipper: SidebarClipper(),
                        
                            child: Container(
                                
                                width: size.width * 0.2,
                                 height: MediaQuery.of(context).size.height,
                                 decoration: BoxDecoration(
       
                              gradient: LinearGradient(
                                colors: [Colors.white, Colors.white],
                                begin: Alignment.topRight, end:Alignment.bottomLeft,
                                ),
                                
                            ),
                          
                        ),
                      ),
             ),
          ],
      ),
      ),
     ),

//Preferred age


Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
       
                              gradient: LinearGradient(
                                colors: [Colors.white,Colors.red],
                                begin: Alignment.topRight, end:Alignment.bottomLeft,
                                ),
                                
                            ),
        
     
              
      child: SingleChildScrollView(
      child: Stack(
         
          children: <Widget>[

    
            
            Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width/28.8, vertical: size.width/5),
                      child: Text(
                        "Preferred age of your partner: ",
                        style:
                            GoogleFonts.ubuntu(color: Colors.deepOrange,fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                      
                      ),
                      
                      

                      Padding(
                        padding:  EdgeInsets.only(left:5, top: size.width/2.7, right:size.width/17.28),
                        child: Column(
                          children: <Widget>[
                        Center(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isChecked6 = true;
                            });
                          },
                          onDoubleTap: () {
                            setState(() {
                              _isChecked6 = false;
                            });
                          },
                          child: Container(
                            height: size.width /3.6,
                            width: size.width / 1.09,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                colorFilter: !_isChecked6
                                    ? ColorFilter.mode(
                                        Colors.black.withOpacity(0.5),
                                        BlendMode.dstATop)
                                    : ColorFilter.mode(
                                        Colors.black.withOpacity(1),
                                        BlendMode.dstATop),
                                image: ExactAssetImage(interestedIn == "Female"
                                    ? 'assets/images/18.jpg'
                                    : 'assets/images/18m.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsets.only(left: size.width / 43.2, top: size.width/5.4),
                              child: Text(
                                "18-25",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.ubuntu(
                                    color: Colors.white,
                                    fontSize: size.width * 0.05),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.width/43.2),

                      Center(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isChecked5 = true;
                            });
                          },
                          onDoubleTap: () {
                            setState(() {
                              _isChecked5 = false;
                            });
                          },
                          child: Container(
                            width: size.width / 1.09,
                            height: size.width/3.6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                colorFilter: !_isChecked5
                                    ? ColorFilter.mode(
                                        Colors.black.withOpacity(0.5),
                                        BlendMode.dstATop)
                                    : ColorFilter.mode(
                                        Colors.black.withOpacity(1),
                                        BlendMode.dstATop),
                                image: ExactAssetImage(interestedIn == "Male"
                                    ? 'assets/images/25.jpg'
                                    : 'assets/images/25m.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                                padding: EdgeInsets.only(left: size.width/43.2, top: size.width/5.4),
                                child: Text(
                                  "25+",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.ubuntu(
                                      color: Colors.white,
                                      fontSize: size.width * 0.05),
                                )),
                          ),
                        ),
                      ),

                           
                                
                          ],
                        ),
                      ),
            
                 
                  Positioned(

                     bottom: size.width/14.4,
             left:size.width/6.17,
                    child: isButtonPressed11 == false ? buttonUnTapped(context, Colors.deepOrange, Colors.deepOrange, () {
                        setState(() {
                          isButtonPressed11 = !isButtonPressed11;
                        });

                        
                    }) : buttonTapped(context, (){}),
                    ),

                     
             
             Padding(
               padding: EdgeInsets.only(left:size.width / 1.2),
               child: ClipPath(
                         clipper: SidebarClipper(),
                        
                            child: Container(
                                
                                width: size.width * 0.2,
                                 height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(
       
                              gradient: LinearGradient(
                                colors: [Colors.red,Colors.black, Colors.black],
                                begin: Alignment.topRight, end:Alignment.bottomLeft,
                                ),
                                
                            ),
                          
                        ),
                      ),
             ),
          ],
      ),
      ),
     ),



     Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
       
                              gradient: LinearGradient(
                                colors: [Colors.white,Colors.blue],
                                begin: Alignment.topRight, end:Alignment.bottomLeft,
                                ),
                                
                            ),
        
     
              
      child: SingleChildScrollView(
      child: Stack(
         
          children: <Widget>[

    
            
            Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width/28.8, vertical: size.width/5),
                      child: Text(
                        "We need your permissions: ",
                        style:
                            GoogleFonts.ubuntu(color: Colors.deepOrange,fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                      
                      ),
                      
                      

                      Padding(
                        padding:  EdgeInsets.only(left:size.width/24, top: size.width/2.7, right:size.width/17.28),
                        child: Column(
                          children: <Widget>[
                            
                            RichText(
                              text: TextSpan(
                                text: "To connect you with other users, ",
                                style: GoogleFonts.ubuntu(color:Colors.deepOrange, fontSize: 20),

                                children: <TextSpan> [
                                  TextSpan(text: "we need your location.", style: GoogleFonts.ubuntu(color:Colors.blue, fontSize: 20)),
                                  TextSpan(text: "*", style: GoogleFonts.ubuntu(color: Colors.black))
                                ]
                              ),
                            ),

                             Switch(
                               activeColor: Colors.deepOrange,
                      value: locationshare,
                      onChanged: (val) {
                        setState(() {
                          locationshare = val;
                        });
                        
                        
                        
                      },

                      ),

                             SizedBox(height:size.height*0.08),

                          RichText(
                              text: TextSpan(
                                text: "Do you to share live location? ",
                                style: GoogleFonts.ubuntu(color:Colors.deepOrange, fontSize: 20),

                                children: <TextSpan> [
                                  TextSpan(text: "Don't worry, you can change it later", style: GoogleFonts.ubuntu(color:Colors.black, fontSize: 20)),

                                ]
                              ),
                            ),  

                             Center(
                               child: Switch(
                                 activeColor: Colors.deepOrange,
                      value: live,
                      onChanged: (val) {
                        setState(() {
                          live = val;
                        });
                        
                        
                        
                        
                      },

                      ),
                             ),                         


                           
                                
                          ],
                        ),
                      ),
            
                 
                  Positioned(

                     bottom: size.width/14.4,
             left:size.width/6.17,
                    child: locationshare == false ? buttonUnTapped(context, Colors.transparent,Colors.transparent, () {}):isButtonPressed12 == false ? buttonUnTappedWithText(context, Colors.deepOrange, Colors.deepOrange, () {
                        setState(() {
                          isButtonPressed11 = !isButtonPressed11;
                        });

                        Navigator.push(context, MaterialPageRoute(builder: (context) => bioPage()));
                        
                    }, "Lets get Started") : buttonTapped(context, (){}),
                    ),

                     
             
             Padding(
               padding: EdgeInsets.only(left:size.width / 1.2),
               child: ClipPath(
                         clipper: SidebarClipper(),
                        
                            child: Container(
                                
                                width: size.width * 0.2,
                                 height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(
       
                              gradient: LinearGradient(
                                colors: [Colors.red,Colors.black, Colors.black],
                                begin: Alignment.topRight, end:Alignment.bottomLeft,
                                ),
                                
                            ),
                          
                        ),
                      ),
             ),
          ],
      ),
      ),
     ),



            
            ],
          );

         
        },
      ),
    );
  }

  @override
  void dispose() {
    // _nameController.dispose();

    super.dispose();
  }

  Widget textFieldWidget(controller, text, size) {
    return Padding(
      padding: EdgeInsets.all(size.height * 0.02),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: text,
          labelStyle:
              TextStyle(color: Colors.white, fontSize: size.height * 0.03),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
          ),
        ),
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final carouselIndex, indicatorIndex;

  Indicator({this.carouselIndex, this.indicatorIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      width: 8,
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: carouselIndex == indicatorIndex ? Colors.white : Colors.grey,
      ),
    );
  }
}

class SidebarClipper extends CustomClipper<Path> {
  SidebarClipper();

  @override
  Path getClip(Size size) {
    var width = size.width;
    var height = size.height;
    var path = new Path();

    path.moveTo(width, 0);
    path.lineTo(width - 15, 0);
    path.lineTo(width - 15, (height / 2 + 120) - 10);

    var firstcontrolPoint = new Offset(width - 15, (height / 2 + 120));
    var firstendPoint = new Offset(width / 2, (height / 2 + 120) + 15);
    path.quadraticBezierTo(firstcontrolPoint.dx, firstcontrolPoint.dy,
        firstendPoint.dx, firstendPoint.dy);

    var secondcontrolPoint = new Offset(0, (height / 2 + 120) + 40);
    var secondendPoint = new Offset(width / 2, (height / 2 + 120) + 70);
    path.quadraticBezierTo(secondcontrolPoint.dx, secondcontrolPoint.dy,
        secondendPoint.dx, secondendPoint.dy);

    var thirdcontrolPoint = new Offset(width - 15, (height / 2 + 120) + 80);
    var thirdendPoint = new Offset(width - 15, (height / 2 + 120) + 100);
    path.quadraticBezierTo(thirdcontrolPoint.dx, thirdcontrolPoint.dy,
        thirdendPoint.dx, thirdendPoint.dy);

    path.lineTo(width - 15, height);
    path.lineTo(width, height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

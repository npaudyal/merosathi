import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:merosathi/bloc/authentication/authentication_bloc.dart';
import 'package:merosathi/bloc/authentication/authentication_event.dart';
import 'package:merosathi/bloc/profile/bloc.dart';
import 'package:merosathi/models/user.dart';
import 'package:merosathi/repositories/userRepository.dart';
import 'package:merosathi/ui/constants.dart';
import 'package:merosathi/ui/widgets/gender.dart';
import 'package:image/image.dart' as Im;
import 'package:merosathi/ui/widgets/image_tiles.dart';
import 'package:merosathi/ui/widgets/onboarding.dart';



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

   


  String name, country, heightP,gender,community, interestedIn;

  DateTime age;
  File photo,photo2, photo3, photo4, photo5, photo6,photo7;
  GeoPoint location;
  ProfileBloc _profileBloc;
  bool get isFilled => _nameController.text.isNotEmpty &&
                gender!=null &&
                interestedIn !=null &&
                photo !=null &&
                age!=null;

  bool isButtonEnabled(ProfileState state) {
    return isFilled && !state.isSubmitting;
  }

  bool _isChecked = false;
  bool _isChecked2 = false;
  bool _isChecked3= false;
    bool _isChecked5= false;
      bool _isChecked6= false;


 FirebaseAuth _auth;


  compressImage() async {
  final tempDir = await getTemporaryDirectory();
  final path = tempDir.path;
  Im.Image imageFile = Im.decodeImage(photo.readAsBytesSync());
  final compressedImageFile = File('$path/img_${_userRepository.getUser()}.jpg')..writeAsBytesSync(Im.encodeJpg(imageFile, quality:85));
  setState(() {
    photo = compressedImageFile;
  });
}

  _getlocation () async {
    Position position = await 
    Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
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
      photo: photo

    ));
  }
  


  UserRepository get _userRepository =>widget._userRepository;

  int selected_radio_gen;
  int selected_radio_tile_gen;

   int selected_radio_int;
  int selected_radio_tile_int;

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
    selected_radio_tile_gen =0;
     selected_radio_int = 0;
    selected_radio_tile_int=0;
    
    _getlocation();
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    super.initState();
  }
  



var color1 = Colors.pink[200];
var color2 = Color(0xfff0195e);
var color3 = Color(0xffff8903);
var color4 = Colors.limeAccent;
var color5 = Colors.lightBlueAccent;
var color6 = Colors.deepPurpleAccent;
var color7 = Colors.brown[200];

bool isPressed =false;
bool isPressed2 =false;
bool isPressed3 =false;
bool isPressed4 =false;
bool isPressed5 =false;
bool isPressed6 =false;
bool isPressed7 =false;
bool isPressed8 =false;
bool isPressed9 =false;



List<String> image = ['img1.png', 'img2.png', 'img3.png'];

List<String> title = [
  'What do your friends call you?',
  'Gender Page',
  'Profile Photo',
  '',
  '',
  ''
];


uploadImage(File photo, String name) async {

  String uid = (await FirebaseAuth.instance.currentUser()).uid;

  final StorageReference storageReference =  FirebaseStorage.instance.ref().child("userPhotos").child(uid).child(name);
  final StorageUploadTask task =  storageReference.putFile(photo);


}

List<String> heights = ["<4.5", "4.5","4.6", "4.7", "4.8", "4.9","5.0", "5.1","5.2", "5.3", "5.4", "5.5", "5.6", "5.7", "5.8", "5.9", "6.0", "6.1", "6.2", "6.3", "6.4", "6.5", ">6.5"];
List<String> countries = ["Nepal", "USA", "UK","Australia", "Other", "India", "Bangladesh", "Bhutan"];
final heightselected = TextEditingController();
final countrySelected = TextEditingController(); //For dropdown

final communitySelected = TextEditingController();

final _countryController = TextEditingController();

final _communityController = TextEditingController();
final _heightController = TextEditingController();

String selectheight="";
String selectCountry="";

String selectCommunity = "";
List<String> text = [
  '',
  '',
  '',
  '',
  '',
  ''
];







CarouselSlider carouselSlider;
  int carouselIndex = 0;

/*
final pages = [
   Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 20),
      color: color1,
      child: Container(
        decoration: BoxDecoration(
          color: color2,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(180),
          ),
        ),
        child: SingleChildScrollView(
                  child: Column(
            children: <Widget>[
              
              
              // Image.asset(
              //   imgUrl,
              //   height: 300,
              // ),
              SizedBox(height:120,),
              
              Text(
                "What do your friends call you?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              
              
              SizedBox(
                height: 40,
              ),
              Container(
                  width:MediaQuery.of(context).size.width/1.2,
                  child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Your name..",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    
                  ),
                ),
                
                
              ),
              SizedBox(height:60),
              Text(
                "When's your birthday?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 30),
             
              RaisedButton(
                
                onPressed:  () {
                        DatePicker.showDatePicker(context, showTitleActions: true, 
                        minTime:DateTime(1900,1,1),
                        maxTime: DateTime(DateTime.now().year -19, 1,1 ),
                        onConfirm: (date) {
                          setState(() {
                            age =date;
                          });
                        },
                        );
                      },
                color: Colors.white60,
                shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.black),
                
                
                
                ),
                child: Text( age == null ? "Choose a date" : "{$age}"),
              ),
            
          SizedBox(height:100),  
          
           Center(
                      child: Container(
          width: MediaQuery.of(context).size.width/1.6,
              
          height: 50,
          margin: EdgeInsets.only(top:50),
               child:RaisedButton(
                 onPressed: () {
                   setState(() {
                    name=_nameController.text; 
                   });
                   carouselSlider.nextPage(
                      duration: Duration(milliseconds: 500), curve: Curves.ease);
                 },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(80),
          ),
             child: Ink(
               width: MediaQuery.of(context).size.width/1.01,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  (Color(0xff374ABE)), (Color(0xff64B6FF))
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight
                ),
                borderRadius: BorderRadius.circular(30),
               
              ),
               padding: EdgeInsets.all(0.0),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 300,
                  minHeight: 100
                ),
                child: Center(
                                child: Text(
                    
                    "Continue",
                    textAlign: TextAlign.center,               
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
              ),
          ),
               ),
          ),
           ),
             
                
              
            ],
          ),
        ),
      ),
    ),
    Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 20),
      color: color3,
      child: Container(
        decoration: BoxDecoration(
          color: color1,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(180),
          ),
        ),
        child: Column(
          children: <Widget>[
            
            
            // Image.asset(
            //   imgUrl,
            //   height: 300,
            // ),
            SizedBox(height:80,),
            
            Text(
              "You are:",
              textAlign: TextAlign.center,
              style: TextStyle(
                
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            
            
            SizedBox(
              height: 10,
            ),
           RadioListTile(
            title: Text("Male", style:TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            )),
            value: 1,
            groupValue: selected_radio_tile_gen,
             onChanged: (val) {
               setSelectedRadioTileGen(val);
               setState(() {
                 gender = "Male";
               });
             },
            ),
             RadioListTile(
            title: Text("Female",style:TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            )),
            value: 2,
            groupValue: selected_radio_tile_gen,
             onChanged: (val) {
               setSelectedRadioTileGen(val);
               setState(() {
                 gender = "Female";
               });
             },
             
             ),
             RadioListTile(
            title: Text("Other",style:TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            )),
            value: 3,
            groupValue: selected_radio_tile_gen,
             onChanged: (val) {
               setSelectedRadioTileGen(val);
               setState(() {
                 gender = "Transexual";
               });
             },
             ),
             SizedBox(height: 30),
              Text(
              "Interested in: ",
              textAlign: TextAlign.center,
              style: TextStyle(
                
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            SizedBox(height: 10),
             RadioListTile(
            title: Text("Male", style:TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            )),
            value: 4,
            groupValue: selected_radio_tile_int,
             onChanged: (val) {
               setSelectedRadioTileInt(val);
               setState(() {
                 interestedIn = "Male";
               });
             },
            ),
             RadioListTile(
            title: Text("Female",style:TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            )),
            value: 5,
            groupValue: selected_radio_tile_int,
             onChanged: (val) {
               setSelectedRadioTileInt(val);
               setState(() {
                 interestedIn = "Female";
               });
             },
             
             ),
             RadioListTile(
            title: Text("Other",style:TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            )),
            value: 6,
            groupValue: selected_radio_tile_int,
             onChanged: (val) {
               setSelectedRadioTileInt(val);
               setState(() {
                 interestedIn = "Transexual";
               });
             },
             ),
             
        SizedBox(height:100),  
        
         Center(
           
                    child: Container(
        width: MediaQuery.of(context).size.width/1.6,
            
        height: 50,
        margin: EdgeInsets.only(top:50),
             child:RaisedButton(
               onPressed: () {
                 setState(() {
                  gender = gender;
                  interestedIn = interestedIn; 
                  
                 }
                
                 );
                 carouselSlider.nextPage(
                    duration: Duration(milliseconds: 500), curve: Curves.ease);
               },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80),
        ),
           child: Ink(
             
             width: MediaQuery.of(context).size.width/1.01,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                (Color(0xff374ABE)), (Color(0xff64B6FF))
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight
              ),
              borderRadius: BorderRadius.circular(30),
             
            ),
             padding: EdgeInsets.all(0.0),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 300,
                minHeight: 100
              ),
              child: Center(
                              child: Text(
                  
                  "Continue",
                  textAlign: TextAlign.center,               
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              ),
            ),
        ),
             ),
        ),
         ),
          Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 20),
      color: color4,
      child: Container(
        decoration: BoxDecoration(
          color: color3,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(180),
          ),
        ),
        child: Column(
          children: <Widget>[
            
            
            // Image.asset(
            //   imgUrl,
            //   height: 300,
            // ),
            SizedBox(height:120,),
            
            Text(
              "Attach a best picture of you!",
              textAlign: TextAlign.center,
              style: TextStyle(
                
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            
            
            SizedBox(
              height: 40,
            ),
           // Upload photo code
           Container(
                    width: size.width/2,
                    child: CircleAvatar(radius:size.width * 0.3,
                    backgroundColor: Colors.transparent,
                    child: photo == null ? GestureDetector(
                        onTap: () async {
                          File getPic = await FilePicker.getFile(type: FileType.image);
                          if(getPic !=null) {
                            photo = getPic;
                          }
                        },
                        child: Image.asset('assets/profilePhoto.png'),
                    ) :  GestureDetector(
                      onTap:() async {
                          File getPic = await FilePicker.getFile(type: FileType.image);
                          if(getPic !=null) {
                            await compressImage();
                            photo = getPic;
                          }
                        }, 
                        child: CircleAvatar(
                          radius: size.width * 0.3,
                          backgroundImage: FileImage(photo),
                        ),
                    )
                    ),
                    
                  ),
                
               
                Center(
                  child: Text("Having a profile Picture increases the chance of getting a match",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    
                  ),
                  textAlign: TextAlign.center,
                  ),
                ),
        SizedBox(height:180),  
        
         Center(
                    child: Container(
        width: MediaQuery.of(context).size.width/1.6,
            
        height: 50,
        margin: EdgeInsets.only(top:50),
             child:RaisedButton(
               onPressed: () {
                 setState(() {
                  photo = photo; 
                 });
                 carouselSlider.nextPage(
                    duration: Duration(milliseconds: 500), curve: Curves.ease);
               },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80),
        ),
           child: Ink(
             width: MediaQuery.of(context).size.width/1.01,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                (Color(0xff374ABE)), (Color(0xff64B6FF))
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight
              ),
              borderRadius: BorderRadius.circular(30),
             
            ),
             padding: EdgeInsets.all(0.0),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 300,
                minHeight: 100
              ),
              child: Center(
                              child: Text(
                  
                  "Continue",
                  textAlign: TextAlign.center,               
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              ),
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
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 20),
      color: color6,
      child: Container(
        decoration: BoxDecoration(
          color: color5,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(180),
          ),
        ),
        child: SingleChildScrollView(
                  child: Column(
            children: <Widget>[
              
              
              // Image.asset(
              //   imgUrl,
              //   height: 300,
              // ),
              SizedBox(height:120,),
              
              Text(
                "Select your community: ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              
              
              SizedBox(
                height: 20,
              ),
             Container(
               width: MediaQuery.of(context).size.width/1.2,
                 child: DropDownField(
                 controller: communitySelected,
                 
                 hintText: "Select your community",
                 textStyle: TextStyle(color:Colors.white),
                 enabled: true,
                 
                 itemsVisibleInDropdown: 5,
                 
                 items:communities,
                 onValueChanged: (val) {
                  setState(() {
                    selectCommunity = val;
                  });
                 },
               ),
             ),
             SizedBox(height:50),
               selectCommunity == "Other" ? 
               
               Container(
                  width: MediaQuery.of(context).size.width/1.2,
                  child: TextFormField(
                  controller: _communityController,
                  decoration: InputDecoration(
                    hintText: "Other",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      
                    ),
                    
                  ),
              ),
               ) : Text(""),
              
             
          SizedBox(height:100),  
          
           Center(
                      child: SingleChildScrollView(
                                            child: Container(
          width: MediaQuery.of(context).size.width/1.6,
              
          height: 50,
          margin: EdgeInsets.only(top:50),
               child:RaisedButton(
                 onPressed: () {
                  selectCommunity == "Other" ? setState(() {
                    
                    community = _communityController.text; 
                   }): setState(() {
                     community = selectCommunity;
                   });
                   print(community);
                   carouselSlider.nextPage(
                        duration: Duration(milliseconds: 500), curve: Curves.ease);
                 },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(80),
          ),
             child: Ink(
               width: MediaQuery.of(context).size.width/1.01,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  (Color(0xff374ABE)), (Color(0xff64B6FF))
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight
                ),
                borderRadius: BorderRadius.circular(30),
               
              ),
               padding: EdgeInsets.all(0.0),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 300,
                  minHeight: 100
                ),
                child: Center(
                                  child: Text(
                    
                    "Continue",
                    textAlign: TextAlign.center,               
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
          ),
               ),
          ),
                      ),
           ),
             
                
              
            ],
          ),
        ),
      ),
    ),
    
 Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 20),
      color: color3,
      child: Container(
        decoration: BoxDecoration(
          color: color6,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(180),
          ),
        ),
        child: SingleChildScrollView(
                  child: Column(
            children: <Widget>[
              
              
              // Image.asset(
              //   imgUrl,
              //   height: 300,
              // ),
              SizedBox(height:120,),
              
              Text(
                "How tall are you? ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              
              
              SizedBox(
                height: 20,
              ),
             Container(
               width: MediaQuery.of(context).size.width/1.2,
                 child: DropDownField(
                 controller: heightselected,
                 hintText: "Select your height",
                 textStyle: TextStyle(color:Colors.white),
                 enabled: true,
                 
                 itemsVisibleInDropdown: 8,
                 
                 items:heights,
                 onValueChanged: (val) {
                  setState(() {
                    selectheight = val;
                  });
                 },
               ),
             ),
             SizedBox(height:200),
               Center(
                      child: SingleChildScrollView(
                                            child: Container(
          width: MediaQuery.of(context).size.width/1.6,
              
          height: 50,
          margin: EdgeInsets.only(top:50),
               child:RaisedButton(
                 onPressed: () {
                  setState(() {
                     heightP = selectheight;
                   });
                  
                   carouselSlider.nextPage(
                        duration: Duration(milliseconds: 500), curve: Curves.ease);
                 },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(80),
          ),
             child: Ink(
               width: MediaQuery.of(context).size.width/1.01,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  (Color(0xff374ABE)), (Color(0xff64B6FF))
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight
                ),
                borderRadius: BorderRadius.circular(30),
               
              ),
               padding: EdgeInsets.all(0.0),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 300,
                  minHeight: 100
                ),
                child: Center(
                                  child: Text(
                    
                    "Continue",
                    textAlign: TextAlign.center,               
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
          ),
               ),
          ),
                      ),
           ),
      ],
                  ),
        ),
      ),
  ),
Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 20),
      color: color2,
      child: Container(
        decoration: BoxDecoration(
          color: color3,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(180),
          ),
        ),
        child: SingleChildScrollView(
                  child: Column(
            children: <Widget>[
              
              
              // Image.asset(
              //   imgUrl,
              //   height: 300,
              // ),
              SizedBox(height:120,),
              
              Text(
                "Where were you raised? ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              
              
              SizedBox(
                height: 20,
              ),
             Container(
               width: MediaQuery.of(context).size.width/1.2,
                 child: DropDownField(
                 controller: countrySelected,
                 hintText: "Select the country",
                 textStyle: TextStyle(color:Colors.white),
                 enabled: true,
                 
                 itemsVisibleInDropdown: 5,
                 
                 items:countries,
                 onValueChanged: (val) {
                  setState(() {
                    selectCountry = val;
                  });
                 },
               ),
             ),
             SizedBox(height:50),
               selectCountry == "Other" ? 
               
               Container(
                  width: MediaQuery.of(context).size.width/1.2,
                  child: TextFormField(
                  controller: _countryController,
                  decoration: InputDecoration(
                    hintText: "Other",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      
                    ),
                    
                  ),
              ),
               ) : Text(""),
              
             
          SizedBox(height:100),  
          
           Center(
                      child: SingleChildScrollView(
                                            child: Container(
          width: MediaQuery.of(context).size.width/1.6,
              
          height: 50,
          margin: EdgeInsets.only(top:50),
               child:RaisedButton(
                 onPressed: () {
                  selectCountry == "Other" ? setState(() {
                    
                    country = _countryController.text; 
                   }): setState(() {
                     country = selectCountry;
                   });
                   print(country);
                   carouselSlider.nextPage(
                        duration: Duration(milliseconds: 500), curve: Curves.ease);
                 },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(80),
          ),
             child: Ink(
               width: MediaQuery.of(context).size.width/1.01,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  (Color(0xff374ABE)), (Color(0xff64B6FF))
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight
                ),
                borderRadius: BorderRadius.circular(30),
               
              ),
               padding: EdgeInsets.all(0.0),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 300,
                  minHeight: 100
                ),
                child: Center(
                                  child: Text(
                    
                    "Continue",
                    textAlign: TextAlign.center,               
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
          ),
               ),
          ),
                      ),
           ),
            ],
                  ),
        ),
      ),
   ),
   
Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 20),
      color: color1,
      child: Container(
        decoration: BoxDecoration(
          color: color2,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(180),
          ),
        ),
        child: Column(
          children: <Widget>[
            
            
            // Image.asset(
            //   imgUrl,
            //   height: 300,
            // ),
            SizedBox(height:120,),
            
            Text(
              "What are you looking for in here?",
              textAlign: TextAlign.center,
              style: TextStyle(
                
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            
            
            SizedBox(
              height: 40,
            ),
            //CheckBox with image
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
            height: 120.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), 
              image: DecorationImage(
                colorFilter: !_isChecked ? ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop) : ColorFilter.mode(Colors.black.withOpacity(1), BlendMode.dstATop) ,
                image: ExactAssetImage('assets/images/casual.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
           child: Text("Casual",
           textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white)),
            ),
            
           
            ),
          ),
        ),
                SizedBox(height:10),
      
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
            height: 120.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), 
              image: DecorationImage(
                colorFilter: !_isChecked2 ? ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop) : ColorFilter.mode(Colors.black.withOpacity(1), BlendMode.dstATop) ,
                image: ExactAssetImage('assets/images/dating2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
           child: Text("Dating",
           textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white)),
            ),
            
           
            ),
          ),
        ),
        SizedBox(height:10),
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
            height: 120.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), 
              image: DecorationImage(
                colorFilter: !_isChecked3 ? ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop) : ColorFilter.mode(Colors.black.withOpacity(1), BlendMode.dstATop) ,
                image: ExactAssetImage('assets/images/dating3.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
           child: Text("Long term",
           textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white)),
            ),
            
           
            ),
          ),
        ),
      
           
              
            
        SizedBox(height:20),
        
         Center(
                    child: Container(
        width: MediaQuery.of(context).size.width/1.6,
            
        height: 50,
        margin: EdgeInsets.only(top:50),
             child:RaisedButton(
               onPressed: () {
                 setState(() {
                  
                 });
                 carouselSlider.nextPage(
                    duration: Duration(milliseconds: 500), curve: Curves.ease);
               },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80),
        ),
           child: Ink(
             width: MediaQuery.of(context).size.width/1.01,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                (Color(0xff374ABE)), (Color(0xff64B6FF))
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight
              ),
              borderRadius: BorderRadius.circular(30),
             
            ),
             padding: EdgeInsets.all(0.0),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 300,
                minHeight: 100
              ),
              child: Center(
                              child: Text(
                  
                  "Continue",
                  textAlign: TextAlign.center,               
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              ),
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
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 20),
      color: color3,
      child: Container(
        decoration: BoxDecoration(
          color: color1,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(180),
          ),
        ),
        child: Column(
          children: <Widget>[
            
            
            // Image.asset(
            //   imgUrl,
            //   height: 300,
            // ),
            SizedBox(height:120,),
            
            Text(
              "Preferred age of your partner: ",
              textAlign: TextAlign.center,
              style: TextStyle(
                
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            
            
            SizedBox(
              height: 40,
            ),
            //CheckBox with image
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
            height: 120.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), 
              image: DecorationImage(
                colorFilter: !_isChecked6 ? ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop) : ColorFilter.mode(Colors.black.withOpacity(1), BlendMode.dstATop) ,
                image: ExactAssetImage( interestedIn =="Female" ? 'assets/images/18.jpg':'assets/images/18m.jpg' ),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
           child: Text("18-25",
           textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white)),
            ),
            
           
            ),
          ),
        ),
                SizedBox(height:10),
      
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
            height: 120.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), 
              image: DecorationImage(
                colorFilter: !_isChecked5 ? ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop) : ColorFilter.mode(Colors.black.withOpacity(1), BlendMode.dstATop) ,
                image: ExactAssetImage( interestedIn == "Male" ? 'assets/images/25.jpg': 'assets/images/25m.jpg' ),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
           child: Text("25+",
           textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white)),
            ),
            
           
            ),
          ),
        ),
        SizedBox(height:10),
           
              
            
        SizedBox(height:20),
        
         Center(
            child: Container(
        width: MediaQuery.of(context).size.width/1.6,
            
        height: 50,
        margin: EdgeInsets.only(top:50),
             child:RaisedButton(
               onPressed: () {
                  _onSubmitted();
                 carouselSlider.nextPage(
                    duration: Duration(milliseconds: 500), curve: Curves.ease);
               },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80),
        ),
           child: Ink(
             width: MediaQuery.of(context).size.width/1.01,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                (Color(0xff374ABE)), (Color(0xff64B6FF))
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight
              ),
              borderRadius: BorderRadius.circular(30),
             
            ),
             padding: EdgeInsets.all(0.0),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 300,
                minHeight: 100
              ),
              child: Center(
                              child: Text(
                  
                  "Lets get started!",
                  textAlign: TextAlign.center,               
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              ),
            ),
        ),
             ),
        ),
         ),
           
              
            
          ],
        ),
      ),
    ),
      
];
*/

   

 


  @override
  Widget build(BuildContext context) {

    
    

    Size size = MediaQuery.of(context).size;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if(state.isFailure) {
          Scaffold.of(context)..hideCurrentSnackBar()
         ..showSnackBar(SnackBar(
              content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Profile Creation Unsuccessful"),

                Icon(Icons.error),
              ],
            )));
        }
        if(state.isSubmitting) {
          Scaffold.of(context)..hideCurrentSnackBar()
         ..showSnackBar(SnackBar(
              content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Submitting"),
                
                CircularProgressIndicator(),
              ],
            )));
        }
        if(state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      
      },

      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
        var communities = ["Brahmin", "Chettri", "Other", "Magar", "Tharu","Tamang", "Newar", "Kami", "Nepali Muslims", "Yadav", "Rai", "Gurung", "Sherpa", "Thakuri", "Limbu", "Sarki", "Teli", "Harijan/Chamar/Ram", "Koiri/Kushwaha", "Musahar", "Kurmi", "Sanyashi/Dasnami","Dhanuk", "Dusadh/Pasawan/Pasi", "Raute", "Nurang", "Kusunda", "Hyolmo/Yolmo"];

        return LiquidSwipe(
        enableSlideIcon: true,
        enableLoop: false,
        positionSlideIcon: 0.14,
        waveType: WaveType.liquidReveal,
     
      
        pages: <Container>[
         Container(
       
        
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 20),
      color: Colors.blue,
      
       // clipper: MyClipper(),
                  child: ClipPath(
                   // clipper: MyClipper(),
                  child: Container(
                    
              
              
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                
              
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(180),

                    
                ),
              ),
              child: SingleChildScrollView(
                          child: Column(
                    children: <Widget>[

                      SizedBox(height: 80),

                      Center(
                          child:Icon(
                            FontAwesomeIcons.user,
                            color: Colors.blue,
                            
                          ),
                      ),
                      
                      
                      // Image.asset(
                      //   imgUrl,
                      //   height: 300,
                      // ),
                      SizedBox(height:30,),
                      
                      Text(
                        "What do your friends call you?",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),


                      
                      
                      SizedBox(
                        height: 40,
                      ),

                      Container(
                          width:MediaQuery.of(context).size.width/1.2,
                          child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: "Your name..",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,

                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),

                            ),
                            
                          ),
                        ),
                        
                        
                      ),

                      SizedBox(height:80),

                      
                      
                      Center(
                        child: Icon(
                        
                            FontAwesomeIcons.birthdayCake,
                            color: Colors.blue,
                            size: MediaQuery.of(context).size.height*0.05,
                        ),
                      ),

                        SizedBox(height:40),

                      Text(
                        "When's your birthday?",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),

                    

                      SizedBox(height: 30),

                     

                      Container(
                        width: MediaQuery.of(context).size.width/1.5,
                         child: RaisedButton(
                          
                          
                          onPressed:  () {
                                  DatePicker.showDatePicker(context, showTitleActions: true, 
                                  minTime:DateTime(1900,1,1),
                                  maxTime: DateTime(DateTime.now().year -19, 1,1 ),
                                  onConfirm: (date) {
                                    setState(() {
                                      age =date;
                                    });
                                  },
                                  );
                                },
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.black),
                          

                          
                          
                          ),

                          child: Text( age == null ? "Choose a date" : "{$age}", style: GoogleFonts.roboto(fontSize:14)),
                        ),
                      ),
                    


                SizedBox(height:100),  
                
                 Center(
                              child: Container(

                width: MediaQuery.of(context).size.width/1.6,
                      
                height: 50,
                margin: EdgeInsets.only(top:50),
                       child:RaisedButton(
                         onPressed: () {
                           setState(() {
                            name = _nameController.text; 
                           });
                           isPressed =!isPressed;
                          
                         },
                shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80),


                ),
                     child: Ink(
                       width: MediaQuery.of(context).size.width/1.01,
                      decoration: BoxDecoration(
                         
                        gradient: LinearGradient(colors: [
                          (Color(0xff374ABE)), (Color(0xff64B6FF))
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight
                        ),

                        borderRadius: BorderRadius.circular(30),
                       

                      ),
                       padding: EdgeInsets.all(0.0),
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: 300,
                          minHeight: 100
                        ),
                        child: Center(
                          
                          child: Text(
                            
                            !isPressed ? "Save" : "Got it!",
                            
                            textAlign: TextAlign.center,               
                            style: TextStyle(
                              color:  Colors.white
                            ),
                          ),
                        ),
                      ),
                ),
                       ),
                ),
                 ),
                     
                        
                      
                    ],
                ),
              ),
        ),
                  ),
      
    ),
           
         
       

          //Gender Page
        
        Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 20),
      color: color3,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(180),
          ),
        ),
        child: Column(
          children: <Widget>[

            SizedBox(height:40),

            Center(
              child: Icon(
                FontAwesomeIcons.user,
                color: Colors.black,
              ),
            ),
            
            
            // Image.asset(
            //   imgUrl,
            //   height: 300,
            // ),
            SizedBox(height:40,),
            
            Text(
              "I am a: ",
              textAlign: TextAlign.left,
              style: GoogleFonts.roboto(
                
                color: color3,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            
            
            SizedBox(
              height: 30,
            ),

           RadioListTile(
            title: Text("Male", style:GoogleFonts.roboto(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height*0.026
            )),
            value: 1,
            groupValue: selected_radio_tile_gen,
             onChanged: (val) {
               setSelectedRadioTileGen(val);
               setState(() {
                 gender = "Male";
               });
               
             },
             activeColor: color3,
            ),
             RadioListTile(
            title: Text("Female",style:GoogleFonts.roboto(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height*0.026
            )),
            value: 2,
            groupValue: selected_radio_tile_gen,
             onChanged: (val) {
               setSelectedRadioTileGen(val);
               setState(() {
                 gender = "Female";
               });
             },
             activeColor: color3,

             ),
             RadioListTile(
            title: Text("Other",style:GoogleFonts.roboto(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height*0.026
            )),
            value: 3,
            groupValue: selected_radio_tile_gen,
             onChanged: (val) {
               setSelectedRadioTileGen(val);
               setState(() {
                 gender = "Transexual";
               });
             },
             activeColor: color3,

             ),
             SizedBox(height: 30),


              Text(
              "Interested in: ",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                
                color: color3,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),

            SizedBox(height: 30),
             RadioListTile(
            title: Text("Male",style:GoogleFonts.roboto(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height*0.026
            )),
            value: 4,
            groupValue: selected_radio_tile_int,
             onChanged: (val) {
               setSelectedRadioTileInt(val);
               setState(() {
                 interestedIn = "Male";
               });
             },
             activeColor: color3,

            ),
             RadioListTile(
            title: Text("Female",style:GoogleFonts.roboto(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height*0.026
            )),
            value: 5,
            groupValue: selected_radio_tile_int,
             onChanged: (val) {
               setSelectedRadioTileInt(val);
               setState(() {
                 interestedIn = "Female";
               });


             },
             activeColor: color3,
             
             ),
             RadioListTile(
            title: Text("Other",style:GoogleFonts.roboto(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height*0.026
            )),
            value: 6,
            groupValue: selected_radio_tile_int,
             onChanged: (val) {
               setSelectedRadioTileInt(val);
               setState(() {
                 interestedIn = "Transexual";
               });
             },

             activeColor: color3,
             ),


             

        SizedBox(height:50),  
        
         Center(
           
                    child: Container(

        width: MediaQuery.of(context).size.width/1.6,
            
        height: 50,
        margin: EdgeInsets.only(top:50),
             child:RaisedButton(
               onPressed: () {
                 setState(() {
                  gender = gender;
                  interestedIn = interestedIn; 
                  
                 }
                
                 );

                 isPressed2 = !isPressed2;
                
               },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80),


        ),
           child: Ink(
             
             width: MediaQuery.of(context).size.width/1.01,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                (Color(0xff374ABE)), (Color(0xff64B6FF))
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight
              ),

              borderRadius: BorderRadius.circular(30),
             

            ),
             padding: EdgeInsets.all(0.0),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 300,
                minHeight: 100
              ),
              child: Center(
                              child: Text(
                  
                  !isPressed2 ? "Save" : "Got it",
                  textAlign: TextAlign.center,               
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              ),
            ),
        ),
             ),
        ),
         ),
           
              
            
          ],
        ),
      ),
    ),

      //Photo Page


        Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 20),
      color: Colors.purple,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(180),
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height:50,),
            Center(
              child: Icon(
                FontAwesomeIcons.solidImage,
                color: Colors.deepOrange,
              ),
            ),
            
                        SizedBox(height:20,),

            // Image.asset(
            //   imgUrl,
            //   height: 300,
            // ),
            
            
            Text(
              "Attach a profile Picture",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            
            
            SizedBox(
              height: 40,
            ),

           // Upload photo code
          //  Container(
          //    height: size.height/3.5,
          //   width: size.width/1.2,
          //  child: CircleAvatar(radius:size.width * 0.3,
          //   backgroundColor: Colors.transparent,
          //   child: photo == null ? GestureDetector(
          //       onTap: () async {
          //         File getPic = await FilePicker.getFile(type: FileType.image);
          //         if(getPic !=null) {
          //            photo = getPic;
          //          }
          //       },

          //               child: Image.asset('assets/profilePhoto.png'),
          //           ) :  GestureDetector(
          //             onTap:() async {
          //                 File getPic = await FilePicker.getFile(type: FileType.image);
          //                 if(getPic !=null) {
          //                   await compressImage();
          //                   photo = getPic;
          //                 }
          //               }, 

          //               child: CircleAvatar(
          //                 radius: size.width * 0.3,
          //                 backgroundImage: FileImage(photo),

          //               ),
          //           )

          //           ),
                    

          //         ),
                
            SingleChildScrollView(
                          child: Row(

              
                 
                    
                     

                      
                      
                      children: <Widget>[
                          Padding(
                        padding: EdgeInsets.only(left:size.height*0.02),
                      ),
                        

                         GestureDetector(
                             onTap: () async {
                 File getPic = await FilePicker.getFile(type: FileType.image);
                if(getPic !=null) {
                  // await compressImage();
                   photo = getPic;
                 }

               }, 

                      
                            child: Container(
                              
                            
                            alignment: Alignment.centerLeft,
                          width: size.width/2.3,
                          height: size.height/3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          
                            
                           border: Border.all(color:Colors.purple, width:7),
                            image: DecorationImage(
                             
                              
                              image: photo == null ? AssetImage('assets/images/addImage.jpg') : FileImage(photo),
                              fit: BoxFit.cover
                              
                              
                              
                              )
                          ),
                          
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                colors: [Colors.grey[200].withOpacity(.9), Colors.grey.withOpacity(0)]
                                )
                            ),
                          ),
                ),
                        
                         ),

                         
                            Column(
                              children: <Widget>[
                                Text(
                                  
                                 "Your photo must clearly",
                                 overflow: TextOverflow.visible,
                                 textAlign: TextAlign.center,
                                 style: GoogleFonts.roboto(
                                   fontStyle: FontStyle.italic
                                 ),

                                  
                           ),
                           Text(
                                  
                                 " show your full face, without",
                                 overflow: TextOverflow.visible,
                                 textAlign: TextAlign.center,
                                 style: GoogleFonts.roboto(
                                   fontStyle: FontStyle.italic
                                 ),

                                  
                           ),
                           Text(
                                  
                                 "props and other people.",
                                 overflow: TextOverflow.visible,
                                 textAlign: TextAlign.center,
                                 style: GoogleFonts.roboto(
                                   fontStyle: FontStyle.italic
                                 ),

                                  
                           ),
                              ],
                            ),
                         
                         


                      ],
              
              ),
            ),


            SizedBox(
              height: 60,
            ),

            
               

                Center(
                  child: Text(' "Having a profile Picture increases the chance of getting a match"  - CEO ' ,
                  style: GoogleFonts.roboto(
                    color: Colors.deepOrange,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    
                  ),
                  textAlign: TextAlign.center,
                  ),
                ),

        SizedBox(height:20),  
        
         Center(
          child: Container(

        width: MediaQuery.of(context).size.width/1.6,
            
        height: 50,
        margin: EdgeInsets.only(top:50),
             child:RaisedButton(
               onPressed: () {
                 setState(() {
                  photo = photo; 
                 });
                 isPressed3 = !isPressed3;
               },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80),


        ),
           child: Ink(
             width: MediaQuery.of(context).size.width/1.01,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                (Color(0xff374ABE)), (Color(0xff64B6FF))
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight
              ),

              borderRadius: BorderRadius.circular(30),
             

            ),
             padding: EdgeInsets.all(0.0),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 300,
                minHeight: 100
              ),
              child: Center(
                              child: Text(
                  
                  !isPressed3 ? "Save" : "Got it",
                  textAlign: TextAlign.center,               
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              ),
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


    //TODO
    Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 20),
      color: color5,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(180),
          ),
        ),
        child: Column(
          children: <Widget>[
            
            
            // Image.asset(
            //   imgUrl,
            //   height: 300,
            // ),
            SizedBox(height:80,),
            
            Text(
              "Let's add more pictures",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Don't make it vulger folks, we are watching you",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                
                color: Colors.black,

              
               
                fontSize: 14,
              ),
            ),
            
            
            
            SizedBox(
              height: 30,
            ),
        




            // ImageTiles( 
            //   () async{
            //   File getPic1 = await FilePicker.getFile(type: FileType.image);
            //   if(getPic1 !=null) {
            //      await compressImage();
            //      photo2 = getPic1;
            //    } 
            // },
            //  MediaQuery.of(context).size.height/3,
            //  MediaQuery.of(context).size.width/3,
            //  photo2 == null ? AssetImage('assets/profilePhoto.png') : FileImage(photo2),),

          

          Row(
          
                     children: <Widget>[
               GestureDetector(
              
                onTap: () async {
                 File getPic = await FilePicker.getFile(type: FileType.image);
                if(getPic !=null) {
                   //await compressImage();
                   photo2 = getPic;
                 }

               }, 
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: Container(
                      padding: EdgeInsets.only(left:10),
                      
                    alignment: Alignment.topLeft,
                    width: size.width/3.5,
                    height: size.height/4.5,
                    decoration: BoxDecoration(
                     
                      image: DecorationImage(
                        image: photo2 == null ?  AssetImage('assets/images/addImage.jpg') : FileImage(photo2),
                        fit: BoxFit.cover
                        
                        
                        )
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          colors: [Colors.grey[200].withOpacity(.9), Colors.grey.withOpacity(0)]
                          )
                      ),
                    ),
                ),
                  ),
              ),
                     
                     SizedBox(width: 10,),


              //Photo 3

               GestureDetector(
              
                onTap: () async {
                 File getPic = await FilePicker.getFile(type: FileType.image);
                if(getPic !=null) {
                   //await compressImage();
                   photo3 = getPic;
                 }

               }, 
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: Container(
                      
                    alignment: Alignment.topLeft,
                    width: size.width/3.5,
                    height: size.height/4.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: photo3 == null ? AssetImage('assets/images/addImage.jpg') : FileImage(photo3),
                        fit: BoxFit.cover
                        
                        
                        )
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          colors: [Colors.grey[200].withOpacity(.9), Colors.grey.withOpacity(0)]
                          )
                      ),
                    ),
                ),
                  ),
              ), 

              SizedBox(width:10),
              //photo4

               GestureDetector(
              
                onTap: () async {
                 File getPic = await FilePicker.getFile(type: FileType.image);
                if(getPic !=null) {
                   //await compressImage();
                   photo4 = getPic;
                 }

               }, 
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: Container(
                      
                    alignment: Alignment.topLeft,
                    width: size.width/3.5,
                    height: size.height/4.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: photo4 == null ? AssetImage('assets/images/addImage.jpg') : FileImage(photo4),
                        fit: BoxFit.cover
                        
                        
                        )
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          colors: [Colors.grey[200].withOpacity(.9), Colors.grey.withOpacity(0)]
                          )
                      ),
                    ),
                ),
                  ),
              ), 

              //photo4:


                     ],
          ),

          SizedBox(height:30),

        Column(
            children: <Widget>[
            
              Row(
                
                children: <Widget>[
                  
                  //photo 5:

                   GestureDetector(
              
                onTap: () async {
                 File getPic = await FilePicker.getFile(type: FileType.image);
                if(getPic !=null) {
                   //await compressImage();
                   photo5 = getPic;
                 }

               }, 
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: Container(
                      padding: EdgeInsets.only(left:10),
                      
                    alignment: Alignment.topLeft,
                    width: size.width/3.5,
                    height: size.height/4.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: photo5 == null ? AssetImage('assets/images/addImage.jpg') : FileImage(photo5),
                        fit: BoxFit.cover
                        
                        
                        )
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          colors: [Colors.grey[200].withOpacity(.9), Colors.grey.withOpacity(0)]
                          )
                      ),
                    ),
                ),
                  ),
              ), 

              SizedBox(width:10),

                //photo 6:

                  GestureDetector(
              
                onTap: () async {
                 File getPic = await FilePicker.getFile(type: FileType.image);
                if(getPic !=null) {
                   //await compressImage();
                   photo6 = getPic;
                 }

               }, 
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: Container(
                      
                    alignment: Alignment.topLeft,
                    width: size.width/3.5,
                    height: size.height/4.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: photo6 == null ? AssetImage('assets/images/addImage.jpg') : FileImage(photo6),
                        fit: BoxFit.cover
                        
                        
                        )
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          colors: [Colors.grey[200].withOpacity(.9), Colors.grey.withOpacity(0)]
                          )
                      ),
                    ),
                ),
                  ),
              ), 


              //photo7

              SizedBox(width:10),

              GestureDetector(
              
                onTap: () async {
                 File getPic = await FilePicker.getFile(type: FileType.image);
                if(getPic !=null) {
                   //await compressImage();
                   photo7 = getPic;
                 }

               }, 
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: Container(
                      
                    alignment: Alignment.topLeft,
                    width: size.width/3.5,
                    height: size.height/4.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: photo7 == null ? AssetImage('assets/images/addImage.jpg') : FileImage(photo7),
                        fit: BoxFit.cover
                        
                        
                        )
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          colors: [Colors.grey[200].withOpacity(.9), Colors.grey.withOpacity(0)]
                          )
                      ),
                    ),
                ),
                  ),
              ), 


                ],

              ) ,
           

          ],
        ),

         


       
        
         Center(
          child: Container(

        width: MediaQuery.of(context).size.width/1.6,
            
        height: 50,
        margin: EdgeInsets.only(top:50),
             child:RaisedButton(
               onPressed: () async {
                 setState(() {

                   photo2 = photo2;
                   photo3 = photo3;
                   photo4 = photo4;
                   photo5 = photo5;
                   photo6 = photo6;
                   photo7 = photo7;




                    //TODO

                 });

                   
                  await uploadImage(photo2, "photo2");
                  await uploadImage(photo3, "photo3");
                  await uploadImage(photo4, "photo4");
                  await uploadImage(photo5, "photo5");
                  await uploadImage(photo6, "photo6");
                  await uploadImage(photo7, "photo7");

                 isPressed4 = !isPressed4;

                
               },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80),


        ),
           child: Ink(
             width: MediaQuery.of(context).size.width/1.01,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                (Color(0xff374ABE)), (Color(0xff64B6FF))
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight
              ),

              borderRadius: BorderRadius.circular(30),
             

            ),
             padding: EdgeInsets.all(0.0),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 300,
                minHeight: 100
              ),
              child: Center(
                              child: Text(
                  
                  !isPressed4 ? "Save" : "Got it",
                  textAlign: TextAlign.center,               
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              ),
            ),
        ),
             ),
        ),
         ),
           
              
            
          ],
        ),
      ),
    ),




// Select your community

      Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 20),
      color: color6,
      child: Container(
      height: MediaQuery.of(context).size.height,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(180),
          ),
        ),
        child: SingleChildScrollView(
                  child: Column(
            children: <Widget>[
              
              
              // Image.asset(
              //   imgUrl,
              //   height: 300,
              // ),
              SizedBox(height:80,),
              
              Text(
                "Select your community: ",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              
              
              SizedBox(
                height: 60,
              ),

             
    

             Container(
              padding: EdgeInsets.only(left:10),
            
                 child: DropDownField(
                     
                   controller: communitySelected,
                
                   
                   hintText: "Select your community",
                   textStyle: GoogleFonts.roboto(color:Colors.black),
                   enabled: true,
                   
                   itemsVisibleInDropdown: 5,
                   
                   
                   items:communities,
                   onValueChanged: (val) {
                    setState(() {
                      selectCommunity = val;
                    });

                   },
                  ),

               ),
                 
             

             SizedBox(height:50),

               selectCommunity == "Other" ? 
               
               Container(
                  width: MediaQuery.of(context).size.width/1.2,
                  child: TextFormField(
                  controller: _communityController,
                  decoration: InputDecoration(
                    hintText: "Other",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,

                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      

                    ),
                    
                  ),
              ),
               ) : Text(""),
              
             


          SizedBox(height:100),  
          
           Center(
                      child: SingleChildScrollView(
                                            child: Container(

          width: MediaQuery.of(context).size.width/1.6,
              
          height: 50,
          margin: EdgeInsets.only(top:50),
               child:RaisedButton(
                 onPressed: () {
                  selectCommunity == "Other" ? setState(() {
                    
                    community = _communityController.text; 
                   }): setState(() {
                     community = selectCommunity;
                   });
                   print(community);
                   isPressed5 = !isPressed5;
                 },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(80),


          ),
             child: Ink(
               width: MediaQuery.of(context).size.width/1.01,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  (Color(0xff374ABE)), (Color(0xff64B6FF))
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight
                ),

                borderRadius: BorderRadius.circular(30),
               

              ),
               padding: EdgeInsets.all(0.0),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 300,
                  minHeight: 100
                ),
                child: Center(
                                  child: Text(
                    
                  !isPressed5 ? "Save" : "Got it",
                    textAlign: TextAlign.center,               
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
          ),
               ),
          ),
                      ),
           ),
             
                
              
            ],
          ),
        ),
      ),
    ),


// Height


  Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 20),
      color: color3,
      child: Container(
        height: MediaQuery.of(context).size.height,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(180),
          ),
        ),
        child: SingleChildScrollView(
                  child: Column(
            children: <Widget>[
              
              
              // Image.asset(
              //   imgUrl,
              //   height: 300,
              // ),
              SizedBox(height:70,),
              
              Text(
                "How tall are you? ",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              
              
              SizedBox(
                height: 70,
              ),

             Container(
               width: MediaQuery.of(context).size.width/1.2,
                 child: DropDownField(
                 controller: heightselected,
                 hintText: "Select your height",
                 textStyle: GoogleFonts.roboto(color:Colors.black),
                 enabled: true,
                 
                 itemsVisibleInDropdown: 8,
                 
                 items:heights,
                 onValueChanged: (val) {
                  setState(() {
                    selectheight = val;
                  });

                 },

               ),
             ),

             SizedBox(height:200),

               Center(
                      child: SingleChildScrollView(
                                            child: Container(

          width: MediaQuery.of(context).size.width/1.6,
              
          height: 50,
          margin: EdgeInsets.only(top:50),
               child:RaisedButton(
                 onPressed: () {
                  setState(() {
                     heightP = selectheight;
                   });
                  
                  isPressed6 =!isPressed6;
                 },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(80),


          ),
             child: Ink(
               width: MediaQuery.of(context).size.width/1.01,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  (Color(0xff374ABE)), (Color(0xff64B6FF))
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight
                ),

                borderRadius: BorderRadius.circular(30),
               

              ),
               padding: EdgeInsets.all(0.0),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 300,
                  minHeight: 100
                ),
                child: Center(
                                  child: Text(
                    
                  !isPressed6 ? "Save" : "Got it",
                    textAlign: TextAlign.center,               
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
          ),
               ),
          ),
                      ),
           ),



      ],
                  ),
        ),
      ),
  ),


//Country
   Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 20),
      color: color2,
      child: Container(
        height: MediaQuery.of(context).size.height,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(180),
          ),
        ),
        child: SingleChildScrollView(
                  child: Column(
            children: <Widget>[
              
              
              // Image.asset(
              //   imgUrl,
              //   height: 300,
              // ),
              SizedBox(height:120,),
              
              Text(
                "Where were you raised? ",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              
              
              SizedBox(
                height: 20,
              ),

             Container(
               width: MediaQuery.of(context).size.width/1.2,
                 child: DropDownField(
                 controller: countrySelected,
                 hintText: "Select the country",
                 textStyle: GoogleFonts.roboto(color:Colors.black),
                 enabled: true,
                 
                 itemsVisibleInDropdown: 5,
                 
                 items:countries,
                 onValueChanged: (val) {
                  setState(() {
                    selectCountry = val;
                  });

                 },

               ),
             ),

             SizedBox(height:50),

               selectCountry == "Other" ? 
               
               Container(
                  width: MediaQuery.of(context).size.width/1.2,
                  child: TextFormField(
                  controller: _countryController,
                  decoration: InputDecoration(
                    hintText: "Other",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,

                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      

                    ),
                    
                  ),
              ),
               ) : Text(""),
              
             


          SizedBox(height:100),  
          
           Center(
                      child: SingleChildScrollView(
                                            child: Container(

          width: MediaQuery.of(context).size.width/1.6,
              
          height: 50,
          margin: EdgeInsets.only(top:50),
               child:RaisedButton(
                 onPressed: () {
                  selectCountry == "Other" ? setState(() {
                    
                    country = _countryController.text; 
                   }): setState(() {
                     country = selectCountry;
                   });
                   print(country);
                   isPressed7 =!isPressed7;
                 },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(80),


          ),
             child: Ink(
               width: MediaQuery.of(context).size.width/1.01,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  (Color(0xff374ABE)), (Color(0xff64B6FF))
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight
                ),

                borderRadius: BorderRadius.circular(30),
               

              ),
               padding: EdgeInsets.all(0.0),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 300,
                  minHeight: 100
                ),
                child: Center(
                                  child: Text(
                    
                  !isPressed7 ? "Save" : "Got it",
                    textAlign: TextAlign.center,               
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
          ),
               ),
          ),
                      ),


           ),
            ],
                  ),
        ),
      ),
   ),



   //Looking for
   Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 20),
      color: color1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(180),
          ),
        ),
        child: Column(
          children: <Widget>[
            
            
            // Image.asset(
            //   imgUrl,
            //   height: 300,
            // ),
            SizedBox(height:120,),
            
            Text(
              "What are you looking for in here?",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            
            
            SizedBox(
              height: 40,
            ),


            //CheckBox with image

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
            height: 120.0,
            width: size.width/1.09,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), 
              image: DecorationImage(
                colorFilter: !_isChecked ? ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop) : ColorFilter.mode(Colors.black.withOpacity(1), BlendMode.dstATop) ,
                image: ExactAssetImage('assets/images/casual.jpg'),
                fit: BoxFit.cover,
              ),
            ),
           

           
             child: Container(
               padding: EdgeInsets.only(left:10, top:80),
               child: Text("Casual",
               textAlign: TextAlign.left,
                style: GoogleFonts.roboto(color: Colors.white, fontSize: size.width/18)),
             ),
           


            

            



           
            ),
          ),
        ),
                SizedBox(height:10),

      
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
            height: 120.0,
            width: size.width/1.09,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), 
              image: DecorationImage(
                colorFilter: !_isChecked2 ? ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop) : ColorFilter.mode(Colors.black.withOpacity(1), BlendMode.dstATop) ,
                image: ExactAssetImage('assets/images/dating2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            

           child: Container(
             padding: EdgeInsets.only(left:10, top:80),
             child: Text("Dating",
             textAlign: TextAlign.left,
              style: GoogleFonts.roboto(color: Colors.white, fontSize: size.width/18)),
           ),


            

            



           
            ),
          ),
        ),

        SizedBox(height:10),


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
            height: 120.0,
            width: size.width/1.09,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), 
              image: DecorationImage(
                colorFilter: !_isChecked3 ? ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop) : ColorFilter.mode(Colors.black.withOpacity(1), BlendMode.dstATop) ,
                image: ExactAssetImage('assets/images/dating3.jpg'),
                fit: BoxFit.cover,
              ),
            ),
           

           child: Container(
             padding: EdgeInsets.only(left:10, top:80),
             child: Text("Long term",
             textAlign: TextAlign.left,
              style: GoogleFonts.roboto(color: Colors.white, fontSize: size.width/18)),
           ),


            

            



           
            ),
          ),
        ),
      

           
              
            

        SizedBox(height:20),
        
         Center(
                    child: Container(

        width: MediaQuery.of(context).size.width/1.6,
            
        height: 50,
        margin: EdgeInsets.only(top:50),
             child:RaisedButton(
               onPressed: () {
                 setState(() {
                  
                 });
                isPressed8 =!isPressed8;
               },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80),


        ),
           child: Ink(
             width: MediaQuery.of(context).size.width/1.01,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                (Color(0xff374ABE)), (Color(0xff64B6FF))
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight
              ),

              borderRadius: BorderRadius.circular(30),
             

            ),
             padding: EdgeInsets.all(0.0),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 300,
                minHeight: 100
              ),
              child: Center(
                              child: Text(
                  
                  !isPressed8 ? "Save" : "Got it",
                  textAlign: TextAlign.center,               
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              ),
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
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 20),
      color: color3,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(180),
          ),
        ),
        child: Column(
          children: <Widget>[
            
            
            // Image.asset(
            //   imgUrl,
            //   height: 300,
            // ),
            SizedBox(height:120,),
            
            Text(
              "Preferred age of your partner: ",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            
            
            SizedBox(
              height: 40,
            ),


            //CheckBox with image

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
            height: 120.0,
            width: size.width/1.09,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), 
              image: DecorationImage(
                colorFilter: !_isChecked6 ? ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop) : ColorFilter.mode(Colors.black.withOpacity(1), BlendMode.dstATop) ,
                image: ExactAssetImage( interestedIn =="Female" ? 'assets/images/18.jpg':'assets/images/18m.jpg' ),
                fit: BoxFit.cover,
              ),
            ),
           

           child: Container(
         padding: EdgeInsets.only(left:10, top:80),    
             child: Text("18-25",
             textAlign: TextAlign.left,
              style: GoogleFonts.roboto(color: Colors.white, fontSize: size.width*0.05), ),
           ),


           

            



           
            ),
          ),
        ),
                SizedBox(height:10),

      
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
              width: size.width/1.09,
            height: 120.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), 
              image: DecorationImage(
                colorFilter: !_isChecked5 ? ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop) : ColorFilter.mode(Colors.black.withOpacity(1), BlendMode.dstATop) ,
                image: ExactAssetImage( interestedIn == "Male" ? 'assets/images/25.jpg': 'assets/images/25m.jpg' ),
                fit: BoxFit.cover,
              ),
            ),
           

           child: Container(
             padding: EdgeInsets.only(left:10, top:80),
             child: Text("25+",
             textAlign: TextAlign.left,
              style: GoogleFonts.roboto(color: Colors.white, fontSize: size.width*0.05),)
           ),


          

            



           
            ),
          ),
        ),

        SizedBox(height:10),


           
              
            

        SizedBox(height:20),
        
         Center(
            child: Container(

        width: MediaQuery.of(context).size.width/1.6,
            
        height: 50,
        margin: EdgeInsets.only(top:50),
             child:RaisedButton(
               onPressed: () {
                  _onSubmitted();
                 carouselSlider.nextPage(
                    duration: Duration(milliseconds: 500), curve: Curves.ease);
               },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80),


        ),
           child: Ink(
             width: MediaQuery.of(context).size.width/1.01,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                (Color(0xff374ABE)), (Color(0xff64B6FF))
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight
              ),

              borderRadius: BorderRadius.circular(30),
             

            ),
             padding: EdgeInsets.all(0.0),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 300,
                minHeight: 100
              ),
              child: Center(
                              child: Text(
                  
                  "Lets get started!",
                  textAlign: TextAlign.center,               
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              ),
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

   // return Scaffold(

      // floatingActionButton: carouselIndex == 10
      //     ? Container()
      //     : IconButton(
      //         icon: Icon(
      //           Icons.chevron_right,
      //           size: 30,
      //           color: Colors.white,
      //         ),
      //         onPressed: () {
      //           carouselSlider.nextPage(
      //               duration: Duration(milliseconds: 500), curve: Curves.ease);
      //         }),
      // body: Stack(
      //   alignment: Alignment.center,
      //   children: <Widget>[
      //     carouselSlider,
      //     carouselIndex == 10
      //         ? Positioned(
      //             bottom: 100,
      //             child: MaterialButton(
      //               color: color1,
      //               onPressed: () {},
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(30),
      //               ),
      //               padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
      //               child: Text(
      //                 'GET STARTED',
      //                 style: TextStyle(
      //                   color: Colors.white,
      //                   fontWeight: FontWeight.bold,
      //                   fontSize: 16,
      //                 ),
      //               ),
      //             ),
      //           )
      //         : Positioned(
      //             bottom: 130,
      //             child: Row(
      //               children: <Widget>[
      //                 Indicator(
      //                   carouselIndex: carouselIndex,
      //                   indicatorIndex: 0,
      //                 ),
      //                 Indicator(
      //                   carouselIndex: carouselIndex,
      //                   indicatorIndex: 1,
      //                 ),
      //                 Indicator(
      //                   carouselIndex: carouselIndex,
      //                   indicatorIndex: 2,
      //                 ),
      //                  Indicator(
      //                   carouselIndex: carouselIndex,
      //                   indicatorIndex: 3,
      //                 ),
      //                 Indicator(
      //                   carouselIndex: carouselIndex,
      //                   indicatorIndex: 4,
      //                 ),
      //                 Indicator(
      //                   carouselIndex: carouselIndex,
      //                   indicatorIndex: 5,
      //                 ),
      //                  Indicator(
      //                   carouselIndex: carouselIndex,
      //                   indicatorIndex: 6,
      //                 ),
      //                 Indicator(
      //                   carouselIndex: carouselIndex,
      //                   indicatorIndex: 7,
      //                 ),
      //                 Indicator(
      //                   carouselIndex: carouselIndex,
      //                   indicatorIndex: 8,
      //                 ),
      //               ],
      //             ),
      //           ),
      //   ],
      // ),
   // );
      
 



         

   


          // return SplashScreen( userRepository: _userRepository,);
          // return SingleChildScrollView(
          //   scrollDirection: Axis.vertical,
          //   child: Container(
          //     color: backgroundColor,
          //     width: size.width,
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: <Widget>[
          //         Container(
          //           width: size.width,
          //           child: CircleAvatar(radius:size.width * 0.3,
          //           backgroundColor: Colors.transparent,
          //           child: photo == null ? GestureDetector(
          //               onTap: () async {
          //                 File getPic = await FilePicker.getFile(type: FileType.image);
          //                 if(getPic !=null) {
          //                   photo = getPic;
          //                 }
          //               },

          //               child: Image.asset('assets/profilePhoto.png'),
          //           ) :  GestureDetector(
          //             onTap:() async {
          //                 File getPic = await FilePicker.getFile(type: FileType.image);
          //                 if(getPic !=null) {
          //                   await compressImage();
          //                   photo = getPic;
          //                 }
          //               }, 

          //               child: CircleAvatar(
          //                 radius: size.width * 0.3,
          //                 backgroundImage: FileImage(photo),

          //               ),
          //           )

          //           ),
                    

          //         ),
          //         textFieldWidget(_nameController, "Name", size),
          //         GestureDetector(
          //           onTap: () {
          //             DatePicker.showDatePicker(context, showTitleActions: true, 
          //             minTime:DateTime(1900,1,1),
          //             maxTime: DateTime(DateTime.now().year -19, 1,1 ),
          //             onConfirm: (date) {
          //               setState(() {
          //                 age =date;
          //               });
          //             },
          //             );
          //           },
          //           child: Text("Enter your birthday", style: TextStyle(
          //             color: Colors.white,
          //             fontSize: size.width * 0.09,

          //           ),) ,
          //         ),
          //         SizedBox(height:10),
          //         Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: <Widget>[
          //             Padding(
          //               padding: EdgeInsets.symmetric(horizontal: size.height * 0.02),
          //               child: Text("You are", style: TextStyle(
          //                 color: Colors.white, fontSize: size.width*0.09
          //               ),)
          //             ),
          //              Row(
          //                mainAxisAlignment: MainAxisAlignment.spaceAround,
          //                children: <Widget>[
          //                  genderWidget(FontAwesomeIcons.venus, "Female", size, gender, (){
          //                    setState(() {
          //                      gender = "Female";
          //                    });
          //                  }),
          //                  genderWidget(FontAwesomeIcons.mars, "Male", size, gender, (){
          //                    setState(() {
          //                      gender = "Male";
          //                    });
          //                  }),
          //                  genderWidget(FontAwesomeIcons.transgender, "Trans", size, gender, (){
          //                    setState(() {
          //                      gender = "Transgender";
          //                    });
          //                  }),

          //                ],
          //              ),

          //              SizedBox(height:size.height* 0.02),

          //              Padding(padding: EdgeInsets.symmetric(horizontal: size.height * 0.02), 
          //              child: Text("Looking for", style: TextStyle(
          //                 color: Colors.white, fontSize: size.width*0.09
          //               ),),


                       
          //              ),
          //               Row(
          //                mainAxisAlignment: MainAxisAlignment.spaceAround,
          //                children: <Widget>[
          //                  genderWidget(FontAwesomeIcons.venus, "Female", size, interestedIn, (){
          //                    setState(() {
          //                      interestedIn = "Female";
          //                    });
          //                  }),
          //                  genderWidget(FontAwesomeIcons.mars, "Male", size, interestedIn, (){
          //                    setState(() {
          //                      interestedIn = "Male";
          //                    });
          //                  }),
          //                  genderWidget(FontAwesomeIcons.transgender, "Trans", size, interestedIn, (){
          //                    setState(() {
          //                      interestedIn = "Transgender";
          //                    });
          //                  }),

          //                ],
          //              ),

          //           ],
          //         ),

          //         Padding(padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
          //         child: GestureDetector(
          //           onTap: () {
          //             if(isButtonEnabled(state)) {
          //               _onSubmitted();
          //             } else {

          //             }
          //           },

          //           child: Container(
          //             width: size.width * 0.8,
          //             height: size.height * 0.06,
          //             decoration: BoxDecoration(
          //               color: isButtonEnabled(state) ? Colors.white : Colors.grey,
          //               borderRadius: BorderRadius.circular(size.height * 0.05),

          //             ),
          //             child: Center(
          //               child: Text("Save", style: TextStyle(
          //                 fontSize: size.height * 0.025,
          //                 color: Colors.blue,

          //               ),),
          //             ),
          //           ),

          //         ),
          //         )
          //       ],
          //     ),
          //   ),
          // );
        },
      ),
      
      
      );
  }

  @override
  void dispose() {
   // _nameController.dispose();
    
    super.dispose();
  }



  Widget textFieldWidget(controller, text, size){
    return Padding(
      
      padding: EdgeInsets.all(size.height*0.02),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: text,

          labelStyle: TextStyle(color: Colors.white, fontSize: size.height*0.03),
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

// class MyClipper extends CustomClipper<Path> {
//   @override

//   Path getClip(Size size) {
//     var path = new Path();
//    path.moveTo(size.width-10, 0);
  
   
   
   
//     return path;
//   }
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper){
//     return true;
//   }
// }


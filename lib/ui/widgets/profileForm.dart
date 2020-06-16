import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:merosathi/bloc/authentication/authentication_bloc.dart';
import 'package:merosathi/bloc/authentication/authentication_event.dart';
import 'package:merosathi/bloc/profile/bloc.dart';
import 'package:merosathi/repositories/userRepository.dart';
import 'package:merosathi/ui/constants.dart';
import 'package:merosathi/ui/widgets/continue_button.dart';
import 'package:merosathi/ui/widgets/gender.dart';
import 'package:image/image.dart' as Im;
import 'package:merosathi/ui/widgets/onboarding.dart';
import 'package:merosathi/ui/widgets/continue_button.dart';



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
  File photo;
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



List<String> image = ['img1.png', 'img2.png', 'img3.png'];

List<String> title = [
  'What do your friends call you?',
  'Gender Page',
  'Profile Photo',
  '',
  '',
  ''
];

List<String> communities = ["Brahmin", "Chettri", "Other", "Magar", "Tharu","Tamang", "Newar", "Kami", "Nepali Muslims", "Yadav", "Rai", "Gurung", "Sherpa", "Thakuri", "Limbu", "Sarki", "Teli", "Harijan/Chamar/Ram", "Koiri/Kushwaha", "Musahar", "Kurmi", "Sanyashi/Dasnami","Dhanuk", "Dusadh/Pasawan/Pasi", "Raute", "Nurang", "Kusunda", "Hyolmo/Yolmo"];
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
      carouselSlider = CarouselSlider(
      viewportFraction: 1.0,
      enableInfiniteScroll: false,
      onPageChanged: (index) {
        setState(() {
          carouselIndex = index;
        });
      },
      height: MediaQuery.of(context).size.height,
      items: <Widget>[
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
       

          //Gender Page
        
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
           
              
            
          ],
        ),
      ),
    ),

      //Photo Page


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

    // Gallary to Pictures


    //TODO
    Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 20),
      color: color5,
      child: Container(
        decoration: BoxDecoration(
          color: color4,
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
              "Choose some of your best pictures",
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

       
        
         Center(
                    child: Container(

        width: MediaQuery.of(context).size.width/1.6,
            
        height: 50,
        margin: EdgeInsets.only(top:50),
             child:RaisedButton(
               onPressed: () {
                 setState(() {

                    //TODO

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




// Select your community

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


// Height


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


//Country
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



   //Looking for
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


//Preferred age
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




      ],

    );

    return Scaffold(
      floatingActionButton: carouselIndex == 10
          ? Container()
          : IconButton(
              icon: Icon(
                Icons.chevron_right,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                carouselSlider.nextPage(
                    duration: Duration(milliseconds: 500), curve: Curves.ease);
              }),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          carouselSlider,
          carouselIndex == 10
              ? Positioned(
                  bottom: 100,
                  child: MaterialButton(
                    color: color1,
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                    child: Text(
                      'GET STARTED',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              : Positioned(
                  bottom: 130,
                  child: Row(
                    children: <Widget>[
                      Indicator(
                        carouselIndex: carouselIndex,
                        indicatorIndex: 0,
                      ),
                      Indicator(
                        carouselIndex: carouselIndex,
                        indicatorIndex: 1,
                      ),
                      Indicator(
                        carouselIndex: carouselIndex,
                        indicatorIndex: 2,
                      ),
                       Indicator(
                        carouselIndex: carouselIndex,
                        indicatorIndex: 3,
                      ),
                      Indicator(
                        carouselIndex: carouselIndex,
                        indicatorIndex: 4,
                      ),
                      Indicator(
                        carouselIndex: carouselIndex,
                        indicatorIndex: 5,
                      ),
                       Indicator(
                        carouselIndex: carouselIndex,
                        indicatorIndex: 6,
                      ),
                      Indicator(
                        carouselIndex: carouselIndex,
                        indicatorIndex: 7,
                      ),
                      Indicator(
                        carouselIndex: carouselIndex,
                        indicatorIndex: 8,
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
      
 



         

   


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



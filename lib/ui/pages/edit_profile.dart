import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merosathi/models/user.dart';
import 'package:merosathi/ui/pages/my_profile.dart';
import 'package:merosathi/ui/widgets/button_untapped.dart';

class EditProfile extends StatefulWidget {
  final User currentUser;
  final List<String> images;
  final String currentUserId;

  EditProfile(this.currentUser, this.currentUserId, this.images);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File photo;
  File photo1;
  File photo2;
  File photo3;
  File photo4;

  File image1;
  File image2;
  File image3;
  File image4;

  List<File> replacedPhotos = [];

  Map<int, File> maps = {};

  List<String> images1 = [];

  int index1;
       File photoUrl;
      String userId;
      String name;
      String gender;
      String interestedIn;
      String country; 
      String heightP;
      String community;
      String salary;
      String gotra;
      String bio;
      String job;
      String religion;
      String education;

      DateTime age;
      GeoPoint location;
  

  @override
  void initState() {


    super.initState();
  }

  Map<int, String> imageData = {};
  List<int> requestedIndex = [];

  TextEditingController _bioController = TextEditingController();
  TextEditingController _jobController = TextEditingController();
  TextEditingController _religionController = TextEditingController();
  TextEditingController _salaryController = TextEditingController();
  TextEditingController _educationController = TextEditingController();
  TextEditingController _gotraController = TextEditingController();

  bool isTapped = false;

  List<bool> tapped = [false, false, false, false];

  uploadImage(File photo, String name) async {
    String uid = (await FirebaseAuth.instance.currentUser()).uid;

    final StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("userPhotos")
        .child(uid)
        .child(name);

    storageReference.putFile(photo);
  }

  uploadProfilePicture(photo) async {
    StorageUploadTask storageUploadTask;
    storageUploadTask = FirebaseStorage.instance
        .ref()
        .child('userPhotos')
        .child(widget.currentUserId)
        .child(widget.currentUserId)
        .putFile(photo);

    await storageUploadTask.onComplete.then((ref) async {
      await ref.ref.getDownloadURL().then((url) async {
        await Firestore.instance
            .collection('users')
            .document(widget.currentUser.uid)
            .setData({
          'uid': widget.currentUserId,
          'photoUrl': url,
          'name': name,
          "location": location,
          'gender': gender,
          'interestedIn': interestedIn,
          'age': age,
          'country':country,
          'height':heightP,
          'community': community,
          'job': job,
          'gotra': gotra,
          'religion': religion,
          'salary': salary,
          'bio': bio,
          'education': education,
        });
      });
    });
  }

  Future getImageURL() async {
     {
      for (int i = 1; i <= 5; i++) {
        try {
          final StorageReference storageReference = FirebaseStorage.instance
              .ref()
              .child("userPhotos")
              .child(widget.currentUserId)
              .child("photo$i");

          final String url = await storageReference.getDownloadURL();

          images1.add(url);
        } catch (e) {
          print(e);
        }
      }
    }
  }

  Future getUserInfo(currentUserId) async {

    
    await Firestore.instance
        .collection("users")
        .document(currentUserId)
        .get()
        .then((data) {
        setState(() {
        bio = data['bio'];
        job = data['job'];
        education = data['education'];
        religion = data['religion'];
        salary = data['salary'];
        gotra = data['gotra'];
        name = data['name'];
        location = data['location'];
        heightP = data['height'];
        community = data['community'];
        
        gender = data['gender'];
        interestedIn = data['interestedIn'];
        photo = data['photoUrl'];
        age = data['age'];
        country = data['country'];
             

      });
    });
  }

  List<String> temp = [];

  
  // buildImageHolder(images) {
  //   Size size = MediaQuery.of(context).size;

  //   switch (images.length) {
  //     case 0:
  //       return Container(
  //         width: size.width,
  //         child: Wrap(
  //           direction: Axis.horizontal,
  //           children: <Widget>[
  //             Container(
  //               height: size.height * 0.2,
  //               width: size.width / 3,
  //               child: GestureDetector(
  //                 onTap: () async {
  //                   File getPic =
  //                       await FilePicker.getFile(type: FileType.image);

  //                   if (getPic != null) {
  //                     //await compressImage();
  //                     image1 = getPic;
  //                     setState(() {
  //                       image1 = image1;
  //                     });

  //                     await uploadImage(image1, "photo2");
  //                   }
  //                 },
  //                 child: Container(
  //                   height: size.height * 0.2,
  //                   width: size.width / 3,
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(50),
  //                         border:
  //                             Border.all(color: Colors.deepOrange, width: 7)),
  //                     margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.all(
  //                         Radius.circular(50),
  //                       ),
  //                       child: image1 != null
  //                           ? Image.file(
  //                               image1,
  //                               fit: BoxFit.cover,
  //                             )
  //                           : Image.asset("assets/images/addImage.jpg"),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               height: size.height * 0.2,
  //               width: size.width / 3,
  //               child: GestureDetector(
  //                 onTap: () async {
  //                   File getPic =
  //                       await FilePicker.getFile(type: FileType.image);

  //                   if (getPic != null) {
  //                     //await compressImage();
  //                     image2 = getPic;
  //                     setState(() {
  //                       image2 = image2;
  //                     });

  //                     await uploadImage(image2, "photo3");
  //                   }
  //                 },
  //                 child: Container(
  //                   height: size.height * 0.2,
  //                   width: size.width / 3,
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(50),
  //                         border:
  //                             Border.all(color: Colors.deepOrange, width: 7)),
  //                     margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.all(
  //                         Radius.circular(50),
  //                       ),
  //                       child: image2 != null
  //                           ? Image.file(
  //                               image2,
  //                               fit: BoxFit.cover,
  //                             )
  //                           : Image.asset("assets/images/addImage.jpg"),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               height: size.height * 0.2,
  //               width: size.width / 3,
  //               child: GestureDetector(
  //                 onTap: () async {
  //                   File getPic =
  //                       await FilePicker.getFile(type: FileType.image);

  //                   if (getPic != null) {
  //                     //await compressImage();
  //                     image3 = getPic;
  //                     setState(() {
  //                       image3 = image3;
  //                     });

  //                     await uploadImage(image3, "photo3");
  //                   }
  //                 },
  //                 child: Container(
  //                   height: size.height * 0.2,
  //                   width: size.width / 3,
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(50),
  //                         border:
  //                             Border.all(color: Colors.deepOrange, width: 7)),
  //                     margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.all(
  //                         Radius.circular(50),
  //                       ),
  //                       child: image3 != null
  //                           ? Image.file(
  //                               image3,
  //                               fit: BoxFit.cover,
  //                             )
  //                           : Image.asset("assets/images/addImage.jpg"),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               height: size.height * 0.2,
  //               width: size.width / 3,
  //               child: GestureDetector(
  //                 onTap: () async {
  //                   File getPic =
  //                       await FilePicker.getFile(type: FileType.image);

  //                   if (getPic != null) {
  //                     //await compressImage();
  //                     image4 = getPic;
  //                     setState(() {
  //                       image4 = image4;
  //                     });

  //                     await uploadImage(image4, "photo4");
  //                   }
  //                 },
  //                 child: Container(
  //                   height: size.height * 0.2,
  //                   width: size.width / 3,
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(50),
  //                         border:
  //                             Border.all(color: Colors.deepOrange, width: 7)),
  //                     margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.all(
  //                         Radius.circular(50),
  //                       ),
  //                       child: image4 != null
  //                           ? Image.file(
  //                               image4,
  //                               fit: BoxFit.cover,
  //                             )
  //                           : Image.asset("assets/images/addImage.jpg"),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );

  //       break;

  //     case 1:
  //       return Container(
  //         width: size.width,
  //         child: Wrap(
  //           direction: Axis.vertical,
  //           children: <Widget>[
  //             Container(
  //               height: size.height * 0.2,
  //               width: size.width / 3,
  //               child: GestureDetector(
  //                 onTap: () async {
  //                   File getPic =
  //                       await FilePicker.getFile(type: FileType.image);

  //                   if (getPic != null) {
  //                     //await compressImage();
  //                     image1 = getPic;
  //                     setState(() {
  //                       image1 = image1;
  //                     });

  //                     await uploadImage(image1, "photo2");
  //                   }
  //                 },
  //                 child: Container(
  //                   height: size.height * 0.2,
  //                   width: size.width / 3,
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(50),
  //                         border:
  //                             Border.all(color: Colors.deepOrange, width: 7)),
  //                     margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.all(
  //                         Radius.circular(50),
  //                       ),
  //                       child: image1 != null
  //                           ? Image.file(
  //                               image1,
  //                               fit: BoxFit.cover,
  //                             )
  //                           : Image.asset("assets/images/addImage.jpg"),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               height: size.height * 0.2,
  //               width: size.width / 3,
  //               child: GestureDetector(
  //                 onTap: () async {
  //                   File getPic =
  //                       await FilePicker.getFile(type: FileType.image);

  //                   if (getPic != null) {
  //                     //await compressImage();
  //                     image2 = getPic;
  //                     setState(() {
  //                       image2 = image2;
  //                     });

  //                     await uploadImage(image2, "photo3");
  //                   }
  //                 },
  //                 child: Container(
  //                   height: size.height * 0.2,
  //                   width: size.width / 3,
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(50),
  //                         border:
  //                             Border.all(color: Colors.deepOrange, width: 7)),
  //                     margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.all(
  //                         Radius.circular(50),
  //                       ),
  //                       child: image2 != null
  //                           ? Image.file(
  //                               image2,
  //                               fit: BoxFit.cover,
  //                             )
  //                           : Image.asset("assets/images/addImage.jpg"),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               height: size.height * 0.2,
  //               width: size.width / 3,
  //               child: GestureDetector(
  //                 onTap: () async {
  //                   File getPic =
  //                       await FilePicker.getFile(type: FileType.image);

  //                   if (getPic != null) {
  //                     //await compressImage();
  //                     image3 = getPic;
  //                     setState(() {
  //                       image3 = image3;
  //                     });

  //                     await uploadImage(image3, "photo3");
  //                   }
  //                 },
  //                 child: Container(
  //                   height: size.height * 0.2,
  //                   width: size.width / 3,
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(50),
  //                         border:
  //                             Border.all(color: Colors.deepOrange, width: 7)),
  //                     margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.all(
  //                         Radius.circular(50),
  //                       ),
  //                       child: image3 != null
  //                           ? Image.file(
  //                               image3,
  //                               fit: BoxFit.cover,
  //                             )
  //                           : Image.asset("assets/images/addImage.jpg"),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );

  //       break;

  //     case 2:
  //       return Container(
  //         width: size.width,
  //         child: Wrap(
  //           direction: Axis.vertical,
  //           children: <Widget>[
  //             Container(
  //               height: size.height * 0.2,
  //               width: size.width / 3,
  //               child: GestureDetector(
  //                 onTap: () async {
  //                   File getPic =
  //                       await FilePicker.getFile(type: FileType.image);

  //                   if (getPic != null) {
  //                     //await compressImage();
  //                     image1 = getPic;
  //                     setState(() {
  //                       image1 = image1;
  //                     });

  //                     await uploadImage(image1, "photo2");
  //                   }
  //                 },
  //                 child: Container(
  //                   height: size.height * 0.2,
  //                   width: size.width / 3,
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(50),
  //                         border:
  //                             Border.all(color: Colors.deepOrange, width: 7)),
  //                     margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.all(
  //                         Radius.circular(50),
  //                       ),
  //                       child: image1 != null
  //                           ? Image.file(
  //                               image1,
  //                               fit: BoxFit.cover,
  //                             )
  //                           : Image.asset("assets/images/addImage.jpg"),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               height: size.height * 0.2,
  //               width: size.width / 3,
  //               child: GestureDetector(
  //                 onTap: () async {
  //                   File getPic =
  //                       await FilePicker.getFile(type: FileType.image);

  //                   if (getPic != null) {
  //                     //await compressImage();
  //                     image2 = getPic;
  //                     setState(() {
  //                       image2 = image2;
  //                     });

  //                     await uploadImage(image2, "photo3");
  //                   }
  //                 },
  //                 child: Container(
  //                   height: size.height * 0.2,
  //                   width: size.width / 3,
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(50),
  //                         border:
  //                             Border.all(color: Colors.deepOrange, width: 7)),
  //                     margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.all(
  //                         Radius.circular(50),
  //                       ),
  //                       child: image2 != null
  //                           ? Image.file(
  //                               image2,
  //                               fit: BoxFit.cover,
  //                             )
  //                           : Image.asset("assets/images/addImage.jpg"),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );

  //       break;
  //     case 3:
  //       return Container(
  //         width: size.width,
  //         child: Wrap(
  //           direction: Axis.vertical,
  //           children: <Widget>[
  //             Container(
  //               height: size.height * 0.2,
  //               width: size.width / 3,
  //               child: GestureDetector(
  //                 onTap: () async {
  //                   File getPic =
  //                       await FilePicker.getFile(type: FileType.image);

  //                   if (getPic != null) {
  //                     //await compressImage();
  //                     image1 = getPic;
  //                     setState(() {
  //                       image1 = image1;
  //                     });

  //                     await uploadImage(image1, "photo2");
  //                   }
  //                 },
  //                 child: Container(
  //                   height: size.height * 0.2,
  //                   width: size.width / 3,
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(50),
  //                         border:
  //                             Border.all(color: Colors.deepOrange, width: 7)),
  //                     margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.all(
  //                         Radius.circular(50),
  //                       ),
  //                       child: image1 != null
  //                           ? Image.file(
  //                               image1,
  //                               fit: BoxFit.cover,
  //                             )
  //                           : Image.asset("assets/images/addImage.jpg"),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );

  //       break;
  //     default:
  //       return Text("");

  //       break;
  //   }
  // }

  buildPhotosContainer(images, currentUser) {
    
    
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            height: size.height * 0.4,
            width: size.width,
            child: GestureDetector(
              onTap: () async {
                File getPic = await FilePicker.getFile(type: FileType.image);
                if (getPic != null) {
                  photo = getPic;
                  setState(
                    () {
                      photo = photo;
                      isTapped = !isTapped;
                    },
                  );
                  await uploadProfilePicture(photo);
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  child: isTapped == false
                      ? Image.network(
                          currentUser.photo,
                          fit: BoxFit.cover,
                        )
                      : Image.file(photo),
                ),
              ),
            ),
          ),
        ),
        GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (context, index) {
               
              return GestureDetector(
                onTap: () async {
                  File getPic = await FilePicker.getFile(type: FileType.image);

                  if (getPic != null ) {
                    //await compressImage();
                    if (index == 0) {
                      photo1 = getPic;
                      setState(() {
                        tapped[0] = !tapped[0];
                      });
                      
                      replacedPhotos.add(photo1);
                      maps.putIfAbsent(0, () => photo1);
                      await uploadImage(photo1, "photo2");
                      
                    } else if (index == 1) {
                      photo2 = getPic;
                      setState(() {
                        tapped[1] = !tapped[1];
                      });
                      replacedPhotos.add(photo2);
                      maps.putIfAbsent(1, () => photo2);
                      await uploadImage(photo2, "photo3");
                    } else if (index == 2) {
                      photo3 = getPic;

                      setState(() {
                        tapped[2] = !tapped[2];
                      });
                      
                      replacedPhotos.add(photo3);
                      maps.putIfAbsent(2, () => photo3);
                      await uploadImage(photo3, "photo4");
                    } else if(index ==3){
                      photo4 = getPic;
                      setState(() {
                        tapped[3] = !tapped[3];
                      });
                       
                      replacedPhotos.add(photo3);
                      maps.putIfAbsent(3, () => photo4);
                      await uploadImage(photo4, "photo5");
                    } else return;
                  }
                },
                child: Container(
                  height: size.height * 0.2,
                  width: size.width / 3,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                      child: (index > (images.length-1)) ? Image.asset("assets/images/addImage.jpg"): tapped[index] == false
                          ? Image.network(
                              images[index],
                              fit: BoxFit.cover,
                            )
                          : (Image.file(maps[index])),
                          
                    ),
                    
                  ),
                  
                ),
                
              );
              
                

              
            }
            
            ),
            
      ],
    
    );
   
  }

  updateChanges(currentUserId) async {
    await Firestore.instance
        .collection("users")
        .document(currentUserId)
        .updateData({
      "bio": _bioController.text.isEmpty ? bio : _bioController.text,
      "job": _jobController.text.isEmpty ? job : _jobController.text,
      "education": _educationController.text.isEmpty
          ? education
          : _educationController.text,
      "salary":
          _salaryController.text.isEmpty ? salary : _salaryController.text,
      "religion": _religionController.text.isEmpty
          ? religion
          : _religionController.text,
      "gotra": _gotraController.text.isEmpty ? gotra : _gotraController.text,
      
    });
  }

  @override
  Widget build(BuildContext context) {
    

    
    images1.clear();
    print(temp);

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: GoogleFonts.ubuntu(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20, right: 310),
                child: Text(
                  "Photos",
                  style: GoogleFonts.ubuntu(
                      color: Colors.deepOrange,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 5, right: 5),
                child: FutureBuilder(
                    future: Future.wait([getImageURL(), getUserInfo(widget.currentUserId)]),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Text('none');
                        case ConnectionState.active:
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                        case ConnectionState.done:
                       
                          return Column(
                            children: <Widget>[
                              buildPhotosContainer(images1, widget.currentUser),
                             // buildImageHolder(images1),
                           
             
              Padding(
                padding: const EdgeInsets.only(right: 340, top: 25),
                child: Text("Bio",
                    style: GoogleFonts.ubuntu(
                        color: Colors.deepOrange,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  height: size.height * 0.15,
                  width: size.width / 1.1,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: const EdgeInsets.only(),
                    child: TextField(
                      controller: _bioController,
                      maxLines: 5,
                      
                    
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal:15, vertical: 15),

                        labelStyle: GoogleFonts.ubuntu(
                          color: Colors.black,
                          fontSize: 20,
                        ),

                        hintText : bio,
                        hintStyle: GoogleFonts.ubuntu(
                          color: Colors.black38,
                          
                        ),
                      
                        fillColor: Colors.black,
                        focusedBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepOrange, width:2.0),
                          borderRadius: BorderRadius.circular(30)
                        ),

                        focusColor: Colors.orangeAccent,
                      ),
                      cursorColor: Colors.black,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25, right: 220),
                child: Text(
                  "What do you do?",
                  style: GoogleFonts.ubuntu(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: size.height * 0.06,
                width: size.width / 1.1,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.only(),
                  child: TextField(
                    
                    controller: _jobController,
                    decoration: InputDecoration(
                 contentPadding: EdgeInsets.symmetric(horizontal:15, vertical: 15),

                      border: InputBorder.none,
                      labelStyle: GoogleFonts.ubuntu(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      hintText: job,
                      fillColor: Colors.black,
                        focusedBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepOrange, width:2.0),
                          borderRadius: BorderRadius.circular(30)
                        ),
                    ),
                    cursorColor: Colors.black,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25, right: 290),
                child: Text(
                  "Religion",
                  style: GoogleFonts.ubuntu(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: size.height * 0.06,
                width: size.width / 1.1,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.only(),
                  child: TextField(
                    controller: _religionController,
                    decoration: InputDecoration(
                     contentPadding: EdgeInsets.symmetric(horizontal:15, vertical: 15),

                      border: InputBorder.none,
                      labelStyle: GoogleFonts.ubuntu(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      hintText: religion,
                      fillColor: Colors.black,
                        focusedBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepOrange, width:2.0),
                          borderRadius: BorderRadius.circular(30)
                        ),
                    ),
                    cursorColor: Colors.black,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25, right: 150),
                child: Text(
                  "How much do you make?",
                  style: GoogleFonts.ubuntu(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: size.height * 0.06,
                width: size.width / 1.1,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.only(),
                  child: TextField(
                    controller: _salaryController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal:15, vertical: 15),
                      border: InputBorder.none,
                      labelStyle: GoogleFonts.ubuntu(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      hintText: salary,
                      fillColor: Colors.black,
                        focusedBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepOrange, width:2.0),
                          borderRadius: BorderRadius.circular(30)
                        ),
                    ),
                    cursorColor: Colors.black,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25, right: 280),
                child: Text(
                  "Education",
                  style: GoogleFonts.ubuntu(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: size.height * 0.06,
                width: size.width / 1.1,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.only(),
                  child: TextField(
                    controller: _educationController,
                    decoration: InputDecoration(
                       contentPadding: EdgeInsets.symmetric(horizontal:15, vertical: 15),
                      border: InputBorder.none,
                      labelStyle: GoogleFonts.ubuntu(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      hintText: education,
                      fillColor: Colors.black,
                        focusedBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepOrange, width:2.0),
                          borderRadius: BorderRadius.circular(30)
                        ),
                    ),
                    cursorColor: Colors.black,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25, right: 320),
                child: Text(
                  "Gotra",
                  style: GoogleFonts.ubuntu(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: size.height * 0.06,
                width: size.width / 1.1,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.only(),
                  child: TextField(
                    controller: _gotraController,
                    decoration: InputDecoration(
                       contentPadding: EdgeInsets.symmetric(horizontal:15, vertical: 15),
                      fillColor: Colors.black,
                        focusedBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepOrange, width:2.0),
                          borderRadius: BorderRadius.circular(30)
                        ),
                      border: InputBorder.none,
                      labelStyle: GoogleFonts.ubuntu(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      hintText: gotra,
                      focusColor: Colors.orangeAccent,
                    ),
                    cursorColor: Colors.black,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
                           

              buttonUnTappedWithText(context, Colors.deepOrange,
                  Colors.deepOrange, () {
                    updateChanges(widget.currentUserId);
                    Navigator.pop(context);
                  }, "Save Changes"),
              SizedBox(height: 70),
            ],
                          );
                }},
                ),
              ),
            ],
              ),
          ),
        ),
      );
    
  }
}

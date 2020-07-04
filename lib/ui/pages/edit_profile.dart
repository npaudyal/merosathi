import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merosathi/models/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  final User currentUser;
  final String currentUserId;
  final List<String> images;

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

// Future<File> urlToFile(String imageUrl) async {
// var rng = new Random();
// Directory tempDir = await getTemporaryDirectory();
// String tempPath = tempDir.path;
// File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
// http.Response response = await http.get(imageUrl);
// await file.writeAsBytes(response.bodyBytes);

// replacedPhotos.add(file);
// return file;
// }

// getreplacedImages() async {
// for(int i =0; i<=widget.images.length; i++) {
//   await urlToFile(widget.images[i]);
// }
// }

  @override
  void initState() {
    // getreplacedImages();
    super.initState();
  }

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
          'name': widget.currentUser.name,
          "location": widget.currentUser.location,
          'gender': widget.currentUser.gender,
          'interestedIn': widget.currentUser.interestedIn,
          'age': widget.currentUser.age,
          'country': widget.currentUser.country,
          'height': widget.currentUser.heightP,
          'community': widget.currentUser.community,
          'job': widget.currentUser.job,
          'gotra': widget.currentUser.gotra,
          'religion': widget.currentUser.religion,
          'salary': widget.currentUser.salary,
          'bio': widget.currentUser.bio,
          'education': widget.currentUser.education,
        });
      });
    });
  }

  buildImageHolder(images) {
    Size size = MediaQuery.of(context).size;
    switch (widget.images.length) {
      case 0:
        return Container(
          height: size.height,
          width: size.width,
          child: Wrap(
            direction: Axis.vertical,
            children: <Widget>[
              Container(
                height: size.height * 0.2,
                width: size.width / 3,
                child: GestureDetector(
                  onTap: () async {
                    File getPic = await FilePicker.getFile(type: FileType.image);

                    if (getPic != null ) {
                      //await compressImage();
                      image1 = getPic;
                      setState(() {
                        image1 = image1;
                      });

                      await uploadImage(image1, "photo2");
                      
                    }
                  },
                  child: Container(
                    height: size.height * 0.2,
                    width: size.width / 3,
                    child: Container(
                      decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(50),
                       border: Border.all(
                       color: Colors.deepOrange, width: 7)
                     ),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                        child: image1 != null ? Image.file(
                                image1,
                                fit: BoxFit.cover,
                              )
                            : Image.asset("assets/images/addImage.jpg"),
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                height: size.height * 0.2,
                width: size.width / 3,
                child: GestureDetector(
                  onTap: () async {
                    File getPic = await FilePicker.getFile(type: FileType.image);

                    if (getPic != null ) {
                      //await compressImage();
                      image2 = getPic;
                      setState(() {
                        image2 = image2;
                      });

                      await uploadImage(image2, "photo3");
                      
                    }
                  },
                  child: Container(
                    height: size.height * 0.2,
                    width: size.width / 3,
                    child: Container(
                      decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(50),
                       border: Border.all(
                       color: Colors.deepOrange, width: 7)
                     ),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                        child: image2 != null ? Image.file(
                                image2,
                                fit: BoxFit.cover,
                              )
                            : Image.asset("assets/images/addImage.jpg"),
                      ),
                    ),
    
                  ),

          ),
              ),

              Container(
                height: size.height * 0.2,
                width: size.width / 3,
                child: GestureDetector(
                  onTap: () async {
                    File getPic = await FilePicker.getFile(type: FileType.image);

                    if (getPic != null ) {
                      //await compressImage();
                      image3 = getPic;
                      setState(() {
                        image3 = image3;
                      });

                      await uploadImage(image3, "photo3");
                      
                    }
                  },
                  child: Container(
                    height: size.height * 0.2,
                    width: size.width / 3,
                    child: Container(
                      decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(50),
                       border: Border.all(
                       color: Colors.deepOrange, width: 7)
                     ),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                        child: image3 != null ? Image.file(
                                image3,
                                fit: BoxFit.cover,
                              )
                            : Image.asset("assets/images/addImage.jpg"),
                      ),
                    ),
    
                  ),

          ),
              ),

              Container(
                height: size.height * 0.2,
                width: size.width / 3,
                child: GestureDetector(
                  onTap: () async {
                    File getPic = await FilePicker.getFile(type: FileType.image);

                    if (getPic != null ) {
                      //await compressImage();
                      image4 = getPic;
                      setState(() {
                        image4 = image4;
                      });

                      await uploadImage(image4, "photo4");
                      
                    }
                  },
                  child: Container(
                    height: size.height * 0.2,
                    width: size.width / 3,
                    child: Container(
                      decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(50),
                       border: Border.all(
                       color: Colors.deepOrange, width: 7)
                     ),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                        child: image4 != null ? Image.file(
                                image4,
                                fit: BoxFit.cover,
                              )
                            : Image.asset("assets/images/addImage.jpg"),
                      ),
                    ),
    
                  ),

          ),
              ),
            ],
          ),
        );



      

        break;

      case 1:
      return Container(
          height: size.height,
          width: size.width,
          child: Wrap(
            direction: Axis.vertical,
            children: <Widget>[
              Container(
                height: size.height * 0.2,
                width: size.width / 3,
                child: GestureDetector(
                  onTap: () async {
                    File getPic = await FilePicker.getFile(type: FileType.image);

                    if (getPic != null ) {
                      //await compressImage();
                      image1 = getPic;
                      setState(() {
                        image1 = image1;
                      });

                      await uploadImage(image1, "photo2");
                      
                    }
                  },
                  child: Container(
                    height: size.height * 0.2,
                    width: size.width / 3,
                    child: Container(
                      decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(50),
                       border: Border.all(
                       color: Colors.deepOrange, width: 7)
                     ),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                        child: image1 != null ? Image.file(
                                image1,
                                fit: BoxFit.cover,
                              )
                            : Image.asset("assets/images/addImage.jpg"),
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                height: size.height * 0.2,
                width: size.width / 3,
                child: GestureDetector(
                  onTap: () async {
                    File getPic = await FilePicker.getFile(type: FileType.image);

                    if (getPic != null ) {
                      //await compressImage();
                      image2 = getPic;
                      setState(() {
                        image2 = image2;
                      });

                      await uploadImage(image2, "photo3");
                      
                    }
                  },
                  child: Container(
                    height: size.height * 0.2,
                    width: size.width / 3,
                    child: Container(
                      decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(50),
                       border: Border.all(
                       color: Colors.deepOrange, width: 7)
                     ),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                        child: image2 != null ? Image.file(
                                image2,
                                fit: BoxFit.cover,
                              )
                            : Image.asset("assets/images/addImage.jpg"),
                      ),
                    ),
    
                  ),

          ),
              ),

              Container(
                height: size.height * 0.2,
                width: size.width / 3,
                child: GestureDetector(
                  onTap: () async {
                    File getPic = await FilePicker.getFile(type: FileType.image);

                    if (getPic != null ) {
                      //await compressImage();
                      image3 = getPic;
                      setState(() {
                        image3 = image3;
                      });

                      await uploadImage(image3, "photo3");
                      
                    }
                  },
                  child: Container(
                    height: size.height * 0.2,
                    width: size.width / 3,
                    child: Container(
                      decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(50),
                       border: Border.all(
                       color: Colors.deepOrange, width: 7)
                     ),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                        child: image3 != null ? Image.file(
                                image3,
                                fit: BoxFit.cover,
                              )
                            : Image.asset("assets/images/addImage.jpg"),
                      ),
                    ),
    
                  ),

          ),
              ),
            ],
          ),
          );

      break;

      case 2: 
      return Container(
          height: size.height,
          width: size.width,
          child: Wrap(
            direction: Axis.vertical,
            children: <Widget>[
              Container(
                height: size.height * 0.2,
                width: size.width / 3,
                child: GestureDetector(
                  onTap: () async {
                    File getPic = await FilePicker.getFile(type: FileType.image);

                    if (getPic != null ) {
                      //await compressImage();
                      image1 = getPic;
                      setState(() {
                        image1 = image1;
                      });

                      await uploadImage(image1, "photo2");
                      
                    }
                  },
                  child: Container(
                    height: size.height * 0.2,
                    width: size.width / 3,
                    child: Container(
                      decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(50),
                       border: Border.all(
                       color: Colors.deepOrange, width: 7)
                     ),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                        child: image1 != null ? Image.file(
                                image1,
                                fit: BoxFit.cover,
                              )
                            : Image.asset("assets/images/addImage.jpg"),
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                height: size.height * 0.2,
                width: size.width / 3,
                child: GestureDetector(
                  onTap: () async {
                    File getPic = await FilePicker.getFile(type: FileType.image);

                    if (getPic != null ) {
                      //await compressImage();
                      image2 = getPic;
                      setState(() {
                        image2 = image2;
                      });

                      await uploadImage(image2, "photo3");
                      
                    }
                  },
                  child: Container(
                    height: size.height * 0.2,
                    width: size.width / 3,
                    child: Container(
                      decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(50),
                       border: Border.all(
                       color: Colors.deepOrange, width: 7)
                     ),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                        child: image2 != null ? Image.file(
                                image2,
                                fit: BoxFit.cover,
                              )
                            : Image.asset("assets/images/addImage.jpg"),
                      ),
                    ),
    
                  ),

          ),
              ),
            ],
          ),
      );


      break;
      case 3:
      return Container(
          height: size.height,
          width: size.width,
          child: Wrap(
            direction: Axis.vertical,
            children: <Widget>[
              Container(
                height: size.height * 0.2,
                width: size.width / 3,
                child: GestureDetector(
                  onTap: () async {
                    File getPic = await FilePicker.getFile(type: FileType.image);

                    if (getPic != null ) {
                      //await compressImage();
                      image1 = getPic;
                      setState(() {
                        image1 = image1;
                      });

                      await uploadImage(image1, "photo2");
                      
                    }
                  },
                  child: Container(
                    height: size.height * 0.2,
                    width: size.width / 3,
                    child: Container(
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(50),
                       border: Border.all(
                       color: Colors.deepOrange, width: 7)
                     ),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                          
                        
                        ),
                      
                        
                        child: image1 != null ? Image.file(
                                image1,
                                fit: BoxFit.cover,
                              )
                            : Image.asset("assets/images/addImage.jpg"),
                      ),
                                          
                    ),
                  ),
                ),
              ),
            ],
          ),
      );



      break;
      default:
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: GoogleFonts.roboto(
              color: Colors.black, fontWeight: FontWeight.bold),
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
      body: Container(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
                  child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 15, right: 300),
                child: Text(
                  "Photos",
                  style: GoogleFonts.roboto(
                      color: Colors.deepOrange,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: size.height * 0.2,
                width: size.width / 3,
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
                              widget.currentUser.photo,
                              fit: BoxFit.cover,
                            )
                          : Image.file(photo),
                    ),
                  ),
                ),
              ),
              GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  shrinkWrap: true,
                  itemCount: widget.images.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        File getPic =
                            await FilePicker.getFile(type: FileType.image);

                        if (getPic != null && widget.images[index] != null) {
                          //await compressImage();
                          if (index == 0) {
                            photo1 = getPic;
                            setState(() {
                              tapped[0] = !tapped[0];
                            });
                            replacedPhotos.add(photo1);
                            await uploadImage(photo1, "photo2");
                          } else if (index == 1) {
                            photo2 = getPic;
                            setState(() {
                              tapped[1] = !tapped[1];
                            });
                            replacedPhotos.add(photo2);
                            await uploadImage(photo2, "photo3");
                          } else if (index == 2) {
                            photo3 = getPic;

                            setState(() {
                              tapped[2] = !tapped[2];
                            });
                            replacedPhotos.add(photo3);
                            await uploadImage(photo3, "photo4");
                          } else {
                            photo4 = getPic;
                            setState(() {
                              tapped[3] = !tapped[3];
                            });
                            replacedPhotos.add(photo4);
                            await uploadImage(photo4, "photo5");
                          }
                        }
                      },
                      child: Container(
                        height: size.height * 0.2,
                        width: size.width / 3,
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                            child: tapped[index] == false
                                ? Image.network(
                                    widget.images[index],
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(replacedPhotos[index]),
                          ),
                        ),
                      ),
                    );
                  }),

                  buildImageHolder(widget.images),
            ],
          ),
        ),
      ),
    );
  }
}

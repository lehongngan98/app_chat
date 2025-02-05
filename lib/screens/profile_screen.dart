import 'dart:developer';

import 'package:app_chat/api/apis.dart';
import 'package:app_chat/helper/dialogs.dart';
import 'package:app_chat/main.dart';
import 'package:app_chat/models/chat_user.dart';
import 'package:app_chat/screens/auth/login_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Logout function
  Future<void> _logout() async {
    await APIs.auth.signOut();
    await GoogleSignIn().signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiring keyboard
      onTap: () => FocusScope.of(context).unfocus(),

      child: Scaffold(
          // app bar
          appBar: AppBar(
            title: const Text('Profile Screen'),
          ),

          // Floating action button to add new user
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton.extended(
                onPressed: () async {
                  _logout();
                },
                icon: Icon(Icons.logout),
                label: Text('Logout')),
          ),

          // body
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // for adding space
                    SizedBox(
                      width: mq.width,
                      height: mq.height * .02,
                    ),

                    // user profile image
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(mq.height * .1),
                          child: CachedNetworkImage(
                            imageUrl: widget.user.image ?? '',
                            height: mq.height * .15,
                            width: mq.height * .15,
                            fit: BoxFit.fill,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) => CircleAvatar(
                                child: Icon(CupertinoIcons.person)),
                          ),
                        ),

                        // edit image button
                        Positioned(
                          bottom: -10,
                          right: -10,
                          child: MaterialButton(
                            onPressed: () {},
                            color: Colors.white,
                            shape: CircleBorder(),
                            elevation: 1,
                            child: Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.blue,
                            ),
                          ),
                        )
                      ],
                    ),

                    // for adding space
                    SizedBox(
                      height: mq.height * .02,
                    ),

                    // user email
                    Text(
                      widget.user.email ?? '',
                      style: TextStyle(color: Colors.black87, fontSize: 20),
                    ),

                    SizedBox(
                      height: mq.height * .05,
                    ),

                    // TextFormField for user name
                    TextFormField(
                      initialValue: widget.user.name ?? '',
                      onSaved: (val) {
                        if (val != null) {
                          APIs.me.name = val;
                        }
                      },
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: 'eg. Lee Min Ho',
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: mq.height * .02,
                    ),

                    // TextFormField for user about
                    TextFormField(
                      initialValue: widget.user.about ?? '',
                      onSaved: (val) {
                        if (val != null) {
                          APIs.me.about = val;
                        }
                      },
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.info_outline_rounded),
                        hintText: 'eg. Felling good',
                        labelText: 'About',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: mq.height * .05,
                    ),

                    // button to update user profile
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            minimumSize: Size(mq.width * .4, mq.height * .055),
                            backgroundColor:
                                const Color.fromARGB(255, 13, 146, 247)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            log('Inside validator');
                            log('Updated name: ${APIs.me.name}');
                            log('Updated about: ${APIs.me.about}');
                            APIs.updateUserInfo().then((value){
                              Dialogs.showSnackbar(context, "Profile Update Successfully!");
                            });
                          }
                        },
                        icon: Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.white,
                        ),
                        label: const Text('Update',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white))),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

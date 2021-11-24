
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lbp/model/hive/user/User.dart';

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> with WidgetsBindingObserver {
  User user;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getUser();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getUser();
    }
  }
  
  void getUser() async {
    Box<User> box;
    var isBoxOpened = Hive.isBoxOpen("userBox");
    if (isBoxOpened) {
      box = Hive.box("userBox");
    } else {
      box = await Hive.openBox("userBox");
    }
    var retrievedUser = box.get("user");
    setState(() {
      user = retrievedUser;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          backgroundColor: Colors.black,
          // systemOverlayStyle: SystemUiOverlayStyle.dark,
          brightness: Brightness.dark,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: ListView(
              children: [
                buildProfileImage(),
                SizedBox(height: 24),
                buildName(user),
                SizedBox(height: 24),
                buildAbout(),
              ],
            ),
          ),
        ));
  }
  
  Widget buildProfileImage() {
    return Center(
      child: Stack(
        children: [
          buildImage(),
          // buildEditIcon(),
        ],
      ),
    );
  }
  
  Widget buildImage() {
    final image = NetworkImage("https://picsum.photos/250?image=9");
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
            image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: () => 
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              ),
          ),
        ),
      ),
    );
  }

  Widget buildName(User user) {
    return Column(
      children: [
        Text(
          user.nickname,
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 4),
        Text(
          user.gender,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
  
  Widget buildEditIcon() {
    return Positioned(
      bottom: 0,
      right: 4,
      child: ClipOval(
        child: Container(
          padding: EdgeInsets.all(3),
          color: Colors.white,
          child: ClipOval(
            child: Container(
              padding: EdgeInsets.all(8),
              color: Colors.blue,
              child: Icon(
                isEdit ? Icons.add_a_photo : Icons.edit,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAbout() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.aboutMe != null ? 'About me' : '',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 16,),
          Text(
            user.aboutMe ?? "",
            style: TextStyle(fontSize: 16, height: 1.4),
          )
        ],
      ),
    );
  }

}

class EditProfileScreen extends StatefulWidget {
  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  User user;
  String nickname;
  String aboutMe;
  Box<User> box;

  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    var isBoxOpened = Hive.isBoxOpen("userBox");
    if (isBoxOpened) {
      box = Hive.box("userBox");
    } else {
      box = await Hive.openBox("userBox");
    }
    var retrievedUser = box.get("user");
    setState(() {
      user = retrievedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
          backgroundColor: Colors.black,
          // systemOverlayStyle: SystemUiOverlayStyle.dark,
          brightness: Brightness.dark,
        ),
        body: Form(
          key: formKey,
          child: ListView(
          padding: EdgeInsets.all(20),
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(height: 24),
            editUsername(),
            SizedBox(height: 24),
            editAboutMe(),
          ],
        ),
        ),
    );
  }

  Widget editUsername() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nickname',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          initialValue: user.nickname ?? "",
          onChanged: (value) {
            if (formKey.currentState.validate()) {
              setState(() {
                nickname = value;
                user.nickname = value;
              });
            }
          },
          validator: (value) {
            return value.length < 5 ? "Nickname must be at least 5 characters long" : null;
          },
        ),
      ],
    );
  }

  Widget editAboutMe() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: 5,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          initialValue: user.aboutMe ?? "",
          onChanged: (value) {
            setState(() {
              aboutMe = value;
              user.aboutMe = value;
            });
          },
        ),
      ],
    );
  }

  void saveUserData() async {
    box.put("user", user);
  }
}
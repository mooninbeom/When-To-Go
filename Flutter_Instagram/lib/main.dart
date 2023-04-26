import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/firebase_options.dart';
import 'package:flutter_instagram/notification.dart';
import 'package:flutter_instagram/shop.dart';
import 'package:flutter_instagram/style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
// import 'firebase_options.dart';

class Store1 extends ChangeNotifier{
  var name = "john kim";
  var follower = 0;
  bool isFollowed = false;
  var profileImage = [];

  getData() async{
    var result = await http.get(Uri.parse("https://codingapple1.github.io/app/profile.json"));
    var result2 = jsonDecode(result.body);
    profileImage = result2;
    // print(profileImage);
    notifyListeners();
  }


  follow(){
    (!isFollowed)?follower++:follower--;
    isFollowed = !isFollowed;
    notifyListeners();
  }
  changeName(){
    name = "john park";
    notifyListeners();
  }
}

class Store2 extends ChangeNotifier{

}

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => Store1(),),
      ChangeNotifierProvider(create: (context) => Store2(),),
    ],
    child: MaterialApp(
      home: const MyApp(),
      theme: style.theme,
    ),
  )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tap = 0;
  var result = [];
  var userImage;


  // saveData() async{
  //   var storage = await SharedPreferences.getInstance();
  // }

  bool isLoading = false;

  getData() async {
    var data = await http.get(Uri.parse("https://codingapple1.github.io/app/data.json"));
    if(data.statusCode==200){
      isLoading = true;
      result = jsonDecode(data.body);
      // print(result);
      // print(result.runtimeType);
      setState(() {
      });
    }
    // print(result);
  }

  addPost(a){
    result.add(a);
  }
  uploadPost(a){
    setState(() {
      result.insert(0, a);
    });
  }

  @override
  void initState(){
    getData();
    initNotification(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text("+"),
        onPressed: (){showNotification2();},
      ),
      appBar: AppBar(
        leadingWidth: 160,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Instagram"),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(onPressed: ()async{

              Navigator.push(context,
                MaterialPageRoute(builder: (context)=>upload(addPost : uploadPost, len:result.length),)
              );
              },
                icon:const Icon(Icons.add_box_outlined)),
          ),
        ],
      ),
      body: isLoading?[post(result: result, addPost: addPost,), Shop()][tap]: const Center(child: CircularProgressIndicator(),),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i){setState(() {
          tap = i;
        });},
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "홈",),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: "샵"),
        ],
      )
    );
  }
}



class post extends StatefulWidget {
  post({
    super.key,
    this.result,
    this.addPost,
  });

  var result;
  var addPost;

  @override
  State<post> createState() => _postState();
}

class _postState extends State<post> {

  var scroll = ScrollController();
  var moreDecode;
  bool isMoreLoading = false;
  var count = 1;

  getMoreData() async{
    var moreData = await http.get(Uri.parse("https://codingapple1.github.io/app/more${count}.json"));
    if(moreData.statusCode==200){
      moreDecode = jsonDecode(moreData.body);
      isMoreLoading = true;
      count++;
    }
  }

  @override
  void initState() {
    super.initState();
    scroll.addListener(() {
      if(scroll.position.pixels == scroll.position.maxScrollExtent){
        getMoreData();
        if(isMoreLoading){
          // print("Plus!");
          widget.addPost(moreDecode);
          isMoreLoading = !isMoreLoading;
        }
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scroll,
      itemCount: widget.result.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            (widget.result[index]["image"].runtimeType== String)?
            Image.network(widget.result[index]["image"]):
                Image.file(widget.result[index]["image"]),
            Container(
              padding: const EdgeInsets.all(20),
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("좋아요 : ${widget.result[index]["likes"]}", style: const TextStyle(fontWeight: FontWeight.bold),),
                  GestureDetector(
                      child: Text("${widget.result[index]["user"]}"),
                      onTap: () {
                        Navigator.push(context,PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => Profile(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                              FadeTransition(opacity: animation, child: child,)

                        )
                        );
                      },),
                  Text("${widget.result[index]["date"]}"),
                  Text("${widget.result[index]["content"]}"),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class upload extends StatelessWidget {
  upload({Key? key, this.addPost, this.len}) : super(key: key);

  var addPost;
  var userImage;
  var len;

  var userName = TextEditingController();

  var userContents = TextEditingController();

  var uploadList = {};

  var path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
           children: [
             IconButton(onPressed: ()async{
               var picker = ImagePicker();
               var image = await picker.pickImage(source: ImageSource.gallery);
               path = File(image!.path);
             },
               icon: const Icon(Icons.photo_camera),
               color: Colors.black,
             ),
             const SizedBox(height: 20,),
             TextField(
               controller: userName,
               decoration: const InputDecoration(
               border: OutlineInputBorder(),
               labelText: "User Name"
             ),),
             const SizedBox(height: 20,),
             TextField(
               controller: userContents,
               decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Contents",
               ),
             ),
             const SizedBox(height: 20,),

             TextButton(onPressed: (){
                 uploadList = {
                   "user": userName.text,
                   "content": userContents.text,
                   "image": path,
                   "id" : len,
                   "likes" : 5,
                   "liked": false,
                   "date": "July 25",
                 };

                 // print(uploadList);
                 addPost(uploadList);
                 Navigator.pop(context);
              }, child: const Text("Submit"),
             ),


           ],
          )
        ],
      )
    );
  }
}

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.watch<Store1>().name),),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ProfileHeader(),
          ),
          SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Image.network(context.watch<Store1>().profileImage[index]),
                childCount: context.watch<Store1>().profileImage.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          ),
        ],
      )
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircleAvatar(
          child: Image.asset("assets/pepe.png"),
          radius: 30,
          backgroundColor: Colors.grey,


        ),
        Text("팔로워 ${context.watch<Store1>().follower}명"),
        ElevatedButton(onPressed: (){
            context.read<Store1>().follow();
          }, child: (!context.watch<Store1>().isFollowed)?const Text("Follow"):const Text("Unfollow")),
        ElevatedButton(onPressed: (){
          context.read<Store1>().getData();
          }, child: Text("사진가져오기")),
      ],
    );
  }
}



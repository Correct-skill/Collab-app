import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:productivityapp/helper/authenticate.dart';
import 'package:productivityapp/helper/constants.dart';
import 'package:productivityapp/helper/helperfunctions.dart';
import 'package:productivityapp/services/auth.dart';
import 'package:productivityapp/services/database.dart';
import 'package:productivityapp/views/DashboardScreen.dart';
import 'package:productivityapp/views/animation/FadeAnimation.dart';
import 'package:productivityapp/views/createTeams.dart';
import 'package:productivityapp/views/search_add_members.dart';
import 'package:productivityapp/views/teams_dashboard_screen.dart';
import 'package:productivityapp/widgets/widget.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'animation/animated_button.dart';
import 'constants_color.dart';

class SearchScreen_addMembers extends StatefulWidget {
  @override
  _SearchScreen_addMembersState createState() => _SearchScreen_addMembersState();
}

class _SearchScreen_addMembersState extends State<SearchScreen_addMembers> {
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  TextEditingController SearchTextEditingController = new TextEditingController();

  QuerySnapshot searchSnapsot;

  initiateSearch(){
    dataBaseMethods.getUserByUsername(SearchTextEditingController.text)
        .then((val){
      setState(() {
        searchSnapsot = val;
      });

    });
  }

  AddMembertoTeam(String Email ){
    dataBaseMethods.addUsertoTeamAndChatRoom(Constants.Teamroomid, [Email]);
  }
  Widget searchList(){
    return searchSnapsot != null ? Expanded(
      child: ListView.builder(
          itemCount:searchSnapsot.documents.length ,
          shrinkWrap: true,

          itemBuilder: (context,index){

            return SearchTile(
              userName: searchSnapsot.documents[index].data["name"],
              userEmail: searchSnapsot.documents[index].data["email"],
            ) ;
          }),
    ) : Container();
  }

  @override
  void initState() {

    super.initState();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gradientEndColor,
      appBar: AppBar(backgroundColor: gradientStartColor,elevation: 0,iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.white,),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [gradientStartColor, gradientEndColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.3, 0.7])),

        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left:8.0,right: 8.0),
              child: Container(

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),

                  borderRadius: BorderRadius.all(Radius.circular(100))
                ),

                padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),

                child: Row(
                  children: <Widget>[
                      Expanded(
                          child: TextField(
                            controller: SearchTextEditingController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                            hintText: "username",
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                          ),)
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child:  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: (){

                                  initiateSearch();


                              },
                              child: Icon(Icons.search,color: Colors.white,),
                          ),
                        ),

                        ),

                  ],

                ),
              ),
            ), //searchBox
            SizedBox(height: 5,),
            searchList()
          ],
        ),
      ),
    );
  }
}
class SearchTile extends StatelessWidget {
  final String userName;
  final String userEmail;
  SearchTile({this.userName,this.userEmail});
  @override
  Widget build(BuildContext context) {
    return FadeAnimation(1.3,
      Padding(
        padding: const EdgeInsets.only(left: 8,right: 8,bottom: 8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(100),
            
          ),
          child: Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(userName, style: TextStyle(fontSize: 15.0,color: Colors.white),),
                  Text(userEmail,style: TextStyle(fontSize: 15.0,color: Colors.white),)

                ],
              ),
              Spacer(),
              AnimatedButton(
                onTap: () {
                    AddMembertoTeam(userEmail);
                },
                animationDuration: const Duration(milliseconds: 2000),
                initialText: "Confirm",
                finalText: "",
                iconData: Icons.check,
                iconSize: 26.0,
                buttonStyle: ButtonStyle(
                  primaryColor: Colors.white.withOpacity(0.2),
                  secondaryColor: Colors.white.withOpacity(0.2),
                  buttoncolor: Colors.blue,
                  elevation: 5.0,
                  initialTextStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.blue,
                  ),
                  finalTextStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.blue,
                  ),
                  borderRadius: 30.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void AddMembertoTeam(String userEmail) {

    DataBaseMethods dataBaseMethods = new DataBaseMethods();
    dataBaseMethods.addUsertoTeamAndChatRoom(Constants.Teamroomid, [userEmail]);

  }
}

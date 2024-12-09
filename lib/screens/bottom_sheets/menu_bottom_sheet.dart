import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

import '../../assets/app_colors.dart';

class MenuBottomSheet extends StatefulWidget {
  const MenuBottomSheet({super.key});

  @override
  StateX<MenuBottomSheet> createState() => _MenuBottomSHeetState();
}

class _MenuBottomSHeetState extends StateX<MenuBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: [
          Column(
            children: [
              SizedBox(height: 5,),
              Container(
                width: double.infinity,
                child: Stack(
                  children: [
                    Center(child: Text("Menu", style: TextStyle(fontSize: 18, color: AppColors.black),)),
                    Positioned(top:0, right: 0,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0.0,0.0,8.0,0.0),
                          child: GestureDetector(child: Icon(Icons.close),
                            onTap: (){
                              Navigator.pop(context);
                            },),
                        ))
                  ],
                ),
              ),
              ListTile(title: Text("Picks")),
              ListTile(title: Text("News")),
              ListTile(title: Text("Teams")),
              ListTile(title: Text("MatchUps")),
              ListTile(title: Text("Injuries")),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sahayak_ui/screens/home/homescreen.dart';


class Notes extends StatelessWidget {
  Notes({super.key});
  final List<Map<String, String>> notes =[
    {
      "title":"Quantum Physics lecture",
      "subtitle": "Lecture notes on quantum physics"
    },
    {
      "title": "Project Kickoff Notes",
      "subtitle":"Meeting notes from project kickoff"
    },
    {
      "title": "Client Feedback Notes",
      "subtitle":"Notes from client feedback session"
    },
    {
      "title": "Marketing Campaign Ideas",
      "subtitle":"Ideas for the new marketing campaign"
    },
    {
      "title": "Gatsby Essay Outline ",
      "subtitle":"Essay outline for 'The Great Gatsby' "
    },
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(onPressed: () =>
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen())),
        icon: Icon(Icons.arrow_back,
        color: Colors.black,
        size: 30,),
        ),
        title: Text('Notes',
        style: TextStyle(
          color: Color(0xFF000000),
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),),
        centerTitle: true,
        actions: [
          IconButton(
          onPressed: (){}, 
          icon: Icon(Icons.add,
          color: Color(0xFF000000),
          size: 30,
          ),
          )
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Positioned(
              bottom: -100,
              left: 0,
              right: 0,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Color(0xFFD6C1F0),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.elliptical(500,200),
                  )
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFFAF7FC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search notes',
                      prefixIcon: Icon(Icons.search,
                      color: Colors.black45,),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                      )
                    ),
                  ),
                  SizedBox(height: 20,),
                  ListView.builder(
                    itemCount: notes.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index){
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 4),
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset('assets/images/notes.png',
                        height: 30,),
                      ),
                      title: Text(
                        notes[index]['title']!,
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w800,
                          fontSize: 13
                        ),
                      ),
                      subtitle: Text(
                        notes[index]['subtitle']!,
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 11
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          )
        ],
      ),
    );  
  }
  }
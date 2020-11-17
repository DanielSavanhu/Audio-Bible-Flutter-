import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'Bible.dart';
import 'main.dart';

// void main() => runApp(Datas());
class Datas extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return Home();    
  }
}
class Home extends State<Datas>{
  Bible bible = Bible();
  String scripture = 'Genesis',search ='Genesis';
  int chapter = 1,chapterselect = 1;
  FlutterTts flutterTts;
  dynamic languages;
  String language,testament = 'old';
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  
  String _newVoiceText ='';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  get isPaused => ttsState == TtsState.paused;

  get isContinued => ttsState == TtsState.continued;
  
  List lst = List();
  String word = '';

  @override
  void initState() {    
    super.initState();
    initTts();  
    scriptures.forEach((element) {
      if(element.name==scripture){
        chapter = element.chapters; 
      }    
    });
  }
   initTts() {
    flutterTts = FlutterTts();

    _getLanguages();

    if (!kIsWeb) {
      if (Platform.isAndroid) {
        _getEngines();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    
    
    return Scaffold(
      body:Scaffold(
        appBar: AppBar(
          title: Text('Audio Bible'),
        ),
        body:  Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  color: testament=='old'? Colors.blue:Colors.white,
                  onPressed:()=>setState(()=>testament = 'old',),
                  child:Text('Old Testament')
                ),
                FlatButton(
                  color: testament=='new'? Colors.blue:Colors.white,
                  onPressed:()=>setState(()=>testament = 'new',),
                  child:Text('New Testament')
                ),
              ]
            ),
            Text("$scripture $chapterselect",textScaleFactor: 1.5,),
            Row(
              children: [
                Container(
                  height:MediaQuery.of(context).size.height*.35,
                  width: MediaQuery.of(context).size.width*.5,
                  child:ListView.builder(
                    itemBuilder: (_,x){
                      return Container(
                        height:40,
                        child: FlatButton(                            
                          child: Text(bible.scripture(testament)[x].name,textScaleFactor: 1.5,),
                          onPressed: (){
                            setState((){
                              List lst = List();
                              lst.clear();
                              scripture = bible.scripture(testament)[x].name;        
                              scriptures.forEach((element) {
                                if(element.name==scripture){
                                  chapter = element.chapters; 
                                }    
                              });
                            });                                      
                          },
                        )
                      );
                    },
                    itemCount:bible.scripture(testament).length
                  )
                ),
                Container(
                  height:MediaQuery.of(context).size.height*.35,
                  width: MediaQuery.of(context).size.width*.5,
                  child:ListView.builder(
                    itemBuilder: (_,x){
                      
                      return Container(
                        height:40,
                        child: FlatButton(                            
                          child: Text((x+1).toString(),textScaleFactor: 1.5,),
                          onPressed: (){
                            setState(() {                                        
                              chapterselect = x+1;
                              
                            });
                          },
                        )
                      );
                    },
                    itemCount: chapter,
                  )
                ),                          
              ],
            ),
            Expanded(                      
              child:SingleChildScrollView (child:Text(word, textScaleFactor: 2,),)
            ),
            
            _btnSection(),
            // languages != null ? _languageDropDownSection() : Text(""),
            // _buildSliders()

          ]
        )          
      )
    );    
  }

  Future _speak() async {
    // await flutterTts.setVolume(volume);
    // await flutterTts.setSpeechRate(rate);
    // await flutterTts.setPitch(pitch);
      // _newVoiceText = 'run';
      List lsts = List();
      List lstser = List();
      bible.verses(scripture, chapterselect, context).then((value) {
        lstser.addAll(value);
      }).then((value) {
        lstser.forEach((element) {
          if(element.toString().contains("$scripture $chapterselect:")){            
            lsts.add(element);
          }
        });
      }).whenComplete(() async{
        int i =0;                                       
        await flutterTts.awaitSpeakCompletion(true);
        setState(() {
          word = lsts[i];
        });
        await flutterTts.speak(lsts.first.toString());            
        
        flutterTts.setCompletionHandler(()async {
          if(i < lsts.length){
            i++;
            setState(() {
              word = lsts[i];  
            });            
            await flutterTts.speak(lsts[i].toString());
          }            
        });                      
      });
      
      
    
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }
   Widget _btnSection() {
    if (!kIsWeb && Platform.isAndroid) {
      return Container(
          padding: EdgeInsets.only(top: 50.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _buildButtonColumn(Colors.green, Colors.greenAccent,
                Icons.play_arrow, 'PLAY', _speak),
            // _buildButtonColumn(
            //     Colors.red, Colors.redAccent, Icons.pause, 'PAUSE', _pause),
            _buildButtonColumn(
                Colors.red, Colors.redAccent, Icons.stop, 'STOP', _stop),
          ]));
    } else {
      return Container(
          padding: EdgeInsets.only(top: 50.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _buildButtonColumn(Colors.green, Colors.greenAccent,
                Icons.play_arrow, 'PLAY', _speak),
            _buildButtonColumn(
                Colors.red, Colors.redAccent, Icons.stop, 'STOP', _stop),
            _buildButtonColumn(
                Colors.blue, Colors.blueAccent, Icons.pause, 'PAUSE', _pause),
          ]));
    }
  }

  Column _buildButtonColumn(Color color, Color splashColor, IconData icon,
      String label, Function func) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              icon: Icon(icon),
              color: color,
              splashColor: splashColor,
              onPressed: () => func()),
          Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: Text(label,
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: color)))
        ]);
  }


  List<Scripture> scriptures = [ 
    Scripture(name: "Genesis",chapters:50 ),Scripture(name: "Exodus",chapters:40 ),
    Scripture(name: "Leviticus",chapters:27 ),Scripture(name: "Numbers",chapters:36 ),
    Scripture(name:"Deuteronomy" ,chapters:34 ),Scripture(name: "Joshua",chapters:24 ),
    Scripture(name: "Judges",chapters:21),Scripture(name: "Ruth",chapters:4 ),
    Scripture(name: "1 Samuel",chapters:31 ),Scripture(name:"2 Samuel",chapters:24 ),
    Scripture(name:"1 Kings" ,chapters:22 ),Scripture(name:"2 Kings" ,chapters:25 ),
    Scripture(name: "1 Chronicles",chapters:29 ),Scripture(name: "2 Chronicles",chapters:36 ),
    Scripture(name:"Ezra" ,chapters:10 ),Scripture(name: "Nehemiah",chapters:13 ),
    Scripture(name: "Esther",chapters:10),Scripture(name: "Job",chapters:42 ),
    Scripture(name: "Psalm",chapters:150 ),Scripture(name: "Proverbs",chapters:31 ),
    Scripture(name: "Ecclesiastes",chapters:12 ),Scripture(name: "Song of Solomon",chapters:8 ),
    Scripture(name: "Isaiah",chapters:66 ),Scripture(name: "Jeremiah",chapters:52),
    Scripture(name: "Lamentations",chapters:5 ),Scripture(name: "Ezekiel",chapters:48 ),
    Scripture(name: "Daniel",chapters:12),Scripture(name: "Hosea",chapters:14 ),
    Scripture(name: "Joel",chapters:3),Scripture(name: "Amos",chapters:9),
    Scripture(name: "Obadiah",chapters:1),Scripture(name:"Jonah" ,chapters:4),
    Scripture(name:"Micah" ,chapters:7 ),Scripture(name: "Nahum",chapters:3),
    Scripture(name: "Habakkuk",chapters:3 ),Scripture( name: "Zephaniah",chapters:3 ),
    Scripture(name:"Haggai" ,chapters:2 ),
    Scripture(name:"Zechariah" ,chapters:14 ),Scripture(name:"Malachi",chapters:4 ),
    
    Scripture(name:"Matthew" ,chapters:28 ),Scripture(name:"Mark" ,chapters:16 ),
    Scripture(name: "Luke",chapters:24 ),Scripture(name: "John",chapters:21 ),
    Scripture(name: "Acts",chapters:28 ),Scripture(name: "Romans",chapters:16 ),
    Scripture(name: "1 Corinthians",chapters:16 ),Scripture(name: "2 Corinthians",chapters:13),
    Scripture(name: "Galatians",chapters:6),Scripture(name: "Ephesians",chapters:6 ),
    Scripture(name:"Philippians" ,chapters:4 ),Scripture(name: "Colossians",chapters:4),
    Scripture(name: "1 Thessalonians",chapters:5 ),Scripture(name:"2 Thessalonians" ,chapters:3 ),
    Scripture(name: "1 Timothy",chapters:6 ),Scripture(name: "2 Timothy",chapters:4 ),
    Scripture(name:"Titus" ,chapters:3),Scripture(name:"Philemon" ,chapters:1),
    Scripture(name: "Hebrews",chapters:13 ),Scripture(name: "James",chapters:5 ),
    Scripture(name: "1 Peter",chapters:5 ),Scripture(name: "2 Peter",chapters:3 ),
    Scripture(name: "1 John",chapters:5 ),Scripture(name: "2 John",chapters:1),
    Scripture(name: "3 John",chapters:1 ),Scripture(name: "Jude",chapters:1 ),
    Scripture(name: "Revelation",chapters:22 ),
  ];
    Future _getLanguages() async {
      languages = await flutterTts.getLanguages;
      if (languages != null) setState(() => languages);
    }

  Future _getEngines() async {
    var engines = await flutterTts.getEngines;
    if (engines != null) {
      for (dynamic engine in engines) {
        print(engine);
      }
    }
  }

}
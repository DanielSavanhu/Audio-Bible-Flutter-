import 'package:flutter/material.dart';
class Scripture{
  String name;
  int chapters;
  Scripture({this.name, this.chapters});

}
class Bible{
  List<Scripture> newtestament = [ 
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

  List<Scripture> oldtestament = [ 
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
  ];
  
  List<Scripture> scripture(neworold){
    return neworold=='old'?oldtestament :newtestament;
    
  }

  Future<List> verses(scripture,chapter,context)async{        
    return (await DefaultAssetBundle.of(context).loadString('assets/Bible/$scripture.txt')).split('\n');    
  }

  int chapters(scripture,neworold){
    if (neworold=='old'){
      if(oldtestament.contains(scripture)){
        return oldtestament[oldtestament.indexOf(scripture)].chapters;
      }      
    }else{
      if(newtestament.contains(scripture)){
        return newtestament[newtestament.indexOf(scripture)].chapters;
      }
    }                  
  }

}
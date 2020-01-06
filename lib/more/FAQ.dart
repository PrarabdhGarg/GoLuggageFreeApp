import 'package:flutter/material.dart';
import 'package:go_luggage_free/more/ContactUs.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';

class Question {
  String question;
  String answer;

  Question({
    this.question,
    this.answer
  });
}

class FAQ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FAQ", style: Theme.of(context).textTheme.title,),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,),
          onPressed:() => Navigator.pop(context, false)
        ),
        actions: <Widget>[
          Container(
              margin: EdgeInsets.only(left: 8.0),
              child: Center(
                  child: Text("Need Help?", style: Theme.of(context).textTheme.body1.copyWith(color: Colors.black),)
              )
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              child: Center(child: Text("Contact Us", style: Theme.of(context).textTheme.body1.copyWith(color: Colors.blue[900]),)),
              onTap: () async {
                /* print("Entered onTap");
                String phoneNumber = "+917854866007";
                String url = "whatsapp://send?phone=$phoneNumber";
                await canLaunch(url) ? launch(url) : launch("tel://$phoneNumber"); */
                // await FlutterLaunch.launchWathsApp(phone: "8369276419", message: "");
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactUs(), settings: RouteSettings(name: "Contact Us Page")));
              },
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: faqs.length,
          itemBuilder: (context, index) => Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(4.0),
                child: Text(faqs[index].question, style: Theme.of(context).textTheme.headline, textAlign: TextAlign.left,),
              ),
              Container(
                padding: EdgeInsets.all(4.0),
                child: Text(faqs[index].answer, style: Theme.of(context).textTheme.body1, textAlign: TextAlign.left,),
              )
            ],
          ),
        ),
      ),
    );
  }
}
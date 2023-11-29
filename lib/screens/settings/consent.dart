
import 'package:flutter/material.dart';

class ConsentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User consent agreement"),
        backgroundColor: Color(0xff000000),
        // systemOverlayStyle: SystemUiOverlayStyle.dark,
        brightness: Brightness.dark,
      ),
      body: SingleChildScrollView(
        child:
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("USER AGREEMENT", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800)),
              SizedBox(height: 5),
              Text("Last updated: May 19, 2022"),
              SizedBox(height: 25),

              Text("Research Consent", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("This user agreement document is part of the process of informed consent. By continuing to use this app, the user consents to their data being collected, stored and processed for the purposes of research. Further, by participating in the daily auction, the user consents to their data being shared with a third party should the user win an auction. Only the unit of data that the user sells during the auction (should they win the auction) will be shared with the third party. The third-party could be in the form of 1) the government, 2) an academic researcher, or 3) a for-proffit company. If you would like more detail about something mentioned here, or information not included here, please ask. Please take the time to read this carefully and to understand any accompanying information."),
              SizedBox(height: 15),

              Text("Research Project Title", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("Understanding the Relationship Between Sleep and Low Back Pain and the monetary value attached to such data"),
              SizedBox(height: 15),

              Text("Researchers", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("Andy Alorwu, Aku Visuri, Simo Hosio"),
              SizedBox(height: 15),

              Text("Study Purpose", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("The purpose of this study is to investigate the relationship between sleep and Low Back Pain. Researchers involved in the design of interventions for sleep and Low Back Pain can benefit from this study."),
              SizedBox(height: 15),

              Text("Data Collection", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text('''This study will last for a period of 14 days from the day the user installs the application. Data you enter in the app will be collected for analysis. No personal information is collected about you. All data is collected anonymously. Your data will not be shared with third parties except the unit of data you willingly sell during an auction (only if you win the auction). 
              We will collect data from you through a daily in-app questionnaire, and the daily auction should you partake in it. All this is done anonymously. You cannot be identified personally in any way. The data will be stored remotely and securely using cloud services.'''),
              SizedBox(height: 15),

              Text("Data Archiving/Destruction", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("Data will be kept securely. The investigator will destroy study data after the research. This will be at the end of the research project when results are fully reported and disseminated."),
              SizedBox(height: 15),

              Text("Confidentiality", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("Confidentiality and participant anonymity will be strictly maintained. All information gathered will be used for statistical analysis only and no identifying characteristics will be stated in the final or any other reports as we won't have any identifying information in the first place."),
              SizedBox(height: 15),

              Text("Likelihood of Discomfort", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("There is no likelihood of risk associated with participation."),
              SizedBox(height: 15),

              Text("Agreement", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("By proceeding to use this application, you indicate that you have understood to your satisfaction the information regarding participation in the research study by the use of this mobile application and agree to take part as a participant. In no way does this waive your legal rights nor release the investigators, sponsors, or involved institutions from their legal and professional responsibilities. You are free to not answer specific items or questions on questionnaires. You are free to withdraw from the study at any time without penalty. "
                  "Your continued participation should be as informed as your initial consent, so you should feel free to ask for clarification or new information throughout your use of this application. If you have further questions concerning matters related to this research, please contact the researchers."),
              SizedBox(height: 15)

            ],
          ),
        ),
      ),
    );
  }

}
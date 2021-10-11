

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
              Text("Last updated 25.05.2021"),
              SizedBox(height: 25),

              Text("Research Consent", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("This user agreement document is part of the process of informed consent. It should give you the basic idea of what the research is about and what your participation will involve. If you would like more detail about something mentioned here, or information not included here, please ask. Please take the time to read this form carefully and to understand any accompanying information."),
              SizedBox(height: 15),

              Text("Research Project Title", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("Understanding the Relationship Between Sleep, Sleep Quality, and Low Back Pain"),
              SizedBox(height: 15),

              Text("Researchers", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("Andy Alorwu, Aku Visuri, Simo Hosio"),
              SizedBox(height: 15),

              Text("Supervisor", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("Associate Professor Simo Hosio"),
              SizedBox(height: 15),

              Text("Experiment Purpose", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("The purpose of this experiment is to investigate if daily sleep and sleep quality have an effect on Low Back Pain and vice versa. Researchers and software companies involved in the design of interventions for sleep and Low Back Pain can benefit from this experiment."),
              SizedBox(height: 15),

              Text("Participant Recruitment and Selection", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("Participants are recruited through an open call for recruiting participants of all background who are interested in monitoring their own daily sleep quality and Low Back Pain."),
              SizedBox(height: 15),

              Text("Experiment Procedure & Data Collection", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text('''This study will last approximately 8 weeks with an optional extension. We will collect data using two data collection methods. Outside of collecting your email address to match data from multiple sources we will not collect any private or personal information of you. Your data will not be shared with third parties. If you decide to not finish the experiment you have the option to request your data to be deleted.  
                  We will collect data from you through a daily in-app questionnaire, and two separate in-app monthly questionnaires. The data will be stored remotely and securely using cloud services. If you use an Oura ring, you can grant us access to your sleep data by providing by following instructions within the app. The Oura application synchronises the sensor data from your Oura ring and stores the information in a secure remote server. 
                  You can access your own data through the Oura smartphone application or through the API provided by Oura. The data is stored anonymously.'''),
              SizedBox(height: 15),

              Text("Data Archiving/Destruction", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("Data will be kept securely. The investigator will destroy study data after the research. This will be at the end of the research project when results are fully reported and disseminated."),
              SizedBox(height: 15),

              Text("Confidentiality", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("Confidentiality and participant anonymity will be strictly maintained. All information gathered will be used for statistical analysis only and no identifying characteristics will be stated in the final or any other reports."),
              SizedBox(height: 15),

              Text("Likelihood of Discomfort", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("There is no likelihood of risk associated with participation."),
              SizedBox(height: 15),

              Text("Participant Responsibilities", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("Your responsibilities as a participant are an effort towards ensuring that data collected for this experiment is not unnecessarily restricted due to negligence or carelessness. If the Oura ring you use for the study is provided by the researchers, then it remains the property of the Crowd Computing Research Group and you should contact the researcher as soon as possible if the ring gets lost or damaged. If the ring use continues after it becomes lost, it is possible to still observe which account uses the ring. In case of ring becoming lost or damaged be prepared to return the charging device."),
              SizedBox(height: 15),

              Text("Agreement", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("By proceeding to use this application after reading this user agreement, you indicate that you have understood to your satisfaction the information regarding participation in the research project by the use of this mobile application and agree to take part as a participant. In no way does this waive your legal rights nor release the investigators, sponsors, or involved institutions from their legal and professional responsibilities. You are free to not answer specific items or questions on questionnaires. You are free to withdraw from the study at any time without penalty. Your continued participation should be as informed as your initial consent, so you should feel free to ask for clarification or new information throughout your participation. If you have further questions concerning matters related to this research, please contact the researcher."),
              SizedBox(height: 15)

            ],
          ),
        ),
      ),
    );
  }

}
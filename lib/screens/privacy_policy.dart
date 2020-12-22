

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrivacyDisclaimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy disclaimer"),
      ),
      body: SingleChildScrollView(
        child:
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("DISCLAIMER / TERMS AND CONDITIONS", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800)),
              SizedBox(height: 5),
              Text("READ THESE TERMS AND CONDITIONS CAREFULLY", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("Last updated 19.11.2020"),
              SizedBox(height: 15),

              Text("AGREEMENT TO TERMS", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("You agree that by using this application, you have read, understood, and agree to be bound by all of these Terms and Conditions Use. IF YOU DO NOT AGREE WITH ALL OF THESE TERMS and CONDITIONS, THEN YOU ARE EXPRESSLY PROHIBITED FROM USING THE APPLICATION AND YOU MUST DISCONTINUE USE IMMEDIATELY. The information provided with the application (LBP Monitor) is not intended for distribution to or use by any person or entity in any jurisdiction or country where such distribution or use would be contrary to law or regulation or which would subject us to any registration requirement within such jurisdiction or country. Accordingly, those persons who choose to access LBP Monitor from other locations do so on their own initiative and are solely responsible for compliance with local laws, if and to the extent local laws are applicable."),
              SizedBox(height: 15),

              Text("INTELLECTUAL PROPERTY RIGHTS", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("Unless otherwise indicated, LBP Monitor is our proprietary property and all source code, databases, functionality, software, website designs, audio, video, text, photographs, and graphics on LBP Monitor (collectively, the “Content”) and the trademarks, service marks, and logos contained therein (the “Marks”) are owned or controlled by us or licensed to us, and are protected by copyright and trademark laws and various other intellectual property rights and unfair competition laws of the United States, foreign jurisdictions, and international conventions. The Content and the Marks are provided on LBP Monitor “AS IS” for your information and personal use only. Except as expressly provided in these Terms of Use, no part of LBP Monitor and no Content or Marks may be copied, reproduced, aggregated, republished, uploaded, posted, publicly displayed, encoded, translated, transmitted, distributed, sold, licensed, or otherwise exploited for any commercial purpose whatsoever, without our express prior written permission. Provided that you are eligible to use LBP Monitor, you are granted a limited license to access and use LBP Monitor and to download or print a copy of any portion of the Content to which you have properly gained access solely for your personal, non-commercial use. We reserve all rights not expressly granted to you in and to LBP Monitor, Content and the Marks."),
              SizedBox(height: 15),

              Text("USER REPRESENTATIONS", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("By using LBP Monitor, you represent and warrant that: [(1) all registration information you submit will be true, accurate, current, and complete; (2) you will maintain the accuracy of such information and promptly update such registration information as necessary;] (3) you have the legal capacity and you agree to comply with these Terms of Use; (4) you will not access LBP Monitor through automated or non-human means, whether through a bot, script or otherwise; (5) you will not use LBP Monitor for any illegal or unauthorized purpose; and (6) your use of LBP Monitor will not violate any applicable law or regulation. If you provide any information that is untrue, inaccurate, not current, or incomplete, we have the right to suspend or terminate your account and refuse any and all current or future use of LBP Monitor (or any portion thereof)."),
              SizedBox(height: 15),

              Text("USER REGISTRATION", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("You may be required to register with LBP Monitor. You agree to keep your password confidential and will be responsible for all use of your account and password. We reserve the right to remove, reclaim, or change a username you select if we determine, in our sole discretion, that such username is inappropriate, obscene, or otherwise objectionable."),
              SizedBox(height: 15),

              Text("PROHIBITED ACTIVITIES", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("You may not access or use LBP Monitor for any purpose other than that for which we make LBP Monitor available. LBP Monitor may not be used in connection with any commercial endeavors except those that are specifically endorsed or approved by us. As a user of LBP Monitor, you agree not to: 1. systematically retrieve data or other content from LBP Monitor to create or compile, directly or indirectly, a collection, compilation, database, or directory without written permission from us. 2. make any unauthorized use of LBP Monitor, including collecting usernames and/or email addresses of users by electronic or other means for the purpose of sending unsolicited email, or creating user accounts by automated means or under false pretenses. 3. use a buying agent or purchasing agent to make purchases on LBP Monitor. 4. use LBP Monitor to advertise or offer to sell goods and services. 5. circumvent, disable, or otherwise interfere with security-related features of LBP Monitor, including features that prevent or restrict the use or copying of any Content or enforce limitations on the use of LBP Monitor and/or the Content contained therein. 6. engage in unauthorized framing of or linking to LBP Monitor. 7. trick, defraud, or mislead us and other users, especially in any attempt to learn sensitive account information such as user passwords; 8. make improper use of our support services or submit false reports of abuse or misconduct. 9. engage in any automated use of the system, such as using scripts to send comments or messages, or using any data mining, robots, or similar data gathering and extraction tools. 10. interfere with, disrupt, or create an undue burden on LBP Monitor or the networks or services connected to LBP Monitor. 11. attempt to impersonate another user or person or use the username of another user. 12. sell or otherwise transfer your profile. 13. use any information obtained from LBP Monitor in order to harass, abuse, or harm another person. 14. use LBP Monitor as part of any effort to compete with us or otherwise use LBP Monitor and/or the Content for any revenue-generating endeavor or commercial enterprise. 15. decipher, decompile, disassemble, or reverse engineer any of the software comprising or in any way making up a part of LBP Monitor. 16. attempt to bypass any measures of LBP Monitor designed to prevent or restrict access to LBP Monitor, or any portion of LBP Monitor. 17. harass, annoy, intimidate, or threaten any of our employees or agents engaged in providing any portion of LBP Monitor to you. 18. delete the copyright or other proprietary rights notice from any Content. 19. copy or adapt LBP Monitor’s software, including but not limited to Flash, PHP, HTML, JavaScript, or other code. 20. upload or transmit (or attempt to upload or to transmit) viruses, Trojan horses, or other material, including excessive use of capital letters and spamming (continuous posting of repetitive text), that interferes with any party’s uninterrupted use and enjoyment of LBP Monitor or modifies, impairs, disrupts, alters, or interferes with the use, features, functions, operation, or maintenance of LBP Monitor. 21. upload or transmit (or attempt to upload or to transmit) any material that acts as a passive or active information collection or transmission mechanism, including without limitation, clear graphics interchange formats (“gifs”), 1×1 pixels, web bugs, cookies, or other similar devices (sometimes referred to as “spyware” or “passive collection mechanisms” or “pcms”). 22. except as may be the result of standard search engine or Internet browser usage, use, launch, develop, or distribute any automated system, including without limitation, any spider, robot, cheat utility, scraper, or offline reader that accesses LBP Monitor, or using or launching any unauthorized script or other software. 23. disparage, tarnish, or otherwise harm, in our opinion, us and/or LBP Monitor. 24. use LBP Monitor in a manner inconsistent with any applicable laws or regulations."),
              SizedBox(height: 15),

              Text("CONTRIBUTION LICENSE", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("By posting your Contributions to any part of LBP Monitor, you automatically grant, and you represent and warrant that you have the right to grant, to us an unrestricted, unlimited, irrevocable, perpetual, non-exclusive, transferable, royalty-free, fully-paid, worldwide right, and license to host, use, copy, reproduce, disclose, sell, resell, publish, broadcast, retitle, archive, store, cache, publicly perform, publicly display, reformat, translate, transmit, excerpt (in whole or in part), and distribute such Contributions (including, without limitation, your image and voice) for any purpose, commercial, advertising, or otherwise, and to prepare derivative works of, or incorporate into other works, such Contributions, and grant and authorize sublicenses of the foregoing. The use and distribution may occur in any media formats and through any media channels. This license will apply to any form, media, or technology now known or hereafter developed, and includes our use of your name, company name, and franchise name, as applicable, and any of the trademarks, service marks, trade names, logos, and personal and commercial images you provide. You waive all moral rights in your Contributions, and you warrant that moral rights have not otherwise been asserted in your Contributions. We do not assert any ownership over your Contributions. You retain full ownership of all of your Contributions and any intellectual property rights or other proprietary rights associated with your Contributions. We are not liable for any statements or representations in your Contributions provided by you in any area on LBP Monitor. You are solely responsible for your Contributions to LBP Monitor and you expressly agree to exonerate us from any and all responsibility and to refrain from any legal action against us regarding your Contributions. We have the right, in our sole and absolute discretion, (1) to edit, redact, or otherwise change any Contributions; (2) to re-categorize any Contributions to place them in more appropriate locations on LBP Monitor; and (3) to pre-screen or delete any Contributions at any time and for any reason, without notice. We have no obligation to monitor your Contributions."),
              SizedBox(height: 15),

              Text("USER GENERATED CONTRIBUTIONS", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("LBP Monitor may invite you to donate data, chat, contribute to, or participate in blogs, message boards, online forums, and other functionality, and may provide you with the opportunity to create, submit, post, display, transmit, perform, publish, distribute, or broadcast content and materials to us or on LBP Monitor, including but not limited to text, writings, video, audio, photographs, graphics, comments, suggestions, or personal information or other material (collectively, \'Contributions\'). Contributions may be viewable by other users of LBP Monitor and through third-party websites. As such, any Contributions you transmit may be treated as non-confidential and non-proprietary. When you create or make available any Contributions, you thereby represent and warrant that: 1. the creation, distribution, transmission, public display, or performance, and the accessing, downloading, or copying of your Contributions do not and will not infringe the proprietary rights, including but not limited to the copyright, patent, trademark, trade secret, or moral rights of any third party. 2. you are the creator and owner of or have the necessary licenses, rights, consents, releases, and permissions to use and to authorize us, LBP Monitor, and other users of LBP Monitor to use your Contributions in any manner contemplated by LBP Monitor and these Terms of Use. 3. you have the written consent, release, and/or permission of each and every identifiable individual person in your Contributions to use the name or likeness of each and every such identifiable individual person to enable inclusion and use of your Contributions in any manner contemplated by LBP Monitor and these Terms of Use. 4. your Contributions are not false, inaccurate, or misleading. 5. your Contributions are not unsolicited or unauthorized advertising, promotional materials, pyramid schemes, chain letters, spam, mass mailings, or other forms of solicitation. 6. your Contributions are not obscene, lewd, lascivious, filthy, violent, harassing, libelous, slanderous, or otherwise objectionable (as determined by us). 7. your Contributions do not ridicule, mock, disparage, intimidate, or abuse anyone. 8. your Contributions do not advocate the violent overthrow of any government or incite, encourage, or threaten physical harm against another. 9. your Contributions do not violate any applicable law, regulation, or rule. 10. your Contributions do not violate the privacy or publicity rights of any third party. 11. your Contributions do not contain any material that solicits personal information from anyone under the age of 18 or exploits people under the age of 18 in a sexual or violent manner. 12. your Contributions do not violate any federal or state law concerning child pornography, or otherwise intended to protect the health or well-being of minors; 13. your Contributions do not include any offensive comments that are connected to race, national origin, gender, sexual preference, or physical handicap. 14. your Contributions do not otherwise violate, or link to material that violates, any provision of these Terms of Use, or any applicable law or regulation. Any use of LBP Monitor in violation of the foregoing violates these Terms of Use and may result in, among other things, termination or suspension of your rights to use LBP Monitor."),
              SizedBox(height: 15),

              Text("SUBMISSIONS", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("You acknowledge and agree that any questions, comments, suggestions, ideas, feedback, or other information regarding LBP Monitor (\'Submissions\') provided by you to us are non-confidential and shall become our sole property. We shall own exclusive rights, including all intellectual property rights, and shall be entitled to the unrestricted use and dissemination of these Submissions for any lawful purpose, commercial or otherwise, without acknowledgment or compensation to you. You hereby waive all moral rights to any such Submissions, and you hereby warrant that any such Submissions are original with you or that you have the right to submit such Submissions. You agree there shall be no recourse against us for any alleged or actual infringement or misappropriation of any proprietary right in your Submissions."),
              SizedBox(height: 15),

              Text("THIRD-PARTY WEBSITES AND CONTENT", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("LBP Monitor may contain (or you may be sent via LBP Monitor) links to other websites (\'Third-Party Websites\') as well as articles, photographs, text, graphics, pictures, designs, music, sound, video, information, applications, software, and other content or items belonging to or originating from third parties (\'Third-Party Content\'). Such Third-Party Websites and Third-Party Content are not investigated, monitored, or checked for accuracy, appropriateness, or completeness by us, and we are not responsible for any Third-Party Websites accessed through LBP Monitor or any Third-Party Content posted on, available through, or installed from LBP Monitor, including the content, accuracy, offensiveness, opinions, reliability, privacy practices, or other policies of or contained in the Third-Party Websites or the Third-Party Content. Inclusion of, linking to, or permitting the use or installation of any Third-Party Websites or any Third-Party Content does not imply approval or endorsement thereof by us. If you decide to leave LBP Monitor and access the Third-Party Websites or to use or install any Third-Party Content, you do so at your own risk, and you should be aware these Terms of Use no longer govern. You should review the applicable terms and policies, including privacy and data gathering practices, of any website to which you navigate from LBP Monitor or relating to any applications you use or install from LBP Monitor. Any purchases you make through Third-Party Websites will be through other websites and from other companies, and we take no responsibility whatsoever in relation to such purchases which are exclusively between you and the applicable third party. You agree and acknowledge that we do not endorse the products or services offered on Third-Party Websites and you shall hold us harmless from any harm caused by your purchase of such products or services. Additionally, you shall hold us harmless from any losses sustained by you or harm caused to you relating to or resulting in any way from any Third-Party Content or any contact with Third-Party Websites."),
              SizedBox(height: 15),

              Text("DIGITAL MILLENNIUM COPYRIGHT ACT (DMCA) NOTICE AND POLICY", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("Notifications We respect the intellectual property rights of others. If you believe that any material available on or through LBP Monitor infringes upon any copyright you own or control, please immediately notify our Designated Copyright Agent using the contact information provided below. A copy of your Notification will be sent to the person who posted or stored the material addressed in the Notification. Please be advised that pursuant to federal law you may be held liable for damages if you make material misrepresentations in a Notification. Thus, if you are not sure that material located on or linked to by LBP Monitor infringes your copyright, you should consider first contacting an attorney."),
              SizedBox(height: 15),

              Text("MODIFICATIONS AND INTERRUPTIONS", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("We reserve the right to change, modify, or remove the contents of LBP Monitor at any time or for any reason at our sole discretion without notice. However, we have no obligation to update any information. We also reserve the right to modify or discontinue all or part of LBP Monitor without notice at any time. We will not be liable to you or any third party for any modification, price change, suspension, or discontinuance of LBP Monitor. We cannot guarantee LBP Monitor will be available at all times. We may experience hardware, software, or other problems or need to perform maintenance related to LBP Monitor, resulting in interruptions, delays, or errors. We reserve the right to change, revise, update, suspend, discontinue, or otherwise modify LBP Monitor at any time or for any reason without notice to you. You agree that we have no liability whatsoever for any loss, damage, or inconvenience caused by your inability to access or use LBP Monitor during any downtime or discontinuance of LBP Monitor. Nothing in these Terms of Use will be construed to obligate us to maintain and support LBP Monitor or to supply any corrections, updates, or releases in connection therewith."),
              SizedBox(height: 15),

              Text("CORRECTIONS", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("There may be information on LBP Monitor that contains typographical errors, inaccuracies, or omissions that may relate to LBP Monitor, including descriptions, pricing, availability, and various other information. We reserve the right to correct any errors, inaccuracies, or omissions and to change or update the information on LBP Monitor at any time, without prior notice."),
              SizedBox(height: 15),

              Text("DISCLAIMER", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("LBP MONITOR IS PROVIDED ON AN AS-IS AND AS-AVAILABLE BASIS. YOU AGREE THAT YOUR USE OF LBP MONITOR SERVICES WILL BE AT YOUR SOLE RISK. TO THE FULLEST EXTENT PERMITTED BY LAW, WE DISCLAIM ALL WARRANTIES, EXPRESS OR IMPLIED, IN CONNECTION WITH LBP MONITOR AND YOUR USE THEREOF, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT. WE MAKE NO WARRANTIES OR REPRESENTATIONS ABOUT THE ACCURACY OR COMPLETENESS OF LBP MONITOR’S CONTENT OR THE CONTENT OF ANY WEBSITES LINKED TO THIS APP AND WE WILL ASSUME NO LIABILITY OR RESPONSIBILITY FOR ANY (1) ERRORS, MISTAKES, OR INACCURACIES OF CONTENT AND MATERIALS, (2) PERSONAL INJURY OR PROPERTY DAMAGE, OF ANY NATURE WHATSOEVER, RESULTING FROM YOUR ACCESS TO AND USE OF LBP MONITOR, (3) ANY UNAUTHORIZED ACCESS TO OR USE OF OUR SECURE SERVERS AND/OR ANY AND ALL PERSONAL INFORMATION AND/OR FINANCIAL INFORMATION STORED THEREIN, (4) ANY INTERRUPTION OR CESSATION OF TRANSMISSION TO OR FROM LBP MONITOR, (5) ANY BUGS, VIRUSES, TROJAN HORSES, OR THE LIKE WHICH MAY BE TRANSMITTED TO OR THROUGH LBP MONITOR BY ANY THIRD PARTY, AND/OR (6) ANY ERRORS OR OMISSIONS IN ANY CONTENT AND MATERIALS OR FOR ANY LOSS OR DAMAGE OF ANY KIND INCURRED AS A RESULT OF THE USE OF ANY CONTENT POSTED, TRANSMITTED, OR OTHERWISE MADE AVAILABLE VIA LBP MONITOR. WE DO NOT WARRANT, ENDORSE, GUARANTEE, OR ASSUME RESPONSIBILITY FOR ANY PRODUCT OR SERVICE ADVERTISED OR OFFERED BY A THIRD PARTY THROUGH LBP MONITOR, ANY HYPERLINKED WEBSITE, OR ANY WEBSITE OR MOBILE APPLICATION FEATURED IN ANY BANNER OR OTHER ADVERTISING, AND WE WILL NOT BE A PARTY TO OR IN ANY WAY BE RESPONSIBLE FOR MONITORING ANY TRANSACTION BETWEEN YOU AND ANY THIRD-PARTY PROVIDERS OF PRODUCTS OR SERVICES. AS WITH THE PURCHASE OF A PRODUCT OR SERVICE THROUGH ANY MEDIUM OR IN ANY ENVIRONMENT, YOU SHOULD USE YOUR BEST JUDGMENT AND EXERCISE CAUTION WHERE APPROPRIATE."),
              SizedBox(height: 15),

              Text("USER DATA", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("We will maintain certain data that you transmit to LBP Monitor for the purpose of managing LBP Monitor, as well as data relating to your use of LBP Monitor. Although we perform regular routine backups of data, you are solely responsible for all data that you transmit or that relates to any activity you have undertaken using LBP Monitor. You agree that we shall have no liability to you for any loss or corruption of any such data, and you hereby waive any right of action against us arising from any such loss or corruption of such data."),
              SizedBox(height: 15),

              Text("ELECTRONIC COMMUNICATIONS, TRANSACTIONS, AND SIGNATURES", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("Visiting LBP Monitor, sending us emails, and completing online forms constitute electronic communications. You consent to receive electronic communications, and you agree that all agreements, notices, disclosures, and other communications we provide to you electronically, via email and on LBP Monitor, satisfy any legal requirement that such communication be in writing. YOU HEREBY AGREE TO THE USE OF ELECTRONIC SIGNATURES, CONTRACTS, ORDERS, AND OTHER RECORDS, AND TO ELECTRONIC DELIVERY OF NOTICES, POLICIES, AND RECORDS OF TRANSACTIONS INITIATED OR COMPLETED BY US OR VIA LBP Monitor. You hereby waive any rights or requirements under any statutes, regulations, rules, ordinances, or other laws in any jurisdiction which require an original signature or delivery or retention of non-electronic records, or to payments or the granting of credits by any means other than electronic means."),
              SizedBox(height: 15),

              Text("MISCELLANEOUS", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("These Terms of Use and any policies or operating rules posted by us on LBP Monitor constitute the entire agreement and understanding between you and us. Our failure to exercise or enforce any right or provision of these Terms of Use shall not operate as a waiver of such right or provision. These Terms of Use operate to the fullest extent permissible by law. We may assign any or all of our rights and obligations to others at any time. We shall not be responsible or liable for any loss, damage, delay, or failure to act caused by any cause beyond our reasonable control. If any provision or part of a provision of these Terms of Use is determined to be unlawful, void, or unenforceable, that provision or part of the provision is deemed severable from these Terms of Use and does not affect the validity and enforceability of any remaining provisions. There is no joint venture, partnership, employment or agency relationship created between you and us as a result of these Terms of Use or use of LBP Monitor. You agree that these Terms of Use will not be construed against us by virtue of having drafted them. You hereby waive any and all defenses you may have based on the electronic form of these Terms of Use and the lack of signing by the parties hereto to execute these Terms of Use."),
              SizedBox(height: 15),

              Text("CONTACT US", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 5),
              Text("In order to resolve a complaint regarding LBP Monitor, have your data deleted, or to receive further information regarding use of LBP Monitor, please contact us at: simo.hosio@oulu.fi"),
              SizedBox(height: 15),

            ],
          ),
        ),
      ),
    );
  }

}
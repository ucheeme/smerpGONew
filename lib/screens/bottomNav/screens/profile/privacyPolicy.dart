import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smerp_go/utils/appColors.dart';

import '../../../../utils/appDesignUtil.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  PreferredSize(
          child: defaultDashboardAppBarWidget(() {
           Get.back();
          },"Privacy policy",context: context),
          preferredSize: Size.fromHeight(60.h)),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.only(left: 8.w,right: 8.w),
          child: Container(
            height: 6000.h,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  gapHeight(20.h),
                  customText1('''SMERP CWG PLC We are a leading provider of Information, and Communication Technology solutions services across West, Central, and Eastern Africa. We offer a diverse range of services such as Software services, which include software development and deployment, systems integration, software implementation, software support services and software enhancement and customization, Cloud Services, IT Infrastructure services, Managed services, Training, etc.\n

     This Privacy Notice (together with any other documents referred to in it) sets out in clear and concise form Our practices and procedures regarding the collection, use and disclosure of your personal data and sensitive personal data when you visit, access, browse through and/or use or Services. You have control over the type of data that you make available to Us. Using the controls highlighted in this Privacy Notice, you can limit or withdraw the information We collect about you or determine how We use such information.\n

    The privacy notice does not apply to any products, services, websites, or content that are offered by third parties or have their own privacy notice. Also, note that this Privacy Notice does not apply to job applicants and candidates who apply for employment through our job application portal, or to employees and non-employee workers, whose Personal Information is subject to different privacy notices which are provided to such individuals in the context of their employment or working relationship with us.\n

    SMERP is committed to protecting and respecting your privacy. We take all necessary steps to ensure that your personal data is safe and to prevent the misuse of your personal data. Detailed information on how we do it, as well as why and how we collect, store and use your personal data, could be found below.\n

    1. General Any changes we may make to this privacy notice in the future will be posted on this page and, where appropriate, notified to you by email. Please check back frequently to see any updates or changes to our privacy notice.\n\n
    2. Data that we collect from you\n
      (a) Information and content you provide;\n
      (b) Platform credentials;\n 
     (c) Business Information;\n
     (d) Name and email address if you sign up to receive our marketing communication;\n
     (e) In addition, We collect information from you that includes personal data in the context of Our operation, personal data entails any information relating to you, through which We identify or can identify you as a living individual (such as your name, gender, email address, and telephone number);\n\n
    2.1 We also collect and store data that you submit to us via email and through our contact form.\n

    2.2 We collect the information above by using cookies. Please click here to access our https://www.smerp.ng/cookies_policy which explains what cookies we use on our Platform, why we use them and how you can control them.\n\n

    3. The types data we may request from you are:\n
    (a) contact information including your name, date of birth, address, postcode and other contact information such as email address and telephone/mobile number and (where applicable) the contact details of your first of kin;\n
    (b) the bank account details to make or receive payments on the Platform;
     your passwords and security question answers;\n
    (d) your financial interests, financial position, or loan repayment performance;\n
                  (e) answers to questions required by third party credit reference agencies for identification purposes;
                  (f) information about your activities in using the Platform; and
    (g) information from directors/individuals associated with you and/or your business.\n
    3.1 We may retain copies of the following information about you:\n
                  (a) any correspondence you send us, details of your registration history and any materials you post on the Platform;\n
                  (b) passports or other identification evidence that you provide for anti-money laundering and anti-fraud purposes;\n
                  (c) records of any surveys that you may be asked to complete for research purposes, although you do not have to respond to them;\n
                  (d) details of transactions you carry out through the Platform and the receipt and disbursement of repayments;\n
                  (e) details of your visits to the Platform and the resources that you access;\n
                  (f) where explicit consent has been provided, information about your physical or mental health or condition (where necessary and appropriate); and\n
                  (g) where explicit consent has been provided, information relating to any criminal proceedings in which you have been involved.\n

                  3.2 If you give us false or inaccurate information, either directly or through an agent, and we suspect or identify fraud, we will record this.\n

                  3.3 We may also be provided with information about you from third party brokers, introducers or other referrers, who collected that information from you directly.\n\n

                  4. What do we do with the information we collect from users of the Platform? The main reason we use this information is to provide you with details about our products and services. Where it is in our legitimate interest to do so, we (or third party data processors, agents and sub-contractors acting on our behalf) may also use the information:\n
                   (a) to enable or enhance the functionalities of our systems;\n
                   (b) to contract with you and facilitate the delivery of the Services;\n
                   (c) to analyse and improve the safety and security of Our Products, Services and Online channels;\n
                   (d) to test and apply new product or system versions, patches, and updates;\n
                   (e) to improve the accuracy of our records so that we can better understand your needs and preferences;\n
                   (f) to contact you about products and Services that we believe may be of interest to you;\n
                   (g) to fulfil a specific request and provide customer support, such as responding to inquiries and handling complaints;\n
                   (h) to monitor, prevent and detect fraud, enhance security, monitor and verify identity or access, and combat spam or other malware or security risks;\n
                   (i) to deliver to you any administrative notices, alerts and communications relevant to your use of the services;\n
                   (j) To verify your identity and assist you, in case you lose or forget your login / password details;\n
                   (k) to contact you from time to time to inform you about new features, to troubleshoot problems, and to protect you against fraud or other criminal activity;\n
                   (l) To prevent and detect any misuse of the Website, or any fraudulent activities carried out through the Website (Misuse/Fraud);\n
                   (m) to meet legal requirements, including complying with court orders, valid discovery requests, valid subpoenas, and other appropriate legal mechanisms; and\n
                   (n) to fulfil other purposes disclosed at the time you provide Personal Information or otherwise where we are legally permitted or are required to do so. Where We need to process your information for additional purposes that We have not identified at the time of collection, We will make sure to obtain your consent or the appropriate legal basis for these additional uses to the extent required by applicable law.\n\n
                   5. Our Principles of Data Processing 
                      \n— Personal data will be processed fairly, lawfully and transparently manner;
                      \n— Personal data will be processed for a specific purpose and not in a way which is incompatible with the purpose which SMERP Plc has collected it; 
                      \n— Your personal data is adequate, relevant and limited to what is necessary in relation to the purposes for which it is processed; 
                      \n— Your personal data will be kept accurate and, where necessary kept up to date; 
                      \n— Your personal data will not be kept for no longer than it is necessary for the purposes for which it is processed; 
                      \n— We will take appropriate steps to keep your personal data secure.\n
                   \n6. Lawful Basis for Processing Your Data Consent If we have to use consent as a lawful basis, we will provide you with a consent form. You have the right to refuse to consent or withdraw your consent at any time by contacting us at info@smerp.ng Contract If the processing of your data is necessary for a contract you have with us, or because we have asked you to take specific steps before entering into that contract. \nLegal Obligation If the processing of your personal data is necessary where there is a statutory obligation upon us. Legitimate interests Processing your data is necessary for our legitimate interests or the legitimate interests of a third party, provided those interests are not outweighed by your rights and interests. \nThese legitimate interests are: 
                      \n— gaining insights from your behaviour on our website or in our app 
                      \n— delivering, developing and improving Our service 
                      \n— enabling us to enhance, customise or modify our services and communications \n
                      — determining whether marketing campaigns are effective 
                      \n— enhancing data security In each case, these legitimate interests are only valid if they are not outweighed by your rights and interests\n
                   \n7. What constitutes consent? We will not ask for your personal data unless we need it to provide services to you. At any point where consent is the appropriate lawful basis for processing of your personal data, we will provide you the option to either accept or not. \nIn addition, whenever we introduce new services and technologies, we will ensure you understand and agree to any new ways in which your information will be processed. You will be considered to have given your consent to SMERP for the processing of your personal data when; 
                      \n1. You complete any form issued by SMERP at any of our service points (mobile, online, in-branch etc.) requesting for such personal information; 
                      \n2. You register, check or tick the acceptance box on any of our electronic platforms (Online or Mobile) relating to terms and conditions of any service or product offered; and 
                      \n3. You accept the installation of cookies on your device. If we ask for your personal information for a secondary reason, like marketing, we will either ask you directly for your express consent, or provide you with an opportunity to say no. \nHowever, we should mention that withdrawal of consent would not affect the lawfulness of any processing carried out before you withdraw your consent. \n\nHow do I withdraw my consent? If after you opt-in, you change your mind, you may withdraw your consent to the continued processing of your personal data, at any time, by contacting us at info@smerp.ng\n
                   8. Who do we share your information with?\n
                   8.1 We may disclose your personal information to third parties where it is in our legitimate interest or we have legal obligation to do so including for the following reasons:\n
                   (a) we may share your information with analytics and search engine providers that assist us in the improvement and optimisation of our site;\n
                   (b) To monitor and analyse the use of our Service or to contact You;\n
                   (c) Entities engaged in order to provide the Services (e.g., hosting providers or e-mail platform providers);\n
                   (d) If you give your explicit consent;\n
                   (e) If we have to complete a contract on your behalf;\n
                   (f) Persons authorised to perform technical maintenance (including maintenance of network equipment and electronic communications networks);\n
                   (g) Public entities, bodies or authorities to whom your Personal Data may be disclosed, in accordance with the applicable law or binding orders of those entities, bodies or authorities;\n
                   (h) Persons authorised by SMERP to process Personal Data needed to carry out activities strictly related to the provision of the Services, who have undertaken an obligation of confidentiality or are subject to an appropriate legal obligation of confidentiality (e.g., employees of CWG);\n
                   (i) we may share your personal information with companies and other third parties performing services on our behalf (for example KYC service providers, credit reference agencies, customer relationship management providers or other service providers) who will only use the information to provide that service. We may also share your personal information with other members of our corporate group, or a purchaser or potential purchaser of our business;\n
                   (j) we may share alerts and information derived from identity verification checks with third parties for the purpose of anti-money laundering and fraud prevention; and I.\n
                    \nIf there is a legal obligation on us to share such data under existing laws and regulations. The Company may disclose Your Personal Data in the good faith belief that such action is necessary to: – Comply with a legal obligation; – Protect and defend the rights or property of the Company; – Prevent or investigate possible wrongdoing in connection with the Service; – Protect the personal safety of Users of the Service or the public; and Protect against legal liability. Please note that we may also share your information (personal and non-personal) with our potential and current financiers and financial investors, and in connection with, or during due diligence or and negotiations of, any proposed or actual financing, merger, purchase, sale, joint venture, or any other type of acquisition or business combination of all or any portion of SMERP Plc; or if we are duty bound to disclose or share your Personal Information in order to fulfil any legal requirements, or in order to administer or enforce customer agreements and applicable terms and policies.\n 8.2 Save as set out in this privacy notice, we will not sell or disclose your data to any third party.\n\n
                  9. Where we store your personal data\n
                  9.1 We are committed to ensuring that your information is safe and take all steps reasonably necessary to ensure that your data is treated securely and in accordance with this privacy notice. In order to prevent unauthorised access or disclosure we have put in place suitable physical, electronic and managerial procedures to safeguard and secure the information we collect online.\n\n
                  10. How long we keep your information\n
                  10.1 We will keep your data for as long as necessary to fulfil the purposes described in this privacy notice. However, we will also retain data subject to relevant provisions of applicable laws, resolve disputes, and enforce our legal agreements and policies. Also, a contract between us could also prescribe a retention period, we will not retain data beyond the duration prescribed in the contract.\n
                  10.2 We will also retain Usage Data for internal analysis purposes. Usage Data is generally retained for a shorter period, except when this data is used to strengthen the security or to improve the functionality of Our Service, or We are legally obligated to retain this data for longer time periods.\n\n
                  11. Marketing and Communications\n
                  11.1 We strive to provide you with choices regarding certain personal data uses, particularly around marketing and advertising.\n
                  11.2 If you have registered with us or have previously asked us for information on our products or services and you have not opted out of receiving that marketing information, we may send you information on our range of products, services, promotions, special offers and other information which we think you may find interesting by phone, email and/or SMS.\n
                  11.3 We will get your express opt-in consent before we share your personal data with any third party for marketing purposes.\n
                  11.4 You can ask us or third parties to stop sending you marketing messages at any time by contacting us by email at info@smerp.ng\n\n
                  12. Your Rights You have the following rights:\n
                   (a) the right to request for access to your personal data;\n
                   (b) the right to erasure of your personal data (right to be forgotten);\n
                   (c) the right to rectify or amend inaccurate or incomplete personal data;\n
                   (d) the right to object to processing of your personal data;\n
                   (e) the right to portability of data; and\n
                   (f) the right to lodge a complaint with the Court, National Information Technology Development Agency (NITDA) or any other relevant supervisory authority. 13. Security of Data At SMERP, We are very particular about preserving your privacy and protecting your personal data. Therefore, to avoid the loss, theft, misuse and unauthorised access, disclosure, alteration, and destruction of your information, we have put in place a range of administrative, technical, organisational and physical safeguards. Despite this, we cannot completely guarantee the security of any information you transmit via our Online Channels, as the internet is not an entirely secure place. We are committed to doing our best to protect you.\n\n
                  14. International Transfer of Data Your Personal Data may be transferred to Recipients located in several different countries. To achieve the purposes described in this Privacy Notice, we transfer your Personal Data to countries that may not offer an adequate level of protection or not considered to have adequate law by the National Information Technology Development Agency. Where Personal Data is to be transferred to a country outside Nigeria, We shall put adequate measures in place to ensure the security of such Personal Data. In particular, We shall, among other things, conduct a detailed transfer impact assessment of whether the said country is on NITDA™ Whitelist of Countries with adequate data protection laws. Our data transfers to the countries that do not offer an adequate level of protection are subject to either of the conditions in accordance with the Nigeria Data Protection Regulation. We will therefore only transfer Personal Data out of Nigeria on one of the following conditions:\n
                   a. The consent of the Data Subject has been obtained;\n
                   b. The transfer is necessary for the performance of a contract between Us and the Data Subject or implementation of pre-contractual measures taken at the Data Subject™s request;\n
                   c. The transfer is necessary to conclude a contract between Us and a third party in the interest of the Data Subject;\n
                   d. The transfer is necessary for reason of public interest;\n
                   e. The transfer is for the establishment, exercise or defense of legal claims;\n
                   f. The transfer is necessary in order to protect the vital interests of the Data Subjects or other persons, where the Data Subject is physically or legally incapable of giving consent. To obtain any relevant information regarding any transfers of your Personal Data to third countries (including the relevant transfer mechanisms), please contact our Data Protection Officer at info@smerp.ng\n
                  \n15. Remedy in the event of violation of privacy notice Where there is any perceived violation of your rights, we shall take appropriate steps to remedy such violations, once confirmed. You shall be appropriately informed of the remedies employed. In the event of a data breach, we shall within 72 (seventy two) hours of having knowledge of such breach report the details of the breach to NITDA. \nFurthermore, we will notify you immediately via email if the breach will result in risk and danger to your rights and freedoms. If you have any complaints regarding our compliance with this Privacy Notice, please contact our Data Protection Officer. We will investigate and attempt to resolve complaints and disputes regarding use and disclosure of personal information within thirty (30) days in accordance with this Privacy Policy and in accordance with applicable law and regulation. \nIf you feel that your Personal Data has not been handled correctly or you are unhappy with our response to any requests you have made to us regarding the use of your Personal Data, you have a right to lodge a complaint with the NITDA. \nThe contact details are: National Information Technology Development Agency Tel: +234929220263, +2348168401851, +2347052420189 Email: info@nitda.gov.ng Website: www.nitda.gov.ng\n
                  \n16. Changes to Our Privacy Notice We may update our Privacy Notice from time to time. We will notify You of any changes by posting the new Privacy Notice on this page. We will let You know via email and/or a prominent notice on Our Service, prior to the change becoming effective and update the Last updated date at the top of this Privacy Notice. You are advised to review this Privacy Notice periodically for any changes. Changes to this Privacy Notice are effective when they are posted on this page\n
                      \n17. Contacting us If you have any complaints or any questions about any aspect of this privacy notice or your information, or to exercise any of your rights as described in this privacy notice or under data protection laws, you can contact Us by email: info@smerp.ng\n''', kBlack, 14.sp,
                  maxLines: 1000),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

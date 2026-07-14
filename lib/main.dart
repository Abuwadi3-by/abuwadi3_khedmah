import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_project/communication/conversations.dart';
import 'package:graduation_project/customer%20interfaces/categories.dart';
import 'package:graduation_project/customer%20interfaces/customer%20home%20page.dart';
import 'package:graduation_project/customer%20interfaces/notification.dart';
import 'package:graduation_project/customer%20interfaces/request%20and%20offer/customer%20requests.dart';
import 'package:graduation_project/customer%20interfaces/request%20and%20offer/service%20request.dart';
import 'package:graduation_project/professional%20interfaces/offers%20presented.dart';
import 'package:graduation_project/professional%20interfaces/professional%20home%20page.dart';
import 'package:graduation_project/professional%20interfaces/requests%20and%20offers/create%20offer%20for%20request.dart';
import 'package:graduation_project/professional%20interfaces/requests%20and%20offers/customer%20requests%20at%20the%20professional.dart'
    hide Requests;
import 'package:graduation_project/professional%20interfaces/requests%20and%20offers/request%20details.dart';
import 'package:graduation_project/professional%20interfaces/wallet.dart';
import 'package:graduation_project/providers/auth_provider.dart';
import 'package:graduation_project/providers/balance_provider.dart';
import 'package:graduation_project/providers/category_provider.dart';
import 'package:graduation_project/providers/chat_provider.dart';
import 'package:graduation_project/providers/complaint_provider.dart';
import 'package:graduation_project/providers/coversation_provider.dart';
import 'package:graduation_project/providers/create_offer_provider.dart';
import 'package:graduation_project/providers/location_provider.dart';
import 'package:graduation_project/providers/notifications_provider.dart';
import 'package:graduation_project/providers/offers_presented_provider.dart';
import 'package:graduation_project/providers/offers_provider.dart';
import 'package:graduation_project/providers/professional_provider.dart';
import 'package:graduation_project/providers/professional_requests_provider.dart';
import 'package:graduation_project/providers/profile_provider.dart';
import 'package:graduation_project/providers/rating_provider.dart';
import 'package:graduation_project/providers/requests_provider.dart';
import 'package:graduation_project/providers/create_service_request_provider.dart';
import 'package:graduation_project/settings/about%20us.dart';
import 'package:graduation_project/settings/edite%20profile%20information.dart';
import 'package:graduation_project/settings/general%20setting.dart';
import 'package:graduation_project/settings/profile.dart';
import 'package:graduation_project/register_login/create%20account.dart';
import 'package:graduation_project/register_login/create%20account%20or%20login.dart';
import 'package:graduation_project/register_login/forgot%20password/email%20verification.dart';
import 'package:graduation_project/register_login/forgot%20password/set%20password.dart';
import 'package:graduation_project/register_login/professional%20information.dart';
import 'package:graduation_project/register_login/public%20information.dart';
import 'package:graduation_project/register_login/login.dart';
import 'package:graduation_project/register_login/welcom%20page.dart';
import 'package:graduation_project/settings/support.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfessionalRequestsProvider()),
        ChangeNotifierProvider(create: (_) => RequestsProvider()),
        ChangeNotifierProvider(create: (_) => OffersProvider()),
        ChangeNotifierProvider(create: (_) => ProfessionalsProvider()),
        ChangeNotifierProvider(create: (_) => BalanceProvider()),
        ChangeNotifierProvider(create: (_) => OffersPresentedProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ServiceRequestProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
        ChangeNotifierProvider(create: (_) => CreateOfferProvider()),
        ChangeNotifierProvider(create: (_) => ConversationsProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => RatingProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => ComplaintProvider()),
        ChangeNotifierProvider(create: (_) => RatingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomPage(),
      routes: {
        "createorlogin": (context) => CreateOrLogin(),
        "registeraccount": (context) => RegisterAccount(),
        "registerinformation": (context) => RegisterInformation(),
        "registerlogin": (context) => Login(),
        "otherinformation": (context) => Professional_Information(),
        "categories": (context) => Categories(),
        "emailverification": (context) => Verification(),
        "setpassword": (context) => NewPassword(),
        "customerhomepage": (context) => CustomerHomePage(),
        "notification": (context) => Notificationpage(),
        "service_request": (context) => ServiceRequest(),
        "requests": (context) => Requests(),
        "generalsetting": (context) => Setting(),
        "profile": (context) => Profile(),
        "editeprofile": (context) => EditProfile(),
        "support": (context) => Help(),
        "about": (context) => About(),
        "wallet": (context) => Balance(),
        "professionalhomepagr": (context) => ProfessionalHomePage(),
        "customerrequests": (context) => Requests_at_the_Professional(),
        "requestdetails": (context) => RequestDetails(),
        "createofferforrequest": (context) => CreateOfferForRequest(),
        "offerspresented": (context) => OffersPresented(),
        "conversations": (context) => Conversations(),
      },
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: child,
        );
      },
    );
  }
}

/* 
* Credits

* A page to acknowledge the developers who created the project.
* Also provides links to browse the repository of the app and the
* API server, along with the licenses.
*/

import 'package:flutter/material.dart';

// * States import
import 'package:soil_moisture_app/states/theme_state.dart';

// * ui import
import 'package:soil_moisture_app/ui/colors.dart';

// * External Packages import
import 'package:flutter_image/network.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// * utils import
import 'package:soil_moisture_app/utils/app_info.dart';
import 'package:soil_moisture_app/utils/sizes.dart';

// * data import
import 'package:soil_moisture_app/data/all_data.dart';

// * pages import
import 'Licenses.dart';

class Credits extends StatefulWidget {
  @override
  _CreditsState createState() => _CreditsState();
}

class _CreditsState extends State<Credits> {
  static _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    return true;
  }

  IndexedWidgetBuilder devInfoBuilder = (context, index) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: appWidth(context) * 0.03,
      ),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).accentColor,
        backgroundImage: NetworkImageWithRetry(
          'https://avatars.githubusercontent.com/${devDetails[index]['Github']}',
        ),
      ),
      title: Text(
        devDetails[index]['Name'],
        style: Theme.of(context).textTheme.subtitle1,
      ),
      subtitle: Text(
        devDetails[index]['Github'],
        style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: (Provider.of<ThemeState>(context).isDarkTheme)
                  ? subtleWhiteTextColor
                  : subtleBlackTextColor,
            ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            tooltip: 'Open GitHub profile',
            onPressed: () =>
                _launchUrl('http://github.com/${devDetails[index]['Github']}'),
            icon: FaIcon(
              FontAwesomeIcons.github,
              color: (Provider.of<ThemeState>(context).isDarkTheme)
                  ? githubWhite
                  : githubBlack,
            ),
          ),
          IconButton(
            tooltip: 'Open Twitter profile',
            onPressed: () => _launchUrl(
                'http://twitter.com/${devDetails[index]['Twitter']}'),
            icon: FaIcon(
              FontAwesomeIcons.twitter,
              color: twitterBlue,
            ),
          )
        ],
      ),
    );
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(
          'About',
          style: Theme.of(context).textTheme.headline6.copyWith(
                fontSize: appWidth(context) * 0.055,
              ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(appWidth(context) * 0.03),
          physics:
              AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          children: <Widget>[
            Image.asset(
              (Provider.of<ThemeState>(context).isDarkTheme)
                  ? './assets/images/Soif_sk_dark.png'
                  : './assets/images/Soif_sk.png',
              height: appWidth(context) * 0.25,
            ),
            Padding(
              padding: EdgeInsets.all(appHeight(context) * 0.01),
              child: RichText(
                textAlign: TextAlign.center,
                strutStyle: StrutStyle(fontSize: 14.0),
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: (Provider.of<ThemeState>(context).isDarkTheme)
                            ? subtleWhiteTextColor
                            : subtleBlackTextColor,
                      ),
                  children: [
                    TextSpan(text: 'Version ${getAppInfo.version}\n'),
                    TextSpan(text: 'Built with '),
                    WidgetSpan(child: FlutterLogo()),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: appWidth(context) * 0.03),
              child: Text(
                'MEMBERS AND CONTRIBUTORS',
                style: Theme.of(context).textTheme.headline5.copyWith(
                      fontSize: appWidth(context) * 0.05,
                    ),
              ),
            ),
            Card(
              child: Column(
                children: List.generate(devDetails.length,
                    (index) => devInfoBuilder(context, index)),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: appWidth(context) * 0.03),
              child: Text(
                'VIEW SOURCES',
                style: Theme.of(context).textTheme.headline5.copyWith(
                      fontSize: appWidth(context) * 0.05,
                    ),
              ),
            ),
            Card(
              child: ListTile(
                dense: true,
                leading: FaIcon(FontAwesomeIcons.codeBranch),
                title: Text(
                  'Fork the project on GitHub',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                subtitle: Text(
                  'Show your appreciation by 🌟ing the repository!',
                  style: Theme.of(context).textTheme.caption.copyWith(
                        fontSize: appWidth(context) * 0.03,
                      ),
                ),
                onTap: () => _launchUrl(repoUrl),
              ),
            ),
            Card(
              child: ListTile(
                dense: true,
                leading: FaIcon(FontAwesomeIcons.server),
                title: Text(
                  'View API implementation',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                subtitle: Text(
                  'The other side of this project.',
                  style: Theme.of(context).textTheme.caption.copyWith(
                        fontSize: appWidth(context) * 0.03,
                      ),
                ),
                onTap: () => _launchUrl(apiUrl),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16.0),
              alignment: Alignment.center,
              child: FlatButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Licenses(),
                  ),
                ),
                child: Text('LICENSES'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

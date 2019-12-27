/* 
* Credits

* A page to acknowledge the developers who created the project.
* Also provides links to browse the repository of the app and the
* API server.
*/

import 'package:flutter/material.dart';

// * States import
import 'package:soif/states/theme_state.dart';

// * ui import
import 'package:soif/ui/colors.dart';

// * External Packages import
import 'package:flutter_image/network.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// * utils import
import 'package:soif/utils/sizes.dart';

// * data import
import 'package:soif/data/all_data.dart';

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
      contentPadding: EdgeInsets.symmetric(
          horizontal: appWidth(context) * 0.03,
          vertical: appWidth(context) * 0.01),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).accentColor,
        backgroundImage: NetworkImageWithRetry(
          'https://avatars.githubusercontent.com/${devDetails[index]['Github']}',
        ),
      ),
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: devDetails[index]['Name'],
                style: Theme.of(context).textTheme.subhead),
            TextSpan(
              text: ' ${devDetails[index]['Github']}',
              style: Theme.of(context).textTheme.body2.copyWith(
                    color: (Provider.of<ThemeState>(context).isDarkTheme)
                        ? subtleWhiteTextColor
                        : subtleBlackTextColor,
                  ),
            )
          ],
        ),
      ),
      subtitle: Text(
        devDetails[index]['Bio'],
        style: Theme.of(context).textTheme.caption.copyWith(
              fontSize: appWidth(context) * 0.03,
            ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            tooltip: 'Open GitHub profile',
            onPressed: () =>
                _launchUrl('http://github.com/${devDetails[index]['Github']}'),
            icon: Icon(
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
            icon: Icon(
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
          style: Theme.of(context).textTheme.title.copyWith(
                fontSize: appWidth(context) * 0.055,
              ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: appWidth(context) * 0.03),
        child: ListView(
          physics:
              AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          children: <Widget>[
            SizedBox(
              height: appWidth(context) * 0.03,
            ),
            Image.asset(
              (Provider.of<ThemeState>(context).isDarkTheme)
                  ? './assets/images/Soif_sk_dark.png'
                  : './assets/images/Soif_sk.png',
              height: appWidth(context) * 0.25,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: appWidth(context) * 0.03),
              child: Text(
                'MEMBERS AND CONTRIBUTORS',
                style: Theme.of(context).textTheme.headline.copyWith(
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
                style: Theme.of(context).textTheme.headline.copyWith(
                      fontSize: appWidth(context) * 0.05,
                    ),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(FontAwesomeIcons.codeBranch),
                title: Text(
                  'Fork the project on GitHub',
                  style: Theme.of(context).textTheme.subhead,
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
                leading: Icon(FontAwesomeIcons.server),
                title: Text(
                  'View API implementation',
                  style: Theme.of(context).textTheme.subhead,
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
            SizedBox(
              height: appWidth(context) * 0.03,
            )
          ],
        ),
      ),
    );
  }
}

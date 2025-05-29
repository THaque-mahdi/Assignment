import 'package:flutter/material.dart';
import 'homepage.dart';
import 'profilepage.dart';
import 'package:url_launcher/url_launcher.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  final Map<String, List<Map<String, String>>> _groupedTopics = {
    'Flutter Basics': [
      {'title': 'Dart Language Fundamentals', 'url': 'https://dart.dev/guides'},
      {'title': 'Flutter Widgets & Layout', 'url': 'https://docs.flutter.dev/ui/widgets'},
      {'title': 'State Management (Provider, Riverpod)', 'url': 'https://docs.flutter.dev/development/data-and-backend/state-mgmt'},
      {'title': 'Navigation & Routing', 'url': 'https://docs.flutter.dev/ui/navigation'},
      {'title': 'Handling User Input', 'url': 'https://docs.flutter.dev/ui/forms'},
      {'title': 'Building Responsive UIs', 'url': 'https://docs.flutter.dev/ui/layout/responsive'},
    ],
    'App UI Design': [
      {'title': 'UI/UX Design Principles', 'url': 'https://www.figma.com/resource-library/ui-design-principles/'},
      {'title': 'Material Design / Cupertino', 'url': 'https://m3.material.io/develop/flutter'},
      {'title': 'Prototyping Tools', 'url': 'https://help.figma.com/hc/en-us/articles/360040314193-Guide-to-prototyping-in-Figma'},
      {'title': 'Color Theory & Typography', 'url': 'https://www.smartmentors.net/ui-design-principles-color-theory-typography-layouts/'},
      {'title': 'Responsive and Adaptive Design', 'url': 'https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/CSS_layout/Responsive_Design'},
      {'title': 'Accessibility in Design', 'url': 'https://stephaniewalter.design/blog/a-designers-guide-to-documenting-accessibility-user-interactions/'},
    ],
    'Programming Languages': [
      {'title': 'Java', 'url': 'https://docs.oracle.com/en/java/'},
      {'title': 'Python', 'url': 'https://docs.python.org/3/'},
      {'title': 'C++', 'url': 'https://en.cppreference.com/w/'},
      {'title': 'JavaScript', 'url': 'https://developer.mozilla.org/en-US/docs/Web/JavaScript'},
      {'title': 'TypeScript', 'url': 'https://www.typescriptlang.org/docs/handbook/intro.html'},
    ],
    'Web Development': [
      {'title': 'HTML', 'url': 'https://developer.mozilla.org/en-US/docs/Web/HTML'},
      {'title': 'CSS', 'url': 'https://developer.mozilla.org/en-US/docs/Web/CSS'},
      {'title': 'React.js', 'url': 'https://reactjs.org/docs/getting-started.html'},
      {'title': 'Node.js', 'url': 'https://nodejs.org/en/docs/'},
      {'title': 'REST APIs', 'url': 'https://restfulapi.net/'},
      {'title': 'Responsive Design (media queries, Flexbox, Grid)', 'url': 'https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/CSS_layout/Responsive_Design'},
    ],
    'Cyber Security': [
      {'title': 'Basics of Cybersecurity', 'url': 'https://cybersecurityguide.org/basics/'},
      {'title': 'Malware, Phishing, Ransomware', 'url': 'https://us-cert.cisa.gov/ncas/tips/ST04-001'},
      {'title': 'Cryptography Fundamentals', 'url': 'https://www.khanacademy.org/computing/computer-science/cryptography'},
      {'title': 'Network Security Basics', 'url': 'https://www.cisco.com/c/en/us/products/security/what-is-network-security.html/'},
      {'title': 'Web Security Essentials (OWASP Top 10)', 'url': 'https://owasp.org/www-project-top-ten/'},
      {'title': 'Secure Coding Practices', 'url': 'https://owasp.org/www-project-secure-coding-practices/'},
    ],
    'Database Systems': [
      {'title': 'SQL, MySQL, PostgreSQL', 'url': 'https://www.postgresql.org/docs/'},
      {'title': 'MongoDB, Firebase', 'url': 'https://www.mongodb.com/docs/'},
      {'title': 'ER Diagrams & Database Design', 'url': 'https://www.lucidchart.com/pages/er-diagram'},
      {'title': 'Normalization & Data Modeling', 'url': 'https://www.guru99.com/database-normalization.html'},
      {'title': 'Indexing & Query Optimization', 'url': 'https://www.geeksforgeeks.org/database-indexing/'},
      {'title': 'Connecting with Apps (REST API or ORM)', 'url': 'https://sequelize.org/'},
    ],
  };

  Map<String, List<Map<String, String>>> _filteredGroupedTopics = {};

  @override
  void initState() {
    super.initState();
    _filteredGroupedTopics = Map.from(_groupedTopics);
    _searchController.addListener(_filterTopics);
  }

  void _filterTopics() {
    String query = _searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredGroupedTopics = Map.from(_groupedTopics);
        return;
      }

      _filteredGroupedTopics = {};

      _groupedTopics.forEach((group, topics) {
        final matches = topics.where((topic) =>
            topic['title']!.toLowerCase().contains(query) ||
            group.toLowerCase().contains(query)).toList();

        if (matches.isNotEmpty) {
          _filteredGroupedTopics[group] = matches;
        }
      });
    });
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildGroupSection(String groupName, List<Map<String, String>> topics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
          child: Text(
            " $groupName",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
          ),
        ),
        ...topics.map((topic) => Card(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: ListTile(
                title: Text(topic['title']!, style: const TextStyle(color: Colors.brown)),
                trailing: const Icon(Icons.open_in_new, color: Colors.brown),
                onTap: () => _launchURL(topic['url']!),
              ),
            )),
      ],
    );
  }

  void mysnackBar(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Documentation"),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Explore Documentation by Topic",
              style: TextStyle(fontSize: 20, color: Color.brown, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search (e.g. flutter, web, python)',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: _filteredGroupedTopics.entries
                  .map((entry) => _buildGroupSection(entry.key, entry.value))
                  .toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (int index) {
          if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
          } else if (index == 1) {
            mysnackBar("Explore", context);
          } else if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
          }
        },
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.book_online), label: "Documentation"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

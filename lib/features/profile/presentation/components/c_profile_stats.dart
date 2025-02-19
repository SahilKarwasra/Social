import 'package:flutter/material.dart';

class CProfileStats extends StatelessWidget {
  final int postCount;
  final int followersCount;
  final int followingCount;
  final void Function()? onTap;

  const CProfileStats({
    super.key,
    required this.postCount,
    required this.followersCount,
    required this.followingCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var textThemeForCount = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.inversePrimary,
    );
    var textThemeForText = TextStyle(
      fontSize: 15,
      color: Theme.of(context).colorScheme.primary,
    );

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // POST
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text("$postCount", style: textThemeForCount),
                Text(
                  "Posts",
                  style: textThemeForText,
                ),
              ],
            ),
          ),

          // FOLLOWERS
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(followersCount.toString(), style: textThemeForCount),
                Text(
                  "Followers",
                  style: textThemeForText,
                )
              ],
            ),
          ),

          // FOLLOWING
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(followingCount.toString(), style: textThemeForCount),
                Text(
                  "Following",
                  style: textThemeForText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

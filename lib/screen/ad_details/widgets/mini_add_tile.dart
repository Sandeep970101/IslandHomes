import 'package:flutter/material.dart';

class MiniAdTile extends StatelessWidget {
  const MiniAdTile({
    super.key,
    required this.ad,
  });

  final dynamic ad;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 100,
        height: 90,
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              ad['image'],
            ),
          ),
        ),
        child: Container(
          height: 24,
          padding: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: Colors.lightGreen,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ad['name'],
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 30,
                child: Text(
                  ad['price'],
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

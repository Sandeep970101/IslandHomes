import 'package:ecomm/screen/ad_details/widgets/mini_add_tile.dart';
import 'package:ecomm/utils/constants.dart';
import 'package:ecomm/utils/size_config.dart';
import 'package:flutter/material.dart';

class AdDetails extends StatefulWidget {
  const AdDetails({
    super.key,
    required this.ad,
    required this.list,
  });

  final dynamic ad;
  final List<dynamic> list;

  @override
  State<AdDetails> createState() => _AdDetailsState();
}

class _AdDetailsState extends State<AdDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: SizeConfig.w(context),
        height: SizeConfig.h(context),
        child: Stack(
          children: [
            UpperSection(ad: widget.ad),
            Positioned(
              top: 256,
              child: ProductDetailsSection(
                ad: widget.ad,
                list: widget.list,
              ),
            ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Padding(
            //     padding: const EdgeInsets.only(bottom: 70),
            //     child: CustomButton(
            //       text: "Add to cart",
            //       onTap: () {},
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

class ProductDetailsSection extends StatelessWidget {
  const ProductDetailsSection({
    super.key,
    required this.ad,
    required this.list,
  });

  final dynamic ad;
  final List<dynamic> list;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.w(context),
      height: SizeConfig.h(context),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(34),
          topRight: Radius.circular(34),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(29, 34, 29, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ad['name'] ?? '',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: ad['isApproved'] ? Colors.green : Colors.red,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      ad['isApproved'] ? Icons.check_circle : Icons.indeterminate_check_box_sharp,
                      size: 20,
                      color: ad['isApproved'] ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 5),
                    Text(ad['isApproved'] ? "Approved" : "Approval Pending"),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 21),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Price: \$${ad['price'] ?? ''}",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            ad['description'] ?? '',
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 28),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Related Ads",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 90,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: list.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return ad == list[index] ? const SizedBox() : MiniAdTile(ad: list[index]);
              },
              separatorBuilder: (context, index) => const SizedBox(width: 10),
            ),
          ),
        ],
      ),
    );
  }
}

class CounterSection extends StatelessWidget {
  const CounterSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          InkWell(
            child: Icon(Icons.add),
          ),
          SizedBox(width: 15),
          Text(
            "1",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 15),
          InkWell(
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class UpperSection extends StatelessWidget {
  const UpperSection({
    super.key,
    required this.ad,
  });

  final dynamic ad;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 290,
      alignment: Alignment.topLeft,
      width: SizeConfig.w(context),
      decoration: BoxDecoration(
        color: Colors.red,
        image: DecorationImage(
          image: NetworkImage(ad['image'] ?? Constants.dummyImg),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

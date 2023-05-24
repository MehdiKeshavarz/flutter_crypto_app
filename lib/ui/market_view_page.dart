import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../data/data_source/response_model.dart';
import '../data/models/CryptoModel/CryptoData.dart';
import '../helpers/decimal_rounder.dart';
import '../providers/market_view_provider.dart';

class MarketViewPage extends StatefulWidget {
  const MarketViewPage({Key? key}) : super(key: key);

  @override
  State<MarketViewPage> createState() => _MarketViewPageState();
}

class _MarketViewPageState extends State<MarketViewPage> {
  late Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final cryptoMarketViewProvider =
        Provider.of<MarketViewProvider>(context, listen: false);
    cryptoMarketViewProvider.getAllCryptoData();

    timer = Timer.periodic(const Duration(seconds: 20),
        (timer) => cryptoMarketViewProvider.getAllCryptoData());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    var primaryColor = Theme.of(context).primaryColor;
    var borderColor = Theme.of(context).secondaryHeaderColor;

    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Expanded(child: Consumer<MarketViewProvider>(
                builder: (context, marketViewProvider, child) {
                  switch (marketViewProvider.state.status) {
                    case Status.LOADING:
                      return shimmerMarketView();
                    case Status.COMPLETED:
                      List<CryptoData>? cryptoModel = marketViewProvider
                          .dataFuture.data!.cryptoCurrencyList;
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              onChanged: (value) {
                                // List<CryptoData>? searchList = [];
                                //
                                // for(CryptoData crypto in model!){
                                //   if(crypto.name!.toLowerCase().contains(value) || crypto.symbol!.toLowerCase().contains(value)){
                                //     searchList.add(crypto);
                                //   }
                                // }
                                // marketViewProvider.configSearch(searchList);
                              },
                              // controller: searchController,
                              decoration: InputDecoration(
                                hintStyle: textTheme.bodySmall,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: borderColor,
                                ),
                                // hintText: AppLocalizations.of(context)!.search,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: borderColor),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.separated(
                                itemBuilder: (context, index) {
                                  var number = index + 1;
                                  var tokenId = cryptoModel![index].id;
                                  MaterialColor filterColor =
                                      DecimalRounder.setColorFilter(
                                          cryptoModel[index]
                                              .quotes![0]
                                              .percentChange30d);
                                  var finalPrice =
                                      DecimalRounder.removePriceDecimals(
                                          cryptoModel[index].quotes![0].price);
                                  // percent change setup decimals and colors
                                  var percentChange =
                                      DecimalRounder.removePercentDecimals(
                                          cryptoModel[index]
                                              .quotes![0]
                                              .percentChange24h);
                                  Color percentColor =
                                      DecimalRounder.setPercentChangesColor(
                                          cryptoModel[index]
                                              .quotes![0]
                                              .percentChange24h);
                                  Icon percentIcon =
                                      DecimalRounder.setPercentChangesIcon(
                                          cryptoModel[index]
                                              .quotes![0]
                                              .percentChange24h);

                                  var name = cryptoModel[index].name!;
                                  var symbol = cryptoModel[index].symbol!;

                                  return SizedBox(
                                    height: height * 0.075,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Text('$number',
                                              style: textTheme.bodySmall),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 15.0),
                                          child: CachedNetworkImage(
                                            fadeInDuration: const Duration(
                                                milliseconds: 500),
                                            height: 32,
                                            width: 32,
                                            imageUrl:
                                                'https://s2.coinmarketcap.com/static/img/coins/32x32/$tokenId.png',
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                name.length > 10
                                                    ? '${name.substring(0, 8)}...'
                                                    : name,
                                                style: textTheme.bodySmall,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            Text(
                                                symbol.length > 10
                                                    ? '${symbol.substring(0, 8)}...'
                                                    : symbol,
                                                style: textTheme.bodySmall),
                                          ],
                                        ),
                                        Flexible(
                                            child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                              filterColor, BlendMode.srcATop),
                                          child: SvgPicture.network(
                                              'https://s3.coinmarketcap.com/generated/sparklines/web/30d/2781/$tokenId.svg'),
                                        )),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: Column(
                                              children: [
                                                Text('\$$finalPrice',
                                                    style: textTheme.bodySmall),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10, right: 8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      percentIcon,
                                                      Text("$percentChange%",
                                                          style: GoogleFonts
                                                              .ubuntu(
                                                                  color:
                                                                      percentColor,
                                                                  fontSize:
                                                                      15)),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const Divider(
                                    color: Colors.grey,
                                  );
                                },
                                itemCount: cryptoModel!.length),
                          )
                        ],
                      );

                    case Status.ERROR:
                      return Text(marketViewProvider.state.message);
                    default:
                      return Container();
                  }
                },
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget shimmerMarketView() {
    return SizedBox(
      height: 80,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade400,
        highlightColor: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 10, right: 10),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          child: Icon(Icons.add),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0, left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 50,
                                height: 15,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  width: 25,
                                  height: 15,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: SizedBox(
                          width: 70,
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 50,
                                height: 15,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  width: 25,
                                  height: 15,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

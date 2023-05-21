import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_crypto/data/models/CryptoModel/CryptoData.dart';
import 'package:flutter_application_crypto/providers/crypto_data_provider.dart';
import 'package:flutter_application_crypto/ui/ui_helper/slider_widget.dart';
import 'package:flutter_application_crypto/ui/ui_helper/theme_switcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../data/data_source/response_model.dart';
import '../helpers/decimal_rounder.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _sliderController = PageController(initialPage: 0);
  var defaultChoiceIndex = 0;
  final List<String> _choicesList = [
    'Top MarketCaps',
    'Top Gainers',
    'Top Losers'
  ];

  @override
  void initState() {
    super.initState();
    final cryptoDataProvider = Provider.of<CryptoDataProvider>(context, listen: false);
    cryptoDataProvider.getTopMarketCapData();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var primaryColor = Theme.of(context).primaryColor;
    TextTheme textTheme = Theme.of(context).textTheme;

    final cryptoDataProvider =
        Provider.of<CryptoDataProvider>(context, listen: false);
    return Scaffold(
        drawer: const Drawer(),
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text("ExchangeApp"),
          titleTextStyle: textTheme.titleLarge,
          centerTitle: true,
          actions: const [ThemeSwitcher()],
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
                  child: SizedBox(
                    height: 140,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        SliderWidget(controller: _sliderController),
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SmoothPageIndicator(
                              controller: _sliderController,
                              count: 4,
                              effect: const ExpandingDotsEffect(
                                  dotColor: Colors.grey,
                                  activeDotColor: Colors.purple,
                                  dotWidth: 10,
                                  dotHeight: 10),
                              onDotClicked: (index) =>
                                  _sliderController.animateToPage(index,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Text Marquee
                SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: Marquee(
                    text: '🔊 this is place for news in application',
                    style: textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 5),
                // Button buy & sell
                Padding(
                  padding: const EdgeInsets.only(right: 5.0, left: 5.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              padding: const EdgeInsets.all(20),
                              primary: Colors.green[700]),
                          child: const Text('Buy'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              padding: const EdgeInsets.all(20),
                              primary: Colors.red[700]),
                          child: const Text('Sell'),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                //ChoiceChip
                Padding(
                  padding: const EdgeInsets.only(right: 5.0, left: 5.0),
                  child: Row(
                    children: [
                      Wrap(
                          spacing: 8,
                          children: List.generate(_choicesList.length, (index) {
                            return ChoiceChip(
                              label: Text(
                                _choicesList[index],
                                style: textTheme.titleSmall,
                              ),
                              selected: defaultChoiceIndex == index,
                              selectedColor: Colors.blue,
                              onSelected: (value) {
                                setState(() {
                                  defaultChoiceIndex =
                                      value ? index : defaultChoiceIndex;
                                  switch (index) {
                                    case 0:
                                      cryptoDataProvider.getTopMarketCapData();
                                      break;
                                    case 1:
                                      cryptoDataProvider.getTopGainersData();
                                      break;
                                    case 2:
                                      cryptoDataProvider.getTopLosersData();
                                      break;
                                  }
                                });
                              },
                            );
                          }))
                    ],
                  ),
                ),
                // List Crypto
                SizedBox(
                  height: 500,
                  child: Consumer<CryptoDataProvider>(
                      builder: (context, cryptoDataProvider, child) {
                    switch (cryptoDataProvider.state.status) {
                      case Status.LOADING:
                        //ShimmerEffect
                        return SizedBox(
                          height: 80,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade400,
                            highlightColor: Colors.white,
                            child: ListView.builder(
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          top: 8.0, bottom: 8.0, left: 8.0),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 30,
                                        child: Icon(Icons.add),
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 8.0, left: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 50,
                                              height: 15,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: SizedBox(
                                                width: 25,
                                                height: 15,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
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
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: 50,
                                              height: 15,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: SizedBox(
                                                width: 25,
                                                height: 15,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
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
                        );
                      case Status.COMPLETED:
                        List<CryptoData>? cryptoModel = cryptoDataProvider.dataFuture.data!.cryptoCurrencyList;
                        return ListView.separated(
                            itemBuilder: (context, index) {
                              var number = index + 1;
                              var tokenId = cryptoModel![index].id;
                              MaterialColor filterColor = DecimalRounder.setColorFilter(cryptoModel[index].quotes![0].percentChange30d);
                              var finalPrice = DecimalRounder.removePriceDecimals(cryptoModel[index].quotes![0].price);
                              // percent change setup decimals and colors
                              var percentChange = DecimalRounder.removePercentDecimals(cryptoModel[index].quotes![0].percentChange24h);
                              Color percentColor = DecimalRounder.setPercentChangesColor(cryptoModel[index].quotes![0].percentChange24h);
                              Icon percentIcon = DecimalRounder.setPercentChangesIcon(cryptoModel[index].quotes![0].percentChange24h);
                              var name  = cryptoModel[index].name!;
                              var symbol =cryptoModel[index].symbol!;
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
                                        fadeInDuration:
                                            const Duration(milliseconds: 500),
                                        height: 32,
                                        width: 32,
                                        imageUrl:
                                            'https://s2.coinmarketcap.com/static/img/coins/32x32/$tokenId.png',
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(name.length > 10 ? '${name.substring(0, 8)}...' : name, style: textTheme.bodySmall),
                                          Text(symbol.length > 10 ? '${symbol.substring(0, 8)}...' : symbol, style: textTheme.bodySmall),
                                        ],
                                      ),
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
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                percentIcon,
                                                Text("$percentChange%",
                                                    style: GoogleFonts.ubuntu(
                                                        color: percentColor,
                                                        fontSize: 15))
                                              ],
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
                            itemCount: cryptoModel!.length);

                      case Status.ERROR:
                        return Text(cryptoDataProvider.state.message);

                      default:
                        return Container();
                    }
                  }),
                ),
              ],
            ),
          ),
        ));
  }
}

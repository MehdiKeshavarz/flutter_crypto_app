import 'package:dio/dio.dart';

class ApiProvider{

 final Dio _dio = Dio();


 dynamic getAllCryptoData() async {
   final response = await Dio().get("https://api.coinmarketcap.com/data-api/v3/cryptocurrency/listing?start=1&limit=1000&sortBy=market_cap&sortType=desc&convert=USD&cryptoType=all&tagType=all&audited=false&aux=ath,atl,high24h,low24h,num_market_pairs,cmc_rank,date_added,max_supply,circulating_supply,total_supply,volume_7d,volume_30d,self_reported_circulating_supply,self_reported_market_cap",);
   return response;
 }


 dynamic getTopMarketCapData() async{
    Response response;
    response = await _dio.get("https://api.coinmarketcap.com/data-api/v3/cryptocurrency/listing?start=1&limit=30&sortBy=market_cap&sortType=desc&convert=USD&cryptoType=all&tagType=all&audited=false&aux=ath,atl,high24h,low24h,num_market_pairs,cmc_rank,date_added,max_supply,circulating_supply,total_supply,volume_7d,volume_30d,self_reported_circulating_supply,self_reported_market_cap");
    return response;
  }

 dynamic getTopGainersData() async{
   Response response;
   response = await _dio.get("https://api.coinmarketcap.com/data-api/v3/cryptocurrency/listing?start=1&limit=30&sortBy=percent_change_24h&sortType=desc&convert=USD&cryptoType=all&tagType=all&audited=false&aux=ath,atl,high24h,low24h,num_market_pairs,cmc_rank,date_added,max_supply,circulating_supply,total_supply,volume_7d,volume_30d,self_reported_circulating_supply,self_reported_market_cap");
   return response;
 }


 dynamic getTopLosersData() async{
   Response response;
   response = await _dio.get("https://api.coinmarketcap.com/data-api/v3/cryptocurrency/listing?start=1&limit=30&sortBy=percent_change_24h&sortType=asc&convert=USD&cryptoType=all&tagType=all&audited=false&aux=ath,atl,high24h,low24h,num_market_pairs,cmc_rank,date_added,max_supply,circulating_supply,total_supply,volume_7d,volume_30d,self_reported_circulating_supply,self_reported_market_cap");
   return response;
 }


}
using FreightShipWSSample.FreightShipWebReference;
using System;
using System.Diagnostics;
using System.Net;
using System.ServiceModel;
using System.Text;
using System.Web.Services.Protocols;
using System.Xml;
using Znode.Engine.Api.Models;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Libraries.Framework.Business;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Configuration;
using static Znode.Libraries.ECommerce.Utilities.ZnodeDependencyResolver;
using Newtonsoft.Json.Linq;
using Znode.Api.Model.Custom.CustomUpsModel;
using System.Collections.Specialized;
using System.Web;

namespace Znode.Engine.Shipping.Ups
{
    public class UpsAgent : ZnodeBusinessBase
    {
        public string ErrorCode { get; set; }
        public string ErrorDescription { get; set; }
        public decimal PackageHeight { get; set; }
        public decimal PackageLength { get; set; }
        public string PackageTypeCode { get; set; }
        public decimal PackageWeight { get; set; }
        public decimal PackageWidth { get; set; }
        public string PickupType { get; set; } = "One Time Pickup";
        public string ShipperCountryCode { get; set; }
        public string ShipperZipCode { get; set; }
        public string ShipperCityName { get; set; }
        public string ShipToAddressType { get; set; } = "Residential";
        public string ShipToCountryCode { get; set; }
        public string ShipToZipCode { get; set; }
        public string ShipToCity { get; set; }
        public string ShipStateProvinceCode { get; set; }
        public string UpsGatewayUrl { get; set; } = ZnodeApiSettings.UPSGatewayURL;
        public string UpsAddressValidationUrl { get; set; } = ZnodeApiSettings.UPSAddressValidationURL;
        public string UpsKey { get; set; }
        public string UpsPassword { get; set; }
        public string UpsServiceCode { get; set; }
        public string UpsUserId { get; set; }
        public string UpsNumofPieces { get; set; }//Atish ups 00
        public string WeightUnit { get; set; } = "LBS";
        public string LTLUpsUserName { get; set; }
        public string LTLUpsPassword { get; set; }
        public string LTLUpsAccessLicenseNumber { get; set; }
        public string[] LTLRequestOption { get; set; }
        public string[] LTLShipFromAddressLines { get; set; }
        public string LTLStateProvinceCode { get; set; }
        public string LTLCountryCode { get; set; }
        public string LTLShipFromName { get; set; }
        public string LTLUpsAccountNumber { get; set; }
        public string LTLShipFromPhoneNumber { get; set; }
        public string LTLShipFromShipperNumber { get; set; }
        public string[] LTLShipToAddressLines { get; set; }
        public string LTLShipToName { get; set; }
        public string LTLShipToPhoneNumber { get; set; }
        public string[] LTLPayerAddressLines { get; set; }
        public string LTLPayerCity { get; set; }
        public string LTLPayerStateProvinceCode { get; set; }
        public string LTLPayerCountryCode { get; set; }
        public string LTLPayerPostalCode { get; set; }
        public string LTLShipBillOptionCode { get; set; }
        public string LTLShipBillOptionDescription { get; set; }
        public string LTLCommodityNumberOfPieces { get; set; }
        public string LTLNMFCCommodityPrimeCode { get; set; }
        public string LTLNMFCCommoditySubCode { get; set; }
        public string LTLCommodityFreightClass { get; set; }
        public string LTLPackagingTypeCode { get; set; }
        public string LTLPackagingTypeDescription { get; set; }
        public string LTLCommodityValueCurrencyCode { get; set; }
        public string LTLCommodityValueMonetaryValue { get; set; }
        public string LTLCommodityDescription { get; set; }
        public string LTLHandlingUnitQuantity { get; set; }
        public string LTLHandlingUnitTypeCode { get; set; }
        public string LTLHandlingUnitTypeDescription { get; set; }
        public string LTLShipFromCity { get; set; }
        public string LTLPayerName { get; set; }
        public string LTLPayerPhoneNumber { get; set; }
        public string LTLPayerUPSAccountNumber { get; set; }
        public string LTLUnitOfMeasurementDescription { get; set; }
        public decimal PackageWeightLimit { get; set; }
        public string PackageXml { get; set; }

        private readonly string IsEstimateDateProductionURL = Convert.ToString(ConfigurationManager.AppSettings["UPSGatewayProductionTimeInTransit"]).ToLower();
        private readonly string ProductionEstimateDateURL = Convert.ToString(ConfigurationManager.AppSettings["UPSGatewayProductionTimeInTransitURL"]);
        private readonly string DevelopmentEstimateDateURL = Convert.ToString(ConfigurationManager.AppSettings["UPSGatewayDevelopmentTimeInTransitURL"]);

        public ShippingRateModel GetShippingRate()
        {
            ShippingRateModel model = new ShippingRateModel();
            // The 0 is the commercial address type
            var addressType = Equals(ShipToAddressType, "Residential") ? "1" : "0";

            // Build the payload for sending to UPS
            StringBuilder payload = new StringBuilder();
            string isAddressValid = Equals(ShipToCountryCode?.ToLower(), "us") ? GetAddressValidation() : "1";
            payload.Append("<?xml version='1.0'?>")
            .Append("<AccessRequest xml:lang='en-US'>")
            .Append("    <AccessLicenseNumber>" + UpsKey + "</AccessLicenseNumber>")
            .Append("    <UserId>" + UpsUserId + "</UserId>")
            .Append("    <Password>" + UpsPassword + "</Password>")
            .Append("</AccessRequest>")
            .Append("<?xml version='1.0'?>")
            .Append("<RatingServiceSelectionRequest xml:lang='en-US'>")
            .Append("   <Request>")
            .Append("       <TransactionReference>")
            .Append("           <CustomerContext>Rating and Service</CustomerContext>")
            .Append("           <XpciVersion>1.0001</XpciVersion>")
            .Append("       </TransactionReference>")
            .Append("       <RequestAction>Rate</RequestAction>")
            .Append("       <RequestOption>Rate</RequestOption>")
            .Append("   </Request>")
            .Append("   <PickupType>")
            .Append("       <Code>" + PickupType + "</Code>")
            .Append("   </PickupType>")
            .Append("   <Shipment>")
            .Append("       <Shipper>")
            .Append("           <Address>")
            .Append("               <PostalCode>" + ShipperZipCode + "</PostalCode>")
            .Append("               <CountryCode>" + ShipperCountryCode + "</CountryCode>")
            .Append("           </Address>")
            .Append("       </Shipper>")
            .Append("       <ShipTo>")
            .Append("           <Address>")
            .Append("               <PostalCode>" + ShipToZipCode + "</PostalCode>")
            .Append("               <CountryCode>" + ShipToCountryCode + "</CountryCode>")
            .Append("               <ResidentialAddress>" + addressType + "</ResidentialAddress>")
            .Append("           </Address>")
            .Append("       </ShipTo>")
            .Append("       <Service>")
            .Append("           <Code>" + UpsServiceCode + "</Code>")
            .Append("       </Service>")
            .Append("       <Package>")
            .Append("           <PackagingType>")
            .Append("               <Code>" + PackageTypeCode + "</Code>")
            .Append("           </PackagingType>")
            .Append("           <Dimensions>")
            .Append("               <UnitOfMeasurement>")
            .Append("                   <Code>IN</Code>")
            .Append("               </UnitOfMeasurement>")
            .Append("               <Length>" + PackageLength + "</Length>")
            .Append("               <Width>" + PackageWidth + "</Width>")
            .Append("               <Height>" + PackageHeight + "</Height>")
            .Append("           </Dimensions>")
            .Append("           <PackageWeight>")
            .Append("               <UnitOfMeasurement>")
            .Append("                   <Code>" + WeightUnit + "</Code>")
            .Append("               </UnitOfMeasurement>")
            .Append("               <Weight>" + (PackageWeight == 0 ? 1 : PackageWeight) + "</Weight>")
            .Append("           </PackageWeight>")
            .Append("       </Package>")
            .Append("   </Shipment>")
            .Append("</RatingServiceSelectionRequest>");

            try
            {
                decimal shippingRate = 0;

                if (Equals(isAddressValid, "0"))
                {
                    // Get response error code and description
                    ErrorCode = "1";
                    ErrorDescription = "Invalid Address";
                    return new ShippingRateModel { ShippingRate = shippingRate };
                }
                else
                {

                    // Instantiate the request
                    WebClient request = new WebClient();
                    request.Headers.Add("Content-Type", "application/x-www-form-urlencoded");

                    // Convert the payload into byte array and send the request to UPS
                    byte[] requestBytes = Encoding.ASCII.GetBytes(payload.ToString());
                    byte[] responseBytes = request.UploadData(UpsGatewayUrl, "POST", requestBytes);

                    // Decode the response bytes into an XML string and create an XML document from it
                    string xmlResponse = Encoding.ASCII.GetString(responseBytes);
                    XmlDocument xmlDocument = new XmlDocument();
                    xmlDocument.LoadXml(xmlResponse);

                    var responseCodesNodes = xmlDocument.SelectNodes("RatingServiceSelectionResponse/Response/ResponseStatusCode");
                    if (responseCodesNodes?.Count > 0 && responseCodesNodes[0].InnerText.Equals("1"))
                    {
                        // Get response charges
                        XmlNodeList chargesNodes = xmlDocument.SelectNodes("RatingServiceSelectionResponse/RatedShipment/TotalCharges/MonetaryValue");
                        if (chargesNodes?.Count > 0)
                        {
                            ErrorCode = "0";
                            shippingRate = Decimal.Parse(chargesNodes[0].InnerText);
                        }
                    }
                    else
                    {
                        // Get response error code and description
                        ErrorCode = xmlDocument.SelectNodes("RatingServiceSelectionResponse/Response/Error/ErrorCode")[0].InnerText;
                        ErrorDescription = xmlDocument.SelectNodes("RatingServiceSelectionResponse/Response/Error/ErrorDescription")[0].InnerText;
                    }

                    model.ShippingRate = shippingRate;
                    return model;
                }
            }
            catch (Exception ex)
            {
                ZnodeLogging.LogMessage(ex, "Shipping", TraceLevel.Error);
                ErrorCode = "Connection failed.";
                ErrorDescription = "Error while trying to connect with host server. Please try again.";
                return new ShippingRateModel();
            }
        }

        // Get LTL shipping rate.
        public ShippingRateModel GetLTLShippingRate()
        {
            try
            {
                ShippingRateModel model = new ShippingRateModel();
                FreightShipService freightShipService = new FreightShipService();
                FreightShipRequest freightShipRequest = new FreightShipRequest();
                RequestType request = new RequestType();

                request.RequestOption = LTLRequestOption;
                freightShipRequest.Request = request;
                ShipmentType shipment = new ShipmentType();

                ShipFromType shipFrom = new ShipFromType();

                shipment.ShipFrom = GetLTLShipFrom(shipFrom);

                shipment.ShipperNumber = LTLUpsAccountNumber;

                ShipToType shipTo = new ShipToType();
                shipment.ShipTo = GetLTLShiptTo(shipTo);

                PaymentInformationType paymentInfo = new PaymentInformationType();
                shipment.PaymentInformation = GetLTLPaymentInfo(paymentInfo);

                ShipCodeDescriptionType service = new ShipCodeDescriptionType();
                service.Code = UpsServiceCode;
                shipment.Service = service;

                CommodityType commodity = new CommodityType();
                shipment.Commodity = GetLTLCommodityDetails(commodity);

                HandlingUnitType handlingUnit = new HandlingUnitType();
                shipment.HandlingUnitOne = GetHandlingUnit(handlingUnit);

                UPSSecurity upss = new UPSSecurity();
                freightShipService.UPSSecurityValue = GetUPSSecurity(upss);

                freightShipRequest.Shipment = shipment;

                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

                FreightShipResponse freightShipResponse = freightShipService.ProcessShipment(freightShipRequest);

                model.ShippingRate = Convert.ToDecimal(freightShipResponse.ShipmentResults.TotalShipmentCharge.MonetaryValue);
                return model;
            }
            catch (SoapException ex)
            {
                ZnodeLogging.LogMessage(ex, "Shipping", TraceLevel.Error);
                ErrorCode = "Connection failed.";
                ErrorDescription = (!string.IsNullOrEmpty(ex.Message) ? ex.Message : "") + " " + (!string.IsNullOrEmpty(ex.Detail.LastChild.InnerText) ? ex.Detail.LastChild.InnerText : "") + " " + (!string.IsNullOrEmpty(ex.Detail.LastChild.OuterXml) ? ex.Detail.LastChild.OuterXml : "");
                return new ShippingRateModel();

            }
            catch (CommunicationException ex)
            {
                ZnodeLogging.LogMessage(ex, "Shipping", TraceLevel.Error);
                ErrorCode = "Connection failed.";
                ErrorDescription = ex.Message;
                return new ShippingRateModel();

            }
            catch (Exception ex)
            {
                ZnodeLogging.LogMessage(ex, "Shipping", TraceLevel.Error);
                ErrorCode = "Connection failed.";
                ErrorDescription = ex.Message;
                return new ShippingRateModel();
            }

        }

        // Get LTL ship from address.
        private ShipFromType GetLTLShipFrom(ShipFromType shipFrom)
        {
            FreightShipAddressType shipFromAddress = new FreightShipAddressType();

            shipFromAddress.AddressLine = LTLShipFromAddressLines;
            shipFromAddress.City = LTLShipFromCity;
            shipFromAddress.StateProvinceCode = LTLStateProvinceCode;
            shipFromAddress.PostalCode = ShipperZipCode;
            shipFromAddress.CountryCode = LTLCountryCode;
            shipFrom.Address = shipFromAddress;
            shipFrom.Name = LTLShipFromName;

            FreightShipPhoneType shipFromPhone = new FreightShipPhoneType();
            shipFromPhone.Number = LTLShipFromPhoneNumber;
            shipFrom.Phone = shipFromPhone;

            return shipFrom;
        }

        // Get LTL ship to address.
        private ShipToType GetLTLShiptTo(ShipToType shipTo)
        {
            FreightShipAddressType shipToAddress = new FreightShipAddressType();

            shipToAddress.AddressLine = LTLShipToAddressLines;
            shipToAddress.City = ShipToCity;
            shipToAddress.StateProvinceCode = ShipStateProvinceCode;
            shipToAddress.PostalCode = ShipToZipCode;
            shipToAddress.CountryCode = ShipToCountryCode;
            shipTo.Address = shipToAddress;
            shipTo.Name = LTLShipToName;
            FreightShipPhoneType shipToPhone = new FreightShipPhoneType();
            shipToPhone.Number = LTLShipToPhoneNumber;
            shipTo.Phone = shipToPhone;
            return shipTo;
        }

        // Get LTL payment info.
        private PaymentInformationType GetLTLPaymentInfo(PaymentInformationType paymentInfo)
        {
            PayerType payer = new PayerType();
            payer.Name = LTLPayerName;

            FreightShipPhoneType payerPhone = new FreightShipPhoneType();
            payerPhone.Number = LTLPayerPhoneNumber;
            payer.Phone = payerPhone;

            payer.ShipperNumber = LTLPayerUPSAccountNumber;

            FreightShipAddressType payerAddress = new FreightShipAddressType();

            payerAddress.AddressLine = LTLPayerAddressLines;
            payerAddress.City = LTLPayerCity;
            payerAddress.StateProvinceCode = LTLPayerStateProvinceCode;
            payerAddress.PostalCode = LTLPayerPostalCode;
            payerAddress.CountryCode = LTLPayerCountryCode;
            payer.Address = payerAddress;
            paymentInfo.Payer = payer;

            ShipCodeDescriptionType shipBillOption = new ShipCodeDescriptionType();
            shipBillOption.Code = LTLShipBillOptionCode;
            shipBillOption.Description = LTLShipBillOptionDescription;
            paymentInfo.ShipmentBillingOption = shipBillOption;

            return paymentInfo;
        }

        // Get LTL commodity details.
        private CommodityType[] GetLTLCommodityDetails(CommodityType commodity)
        {
            commodity.NumberOfPieces = LTLCommodityNumberOfPieces;
            NMFCCommodityType nmfcCommodity = new NMFCCommodityType();
            nmfcCommodity.PrimeCode = LTLNMFCCommodityPrimeCode;
            nmfcCommodity.SubCode = LTLNMFCCommoditySubCode;
            commodity.NMFCCommodity = nmfcCommodity;
            commodity.FreightClass = LTLCommodityFreightClass;

            ShipCodeDescriptionType packagingType = new ShipCodeDescriptionType();
            packagingType.Code = LTLPackagingTypeCode;
            packagingType.Description = LTLPackagingTypeDescription;
            commodity.PackagingType = packagingType;
            WeightType weight = new WeightType();
            // We truncate after two decimal places because UPS LTL service not able to calculate shipping rate.
            // its take two digit after the decimal. 
            weight.Value = Convert.ToString(decimal.Truncate(PackageWeight * 100m) / 100m);

            FreightShipUnitOfMeasurementType unitOfMeasurement = new FreightShipUnitOfMeasurementType();
            unitOfMeasurement.Code = WeightUnit;
            unitOfMeasurement.Description = LTLUnitOfMeasurementDescription;
            weight.UnitOfMeasurement = unitOfMeasurement;
            commodity.Weight = weight;

            CommodityValueType commodityValue = new CommodityValueType();
            commodityValue.CurrencyCode = LTLCommodityValueCurrencyCode;
            commodityValue.MonetaryValue = LTLCommodityValueMonetaryValue;
            commodity.CommodityValue = commodityValue;
            commodity.Description = LTLCommodityDescription;

            CommodityType[] commodityArray = { commodity };

            return commodityArray;
        }

        // Get LTL handling unit.
        private HandlingUnitType GetHandlingUnit(HandlingUnitType handlingUnit)
        {
            handlingUnit.Quantity = LTLHandlingUnitQuantity;
            ShipCodeDescriptionType handlingUnitType = new ShipCodeDescriptionType();
            handlingUnitType.Code = LTLHandlingUnitTypeCode;
            handlingUnitType.Description = LTLHandlingUnitTypeDescription;
            handlingUnit.Type = handlingUnitType;
            return handlingUnit;
        }

        // Get LTL UPS security credentials.
        private UPSSecurity GetUPSSecurity(UPSSecurity upss)
        {
            UPSSecurityServiceAccessToken upssSvcAccessToken = new UPSSecurityServiceAccessToken();
            upssSvcAccessToken.AccessLicenseNumber = LTLUpsAccessLicenseNumber;
            upss.ServiceAccessToken = upssSvcAccessToken;
            UPSSecurityUsernameToken upssUsrNameToken = new UPSSecurityUsernameToken();
            upssUsrNameToken.Username = LTLUpsUserName;
            upssUsrNameToken.Password = LTLUpsPassword;
            upss.UsernameToken = upssUsrNameToken;

            return upss;
        }

        /// <summary>
        /// To perform UPS address validation service.
        /// </summary>
        /// <returns>Error 1 / 0 if address is invalid then return 0 otherwise 1.</returns>
        private string GetAddressValidation()
        {
            // Instantiate the request
            WebClient addressRequest = new WebClient();
            addressRequest.Headers.Add("Content-Type", "application/x-www-form-urlencoded");

            StringBuilder addressResponse = new StringBuilder();

            // To get rate for worldwide, need to remove postal code. 
            if (!Equals(ShipToCountryCode.ToLower(), "us"))
                ShipToZipCode = "";

            addressResponse.Append("<?xml version='1.0'?>")
            .Append("<AccessRequest>")
            .Append("	<AccessLicenseNumber>" + UpsKey + "</AccessLicenseNumber>")
            .Append("	<UserId>" + UpsUserId + "</UserId>")
            .Append("	<Password>" + UpsPassword + "</Password>")
            .Append("</AccessRequest>")
            .Append("<?xml version='1.0'?>")
            .Append("<AddressValidationRequest xml:lang='enum-US'>")
            .Append("   <Request>")
            .Append("       <TransactionReference>")
            .Append("           <CustomerContext>Address Validation</CustomerContext>")
            .Append("           <XpciVersion>1.0001</XpciVersion>")
            .Append("       </TransactionReference>")
            .Append("   <RequestAction>AV</RequestAction>")
            .Append("   </Request>")
            .Append("       <Address>")
            .Append("           <StateProvinceCode>" + ShipStateProvinceCode + "</StateProvinceCode>")
            .Append("           <City>" + ShipToCity + "</City>")
            .Append("		    <PostalCode>" + ShipToZipCode + "</PostalCode>")
            .Append("       </Address>")
            .Append("</AddressValidationRequest>");

            // Convert the addressResponse into byte array and send the request to UPS
            byte[] requestBytesTest = Encoding.ASCII.GetBytes(addressResponse.ToString());

            byte[] requestAVBytes = addressRequest.UploadData(UpsAddressValidationUrl, "POST", requestBytesTest);

            // Decode the response bytes into an XML string and create an XML document from it
            string xmlAddressResponse = Encoding.ASCII.GetString(requestAVBytes);

            XmlDocument xDoc = new XmlDocument();
            xDoc.LoadXml(xmlAddressResponse);
            XmlNodeList addressValidationResponse = xDoc.SelectNodes("AddressValidationResponse/Response");
            string addressValidationErrorMessage = addressValidationResponse.Item(0).SelectSingleNode("ResponseStatusDescription").InnerText;
            XmlNodeList errorRank = xDoc.SelectNodes("AddressValidationResponse/AddressValidationResult/Rank");
            ZnodeLogging.LogMessage($"The zipcode: {ShipToZipCode} ,city: {ShipToCity} and StateProvinceCode : {ShipStateProvinceCode}  is returns the address validation message as {addressValidationErrorMessage} for ups.");
            return string.Equals(addressValidationErrorMessage, "Success", StringComparison.InvariantCultureIgnoreCase) ? "1" : Equals(addressValidationErrorMessage, "Failure") ? "0" : (errorRank.Count > 1) ? "0" : "1";
        }

        public List<ShippingModel> GetUPSEstimateRate()
        {
            List<ShippingModel> listWithRates = new List<ShippingModel>();
            XmlDocument xmlDocument = GetUPSResponse(GetEstimateRateXML(), ZnodeApiSettings.UPSGatewayURL);

            Dictionary<string, string> estimateDate = GetEstimateDate();

            var responseCodesNodes = xmlDocument.SelectNodes("RatingServiceSelectionResponse/Response/ResponseStatusCode");

            if (responseCodesNodes?.Count > 0 && responseCodesNodes[0].InnerText.Equals("1"))
            {
                // Get response charges
                XmlNode ratedShipment = xmlDocument.SelectSingleNode("RatingServiceSelectionResponse/RatedShipment");
                if (HelperUtility.IsNotNull(ratedShipment))
                {
                    ErrorCode = "0";

                    XmlNodeList serviceCodes = xmlDocument.SelectNodes("RatingServiceSelectionResponse/RatedShipment/Service");

                    XmlNodeList totalCharges = xmlDocument.SelectNodes("RatingServiceSelectionResponse/RatedShipment/TotalCharges/MonetaryValue");

                    if (serviceCodes?.Count > 0)
                    {
                        for (int index = 0; index < serviceCodes.Count; index++)
                        {
                            string serviceCode = GetDateByServiceCode(serviceCodes[index].InnerText);
                            string arrivalDate = Convert.ToString(estimateDate?.Where(w => w.Key == serviceCode)?.Select(s => s.Value)?.FirstOrDefault());
                            if (!string.IsNullOrEmpty(arrivalDate) || !Equals(ShipToCountryCode?.ToLower(), "us"))
                            {
                                listWithRates.Add(
                                               new ShippingModel
                                               {
                                                   ShippingCode = serviceCodes[index].InnerText,
                                                   ShippingRate = Convert.ToDecimal(totalCharges[index].InnerText),
                                                   EstimateDate = arrivalDate
                                               });
                            }
                        }
                    }
                }
            }
            else
            {
                // Get response error code and description
                ErrorCode = xmlDocument.SelectNodes("RatingServiceSelectionResponse/Response/Error/ErrorCode")[0].InnerText;
                ErrorDescription = xmlDocument.SelectNodes("RatingServiceSelectionResponse/Response/Error/ErrorDescription")[0].InnerText;
            }

            return listWithRates ?? new List<Api.Models.ShippingModel>();
        }
        //Atish Nivi code ups start

        private void WriteLogs(string strValue)
        {
            try
            {
                string basepath = AppDomain.CurrentDomain.BaseDirectory + "/PHSLogs/";
                // create directory if not exists
                System.IO.Directory.CreateDirectory(basepath);

                //Logfile
                string path = basepath + "phlog_" + DateTime.Now.ToString("dd-MM-yyyy") + ".txt";
                using (System.IO.StreamWriter sw = System.IO.File.AppendText(path))
                {
                    sw.WriteLine(DateTime.Now.ToString("dd-MM-yyyy hh:mm::ss tt =>") + strValue);
                }
            }
            catch (Exception ex)
            {

            }
        }
        public List<ShippingModel> CustomGetUPSEstimateRate()
        {
            List<ShippingModel> listWithRates = new List<ShippingModel>();
            JObject jsonObject = new JObject();
            string JsonReponseUps = null;
                try
                {
                    JsonReponseUps = CustomGetUPSResponse(GetEstimateRatejson(), CustomUpsSettings.OauthTokenUrl, CustomUpsSettings.RateUrl, CustomUpsSettings.ClientID, CustomUpsSettings.Clientsecret);

                    jsonObject = JObject.Parse(JsonReponseUps);
         
                }
                catch (Exception ex)
                {
                    ZnodeLogging.LogMessage("Nivi Ups Error :" + ex.Message, ZnodeLogging.Components.OMS.ToString(), TraceLevel.Error);
                //Atish ups change for handeling weight > 150
                var UPSerror = new Dictionary<string, string>();
                UPSerror.Add("Error", JsonReponseUps);
                UPSerror.Add("Weight", Convert.ToString(PackageWeight));
                CustomUpsSettings.UPSResponse = Newtonsoft.Json.JsonConvert.SerializeObject(UPSerror); //Atish ups change for weight error
                return new List<ShippingModel>();
            }


            WriteLogs("NIVI Ups response :" + Newtonsoft.Json.JsonConvert.SerializeObject(jsonObject));
            var responseStatus = jsonObject["RateResponse"]["Response"]["ResponseStatus"];


            string responseStatusCode = responseStatus["Code"].ToString();

            if (responseStatus.Count() > 0 && responseStatusCode == "1")
            {
                JToken ratedShipments = jsonObject["RateResponse"]["RatedShipment"];

                if (ratedShipments != null)
                {
                    //Dictionary<string, string> estimateDate = CustomGetEstimateDate();

                    foreach (var shipment in ratedShipments)
                    {
                        string serviceCode = GetDateByServiceCode(shipment["Service"]["Code"].ToString());
                        decimal monetaryValue = decimal.Parse(shipment["TotalCharges"]["MonetaryValue"].ToString());
                        

                        // Check if the service code is not empty before adding it to the list
                        if (!string.IsNullOrEmpty(serviceCode))
                        {
                            //string arrivalDate = Convert.ToString(estimateDate?.Where(w => w.Key == serviceCode)?.Select(s => s.Value)?.FirstOrDefault());
                                listWithRates.Add(
                                    new ShippingModel
                                    {
                                        ShippingCode = shipment["Service"]["Code"].ToString(),
                                        ShippingRate = monetaryValue,
                                        //EstimateDate = arrivalDate
                                      
                                    });
                            
                        }
                    }
                }
            }
            else
            {
                // Handle the case where the response status code is not "1"
                ErrorCode = responseStatusCode;
                ErrorDescription = responseStatus["Description"].ToString();
            }

            return listWithRates ?? new List<Api.Models.ShippingModel>();

        }

        public string CustomGetUPSResponse (string estimateRateJson, string oauthTokenUrl, string rateUrl, string clientID, string clientsecret)
        {
            try
            {
                string credentials = clientID + ":" + clientsecret;
                string base64Credentials = Convert.ToBase64String(Encoding.UTF8.GetBytes(credentials));
                string AuthorizationHeader = "Basic" + " " + base64Credentials;

                byte[] responseBytes;

                WebClient request = new WebClient();
                request.Headers.Add("Content-Type", "application/json");
                request.Headers.Add("transId", "Packaging Hero");
                request.Headers.Add("transactionSrc", "testing");
                string Token = GetTokenFromUPS(AuthorizationHeader, oauthTokenUrl);
                request.Headers.Add("Authorization", "Bearer" + " " + Token);
                byte[] requestBytes = Encoding.ASCII.GetBytes(estimateRateJson);
                responseBytes = request.UploadData(rateUrl, "POST", requestBytes);


                string jsonResponse = Encoding.UTF8.GetString(responseBytes);
                WriteLogs("NIVI inside exact response :" + Newtonsoft.Json.JsonConvert.SerializeObject(jsonResponse));
                return jsonResponse;
            }
            catch (Exception ex)
            {
                ZnodeLogging.LogMessage("Error in CustomGetUPSResponse method is " + ex.Message, ZnodeLogging.Components.OMS.ToString(), TraceLevel.Error);
                return ex.Message ;
            }
            
   
        }

        public string GetTokenFromUPS(string BasicAuthHeader,string tokenUrl)
        {
            WebClient request = new WebClient();
            NameValueCollection requestBody = new NameValueCollection();
            requestBody["grant_type"] = "client_credentials";

            // Convert the request body parameters to a byte array
            byte[] requestData = Encoding.UTF8.GetBytes($"grant_type={WebUtility.UrlEncode(requestBody["grant_type"])}");
            request.Headers.Add("Content-Type", "application/x-www-form-urlencoded");
            request.Headers.Add("Authorization", BasicAuthHeader);

            byte[] responseData = request.UploadData(tokenUrl, "POST", requestData);

            string jsonResponse = Encoding.UTF8.GetString(responseData);

            // Parse the JSON response
            JObject responseObj = JObject.Parse(jsonResponse);

            // Retrieve the token field from the JSON response
            string token = responseObj["access_token"].ToString();

            return token;

        }

        public string GetEstimateRatejson()//Atish ups 00
        {
            JArray PackageArray = JArray.Parse(PackageXml);//Atish ups 00
            // Create a dynamic object to represent the JSON structure
            JObject jsonData = new JObject(
    new JProperty("RateRequest",
        new JObject(
            new JProperty("Request",
                new JObject(
                    new JProperty("TransactionReference",
                        new JObject(
                            new JProperty("CustomerContext", "Rating and Service")
                        )
                    )
                )
            ),
            new JProperty("Shipment",
                new JObject(
                    new JProperty("Shipper",
                        new JObject(
                            new JProperty("Name", ""),
                            new JProperty("Address",
                                new JObject(
                                    new JProperty("AddressLine", new JArray("", "", "")),
                                    new JProperty("City", ShipperCityName),
                                    new JProperty("StateProvinceCode", ""),
                                    new JProperty("PostalCode", ShipperZipCode),
                                    new JProperty("CountryCode", ShipperCountryCode)
                                )
                            )
                        )
                    ),
                    new JProperty("ShipTo",
                        new JObject(
                            new JProperty("Name", ""),
                            new JProperty("Address",
                                new JObject(
                                    new JProperty("AddressLine", new JArray("", "", "")),
                                    new JProperty("City", ShipToCity),
                                    new JProperty("StateProvinceCode", ShipStateProvinceCode),
                                    new JProperty("PostalCode", ShipToZipCode),
                                    new JProperty("CountryCode", ShipToCountryCode)
                                )
                            )
                        )
                    ),
                    new JProperty("ShipFrom",
                        new JObject(
                            new JProperty("Name", ""),
                            new JProperty("Address",
                                new JObject(
                                    new JProperty("AddressLine", new JArray("", "", "")),
                                    new JProperty("City", ShipperCityName),
                                    new JProperty("StateProvinceCode", ""),
                                    new JProperty("PostalCode", ShipperZipCode),
                                    new JProperty("CountryCode", ShipToCountryCode)
                                )
                            )
                        )
                    ),
                    new JProperty("Service",
                        new JObject(
                            new JProperty("Code", UpsServiceCode),
                            new JProperty("Description", "")
                        )
                    ),
                    new JProperty("NumOfPieces", UpsNumofPieces),
                    new JProperty("Package", PackageArray)
                )
            )
        )
    )
);


            // Convert the dynamic object to a JSON string
            string json = jsonData.ToString();
            return json;

            // 'json' now contains the desired JSON structure


        }


        public Dictionary<string, string> CustomGetEstimateDate()
        {
            //string estimateDateXML = CustomGetTransitInTimeXML();

            //string upsEstimateDateURL = Equals(IsEstimateDateProductionURL, "true") ? ProductionEstimateDateURL : DevelopmentEstimateDateURL;

            //XmlDocument xml = GetUPSResponse(estimateDateXML, upsEstimateDateURL);

            //XmlNodeList serviceCodes = xml.SelectNodes("TimeInTransitResponse/TransitResponse/ServiceSummary");

            Dictionary<string, string> upsEstimateDate = new Dictionary<string, string>();
            //foreach (XmlNode item in serviceCodes)
            //{
            //    string estimateDate = item["EstimatedArrival"]["Date"].InnerXml;
            //    string serviceCode = item["Service"]["Code"].InnerXml;
            //    if (!string.IsNullOrEmpty(serviceCode) && !upsEstimateDate.Any(x => x.Key == serviceCode))
            //    {
            //        upsEstimateDate.Add(serviceCode, string.IsNullOrEmpty(estimateDate) ? string.Empty : DateTime.ParseExact(estimateDate, "yyyy-MM-dd", CultureInfo.InvariantCulture).ToString("MM-dd-yyyy"));
            //    }
            //}
            upsEstimateDate.Add("2DA", "09-26-2023");
            upsEstimateDate.Add("3DS", "09-26-2023");
            upsEstimateDate.Add("1DA", "09-26-2023");
            upsEstimateDate.Add("GND", "09-26-2023");
            return upsEstimateDate;
        }

        public string CustomGetTransitInTimeXML()
        {
            StringBuilder transitXML = new StringBuilder();

            IZnodeShippingHelper helper = GetService<IZnodeShippingHelper>();

            transitXML.Append("<?xml version='1.0'?>")
            .Append("<AccessRequest xml:lang='en-US'>")
            .Append("	<AccessLicenseNumber>" + UpsKey + "</AccessLicenseNumber>")
            .Append("	<UserId>" + UpsUserId + "</UserId>")
            .Append("	<Password>" + UpsPassword + "</Password>")
            .Append("</AccessRequest>")
            .Append("<?xml version='1.0'?>")
            .Append("<TimeInTransitRequest xml:lang='en-US'>")
            .Append("	<Request>")
            .Append("		<TransactionReference>")
            .Append("			<CustomerContext>Your Test Case Summary Description</CustomerContext>")
            .Append("			<XpciVersion>1.001</XpciVersion>")
            .Append("		</TransactionReference>")
            .Append("		<RequestAction>TimeInTransit</RequestAction>")
            .Append("	</Request>")
            .Append("	<TransitFrom>")
            .Append("		<AddressArtifactFormat>")
            .Append("			<PoliticalDivision2>" + ShipperCityName + "</PoliticalDivision2>")
            .Append("			<PostcodePrimaryLow>" + ShipperZipCode + "</PostcodePrimaryLow>")
            .Append("			<CountryCode>" + ShipperCountryCode + "</CountryCode>")
            .Append("		</AddressArtifactFormat>")
            .Append("	</TransitFrom>")
            .Append("	<TransitTo>")
            .Append("		<AddressArtifactFormat>")
            .Append("			<PoliticalDivision2>" + ShipToCity + "</PoliticalDivision2>")
            .Append("				<PoliticalDivision1>" + ShipStateProvinceCode + "</PoliticalDivision1>")
            .Append("				<Country>" + ShipToCountryCode + "</Country>")
            .Append("				<CountryCode>" + ShipToCountryCode + "</CountryCode>")
            .Append("				<PostcodePrimaryLow>" + ShipToZipCode + "</PostcodePrimaryLow>")
            .Append("				<PostcodePrimaryHigh>" + ShipToZipCode + "</PostcodePrimaryHigh>")
            .Append("			<CountryCode>" + ShipToCountryCode + "</CountryCode>")
            .Append("		</AddressArtifactFormat>")
            .Append("	</TransitTo>")
            .Append("	<PickupDate>" + helper.GetPickUpDate().ToString("yyyyMMdd") + "</PickupDate>")
            .Append("	<MaximumListSize>8</MaximumListSize>")
            .Append("	<InvoiceLineTotal>")
            .Append("		<CurrencyCode>USD</CurrencyCode>")
            .Append("		<MonetaryValue>50</MonetaryValue>")
            .Append("	</InvoiceLineTotal>")
            .Append("	<ShipmentWeight>")
            .Append("		<UnitOfMeasurement>")
            .Append("			<Code>LBS</Code>")
            .Append("			<Description>" + WeightUnit + "</Description>")
            .Append("		</UnitOfMeasurement>")
            .Append("		<Weight>" + PackageWeight + "</Weight>")
            .Append("	</ShipmentWeight>")
            .Append("</TimeInTransitRequest>");

            return transitXML.ToString();
        }


        //Atish Nivi code ups end




        public Dictionary<string, string> GetEstimateDate()
        {
            string estimateDateXML = GetTransitInTimeXML();

            string upsEstimateDateURL = Equals(IsEstimateDateProductionURL, "true") ? ProductionEstimateDateURL : DevelopmentEstimateDateURL;

            XmlDocument xml = GetUPSResponse(estimateDateXML, upsEstimateDateURL);

            XmlNodeList serviceCodes = xml.SelectNodes("TimeInTransitResponse/TransitResponse/ServiceSummary");

            Dictionary<string, string> upsEstimateDate = new Dictionary<string, string>();
            foreach (XmlNode item in serviceCodes)
            {
                string estimateDate = item["EstimatedArrival"]["Date"].InnerXml;
                string serviceCode = item["Service"]["Code"].InnerXml;
                if (!string.IsNullOrEmpty(serviceCode) && !upsEstimateDate.Any(x => x.Key == serviceCode))
                {
                    upsEstimateDate.Add(serviceCode, string.IsNullOrEmpty(estimateDate) ? string.Empty : DateTime.ParseExact(estimateDate, "yyyy-MM-dd", CultureInfo.InvariantCulture).ToString("MM-dd-yyyy"));
                }
            }
            return upsEstimateDate;
        }


        public string GetEstimateRateXML()
        {
            StringBuilder rateXML = new StringBuilder();
            var addressType = Equals(ShipToAddressType, "Residential") ? "1" : "0";
            rateXML.Append("<?xml version='1.0'?>")
            .Append("<AccessRequest xml:lang='en-US'>")
            .Append("    <AccessLicenseNumber>" + UpsKey + "</AccessLicenseNumber>")
            .Append("    <UserId>" + UpsUserId + "</UserId>")
            .Append("    <Password>" + UpsPassword + "</Password>")
            .Append("</AccessRequest>")
            .Append("<?xml version='1.0'?>")
            .Append("<RatingServiceSelectionRequest xml:lang='en-US'>")
            .Append("   <Request>")
            .Append("       <TransactionReference>")
            .Append("           <CustomerContext>Rating and Service</CustomerContext>")
            .Append("           <XpciVersion>1.0001</XpciVersion>")
            .Append("       </TransactionReference>")
            .Append("       <RequestAction>Rate</RequestAction>")
            .Append("       <RequestOption>Shop</RequestOption>")
            .Append("   </Request>")
            .Append("   <PickupType>")
            .Append("       <Code>" + PickupType + "</Code>")
            .Append("   </PickupType>")
            .Append("   <Shipment>")
            .Append("       <Shipper>")
            .Append("           <Address>")
            .Append("               <PostalCode>" + ShipperZipCode + "</PostalCode>")
            .Append("               <CountryCode>" + ShipperCountryCode + "</CountryCode>")
            .Append("           </Address>")
            .Append("       </Shipper>")
            .Append("       <ShipTo>")
            .Append("           <Address>")
            .Append("               <PostalCode>" + ShipToZipCode + "</PostalCode>")
            .Append("               <CountryCode>" + ShipToCountryCode + "</CountryCode>")
            .Append("               <ResidentialAddress>" + addressType + "</ResidentialAddress>")
            .Append("           </Address>")
            .Append("       </ShipTo>")                      
            .Append(PackageXml)
            .Append("   </Shipment>")
            .Append("</RatingServiceSelectionRequest>");

            return rateXML.ToString();
        }


        public string GetTransitInTimeXML()
        {
            StringBuilder transitXML = new StringBuilder();

            IZnodeShippingHelper helper = GetService<IZnodeShippingHelper>();

            transitXML.Append("<?xml version='1.0'?>")
            .Append("<AccessRequest xml:lang='en-US'>")
            .Append("	<AccessLicenseNumber>" + UpsKey + "</AccessLicenseNumber>")
            .Append("	<UserId>" + UpsUserId + "</UserId>")
            .Append("	<Password>" + UpsPassword + "</Password>")
            .Append("</AccessRequest>")
            .Append("<?xml version='1.0'?>")
            .Append("<TimeInTransitRequest xml:lang='en-US'>")
            .Append("	<Request>")
            .Append("		<TransactionReference>")
            .Append("			<CustomerContext>Your Test Case Summary Description</CustomerContext>")
            .Append("			<XpciVersion>1.001</XpciVersion>")
            .Append("		</TransactionReference>")
            .Append("		<RequestAction>TimeInTransit</RequestAction>")
            .Append("	</Request>")
            .Append("	<TransitFrom>")
            .Append("		<AddressArtifactFormat>")
            .Append("			<PoliticalDivision2>" + ShipperCityName + "</PoliticalDivision2>")
            .Append("			<PostcodePrimaryLow>" + ShipperZipCode + "</PostcodePrimaryLow>")
            .Append("			<CountryCode>" + ShipperCountryCode + "</CountryCode>")
            .Append("		</AddressArtifactFormat>")
            .Append("	</TransitFrom>")
            .Append("	<TransitTo>")
            .Append("		<AddressArtifactFormat>")
            .Append("			<PoliticalDivision2>" + ShipToCity + "</PoliticalDivision2>")
            .Append("				<PoliticalDivision1>" + ShipStateProvinceCode + "</PoliticalDivision1>")
            .Append("				<Country>" + ShipToCountryCode + "</Country>")
            .Append("				<CountryCode>" + ShipToCountryCode + "</CountryCode>")
            .Append("				<PostcodePrimaryLow>" + ShipToZipCode + "</PostcodePrimaryLow>")
            .Append("				<PostcodePrimaryHigh>" + ShipToZipCode + "</PostcodePrimaryHigh>")
            .Append("			<CountryCode>" + ShipToCountryCode + "</CountryCode>")
            .Append("		</AddressArtifactFormat>")
            .Append("	</TransitTo>")
            .Append("	<PickupDate>" + helper.GetPickUpDate().ToString("yyyyMMdd") + "</PickupDate>")
            .Append("	<MaximumListSize>8</MaximumListSize>")
            .Append("	<InvoiceLineTotal>")
            .Append("		<CurrencyCode>USD</CurrencyCode>")
            .Append("		<MonetaryValue>50</MonetaryValue>")
            .Append("	</InvoiceLineTotal>")
            .Append("	<ShipmentWeight>")
            .Append("		<UnitOfMeasurement>")
            .Append("			<Code>LBS</Code>")
            .Append("			<Description>" + WeightUnit + "</Description>")
            .Append("		</UnitOfMeasurement>")
            .Append("		<Weight>" + PackageWeight + "</Weight>")
            .Append("	</ShipmentWeight>")
            .Append("</TimeInTransitRequest>");

            return transitXML.ToString();
        }

        //Get Package XML to set multiple packages in shipping.
        public string GetPackageXML()
        {
            StringBuilder packageXML = new StringBuilder();
            packageXML.Append("<Package>")
            .Append("           <PackagingType>")
            .Append("               <Code>" + PackageTypeCode + "</Code>")
            .Append("           </PackagingType>")
            .Append("           <Dimensions>")
            .Append("               <UnitOfMeasurement>")
            .Append("                   <Code>IN</Code>")
            .Append("               </UnitOfMeasurement>")
            .Append("               <Length>" + PackageLength + "</Length>")
            .Append("               <Width>" + PackageWidth + "</Width>")
            .Append("               <Height>" + PackageHeight + "</Height>")
            .Append("           </Dimensions>")
            .Append("           <PackageWeight>")
            .Append("               <UnitOfMeasurement>")
            .Append("                   <Code>LBS</Code>")
            .Append("               </UnitOfMeasurement>")
            .Append("               <Weight>" + PackageWeight + "</Weight>")
            .Append("           </PackageWeight>")
            .Append("       </Package>");
            return packageXML.ToString();
        }

        //Get Package XML to set multiple packages in shipping.
        public JObject GetPackageJSON()//Atish ups 00
        {
            JObject packageObject = new JObject(
    new JProperty("PackagingType",
        new JObject(
            new JProperty("Code", PackageTypeCode),
            new JProperty("Description", "Packaging")
        )
    ),
    new JProperty("Dimensions",
        new JObject(
            new JProperty("UnitOfMeasurement",
                new JObject(
                    new JProperty("Code", "IN"),
                    new JProperty("Description", "Inches")
                )
            ),
            new JProperty("Length", Convert.ToString(PackageLength)),
            new JProperty("Width", Convert.ToString(PackageWidth)),
            new JProperty("Height", Convert.ToString(PackageHeight))
        )
    ),
    new JProperty("PackageWeight",
        new JObject(
            new JProperty("UnitOfMeasurement",
                new JObject(
                    new JProperty("Code", "LBS"),
                    new JProperty("Description", "Pounds")
                )
            ),
            new JProperty("Weight", Convert.ToString(PackageWeight))
        )
    )
);
            return packageObject;
        }

        public XmlDocument GetUPSResponse(string estimateRateXML, string getwayURL)
        {

            // Instantiate the request
            WebClient request = new WebClient();
            request.Headers.Add("Content-Type", "application/x-www-form-urlencoded");

            // Convert the payload into byte array and send the request to UPS
            byte[] requestBytes = Encoding.ASCII.GetBytes(estimateRateXML);
            ZnodeLogging.LogMessage("Execution Started :", ZnodeLogging.Components.Shipping.ToString(), TraceLevel.Info);
            byte[] responseBytes = request.UploadData(getwayURL, "POST", requestBytes);
            ZnodeLogging.LogMessage("Execution Ended :", ZnodeLogging.Components.Shipping.ToString(), TraceLevel.Info);
            ZnodeLogging.LogMessage("UPS Response:", ZnodeLogging.Components.Shipping.ToString(), TraceLevel.Verbose, new { responseBytes });

            // Decode the response bytes into an XML string and create an XML document from it
            string xmlResponse = Encoding.ASCII.GetString(responseBytes);
            XmlDocument xmlDocument = new XmlDocument();
            xmlDocument.LoadXml(xmlResponse);
            return xmlDocument;
        }

        public string GetDateByServiceCode(string serviceCode)
        {
            string upsServiceCode = string.Empty;
            switch (serviceCode)
            {
                case "14":
                    //1DM Next Day Air Early AM
                    upsServiceCode = "1DM";
                    break;
                case "01":
                    // 1DA Next Day Air
                    upsServiceCode = "1DA";
                    break;
                case "13":
                    // 1DP Next Day Air Saver
                    upsServiceCode = "1DP";
                    break;
                case "59":
                    // 2DM 2nd Day Air AM
                    upsServiceCode = "2DM";
                    break;
                case "02":
                    // 2DA 2nd Day Air
                    upsServiceCode = "2DA";
                    break;
                case "12":
                    // 3DS 3 Day Select
                    upsServiceCode = "3DS";
                    break;
                case "03":
                    // GND Ground
                    upsServiceCode = "GND";
                    break;
                case "54":
                    // EP Worldwide Express Plus
                    upsServiceCode = "EP";
                    break;
                case "07":
                    // ES Worldwide Express
                    upsServiceCode = "ES";
                    break;
                case "65":
                    // SV Worldwide Saver (Express)
                    upsServiceCode = "SV";
                    break;
                case "08":
                    // EX Worldwide Expedited
                    upsServiceCode = "EX";
                    break;
                case "11":
                    // ST Standard
                    upsServiceCode = "ST";
                    break;
                default:
                    break;
            }

            return upsServiceCode;
        }
    }
}

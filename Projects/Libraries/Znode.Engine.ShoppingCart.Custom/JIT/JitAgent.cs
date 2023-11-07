using RateAvailableServiceWebServiceClient.RateServiceWebReference;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Web.Services.Protocols;
using System.Xml;
using System.Xml.Linq;
using System.Xml.Serialization;
using Znode.Engine.Api.Models;
//using Znode.Engine.Shipping.Custom.JitShippingService; /// for Test
using Znode.Engine.Shipping.Custom.JITShippingServiceLive;  /// for live
using Znode.Engine.Shipping.Helper;
using Znode.Libraries.ECommerce.Utilities; 
using Znode.Libraries.Framework.Business;
using static Znode.Engine.Shipping.FedEx.FedExEnum;

namespace Znode.Engine.Shipping.Custom
{
    public class JitAgent : ZnodeBusinessBase
    {
        #region Constants
        private const string FedExConstantValue = "1"; 
        #endregion

        private string _errorDescription;

        public string ClientProductId { get; set; }
        public string ClientProductVersion { get; set; }
        public string CspAccessKey { get; set; }
        public string CspPassword { get; set; }
        public string CurrencyCode { get; set; } = "USD";
        public string DimensionUnit { get; set; } = "IN";
        public string DropOffType { get; set; } = "REGULAR_PICKUP";
        public string ErrorCode { get; set; } = "0";
        public string JITCustomerNumber { get; set; }
        public string JITPassword { get; set; }
        public string JITUsername { get; set; }
        public string FedExGatewayUrl { get; set; } = ZnodeApiSettings.FedExGatewayURL;
        public string JITServiceType { get; set; }
        public byte[] LabelImage { get; set; }
        public string OriginLocationId { get; set; }
        public string PackageHeight { get; set; } = FedExConstantValue;
        public string PackageLength { get; set; } = FedExConstantValue;
        public string PackageTypeCode { get; set; } = "YOUR_PACKAGING";
        public decimal PackageWeight { get; set; } = 0;
        public string PackageWidth { get; set; } = FedExConstantValue;
        public decimal ShipmentCharge { get; set; }
        public string ShipperAddress1 { get; set; }
        public string ShipperAddress2 { get; set; }
        public bool ShipperAddressIsResidential { get; set; } = false;
        public string ShipperCity { get; set; }
        public string ShipperCompany { get; set; }
        public string ShipperCountryCode { get; set; }
        public string ShipperPhone { get; set; }
        public string ShipperStateCode { get; set; }
        public string ShipperZipCode { get; set; }
        public string ShipToAddress1 { get; set; }
        public string ShipToAddress2 { get; set; }
        public bool ShipToAddressIsResidential { get; set; } = false;
        public string ShipToCity { get; set; }
        public string ShipToCompany { get; set; }
        public string ShipToCountryCode { get; set; }
        public string ShipToFirstName { get; set; }
        public string ShipToLastName { get; set; }
        public string ShipToPhone { get; set; }
        public string ShipToStateCode { get; set; }
        public string ShipToZipCode { get; set; }
        public string TrackingNumber { get; set; }
        public decimal TotalCustomsValue { get; set; } = 0;
        public decimal TotalInsuredValue { get; set; } = 0;
        public bool UseDiscountRate { get; set; } = false;
        public string VendorProductPlatform { get; set; }
        public string WeightUnit { get; set; } = "LB";
        public string PackageGroupCount { get; set; }
        public string PackageCount { get; set; }
        public string TotalHandlingUnits { get; set; }
        public string ItemPackageTypeCode { get; set; }
        public Dictionary<string, string> RateTimeInTransit { get; set; } = new Dictionary<string, string>();
        public Object CartCarrierList { get; set; }

        public string ErrorDescription
        {
            get
            {
                // FedEx returns "Service type is missing or invalid". Replace this with a user friendly message.
                if (ErrorCode.Equals("540"))
                    _errorDescription = "JIT does not support the selected shipping option to this zip code. Please select another shipping option.";

                return _errorDescription;
            }
            set
            {
                _errorDescription = value;
            }
        }

        public bool SignatureRequired
        {
            get;
            set;
        }

        public ShippingRateModel GetShippingRate(RateRequest JITRequest = null, decimal maxWeightLimit = 0.00M, bool isTimeInTransit = false)
        {
            decimal shippingRate = 0;
            string shippingETA = string.Empty;
            TPWXMLServiceClient jit = new TPWXMLServiceClient();
            String warehouseCode = null;

            try
            {
                List<TPWResponseQuote> carrierList = new List<TPWResponseQuote>();
                
                if (CartCarrierList == null)
                {
                    // Instantiate the JIT web service

                    Quote quote = new Quote();
                    quote.elemRequest = new QuoteElemRequest();
                    quote.elemRequest.TPW = new TPWQuoteRequest();
                    quote.elemRequest.TPW.Request = new TPWRequest();
                    quote.elemRequest.TPW.Request.RequestType = "QUOTE";
                    TPWRequestCredentials creds = new TPWRequestCredentials() { UserKey = JITCustomerNumber, UserName = JITUsername, Password = JITPassword };
                    quote.elemRequest.TPW.Request.Credentials = creds;

                    TPWRequestOrderShipping shipping = new TPWRequestOrderShipping()
                    {
                        FirstName = ShipToFirstName,
                        LastName = ShipToLastName,
                        Company = ShipToCompany,
                        Address1 = ShipToAddress1,
                        Address2 = ShipToAddress2,
                        City = ShipToCity,
                        State = ShipToStateCode,
                        Zip = ShipToZipCode,
                        Country = ShipToCountryCode,
                        Phone = ShipToPhone
                    };


                    TPWRequestOrderOptimism optimism = new TPWRequestOrderOptimism()
                    {
                        AllowDuplicatePO = "N"
                    };

                    TPWRequestOrder order = new TPWRequestOrder() { Shipping = shipping, Optimism = optimism };
                    order.Item = new TPWRequestOrderItem[JITRequest.RequestedShipment.RequestedPackageLineItems.Count()];
                    int itemCount = 0;
                    foreach (var item in JITRequest.RequestedShipment.RequestedPackageLineItems)
                    {
                        int qty = 0;
                        int.TryParse(item.GroupPackageCount, out qty);
                        TPWRequestOrderItem orderItem = new TPWRequestOrderItem() { Quantity = qty, SKU = item.ItemDescription };
                        order.Item[itemCount] = orderItem;
                        itemCount += 1;

                    }
                    quote.elemRequest.TPW.Request.Order = order;

                    string testMode = System.Configuration.ConfigurationManager.AppSettings["ShippingIntegrationTestMode"];

                    string xmlResponse;
                    using (var stringwriter = new System.IO.StringWriter())
                    {
                        var serializer = new XmlSerializer(quote.GetType());
                        serializer.Serialize(stringwriter, quote);
                        xmlResponse = stringwriter.ToString();
                    }
                    ZnodeLogging.LogMessage("JIT Integration - Request - " + xmlResponse, "Shipping", TraceLevel.Info);
                    // As per service selection check if it is freight service or not.
                    bool freightType = IsFreightServiceType(JITServiceType);

                    // Check request for freight and Create the rate request and get the reply from FedEx
                    XElement carriers = null;
                    if (testMode.ToLower() == "true")
                    {
                        JitShippingService.TPWXMLServiceClient jits = new JitShippingService.TPWXMLServiceClient();
                        carriers = jits.Quote(XElement.Parse(xmlResponse));
                    }
                    else
                    {
                        JITShippingServiceLive.TPWXMLServiceClient jits = new JITShippingServiceLive.TPWXMLServiceClient();
                        carriers = jits.Quote(XElement.Parse(xmlResponse));
                    }

                    ZnodeLogging.LogMessage("JIT Integration - Response - " + carriers.ToString(), "Shipping", TraceLevel.Error);

                    TPW jPW = new TPW();

                    StringReader reader = new StringReader(carriers.ToString());
                    XmlSerializer xmlSerializer = new XmlSerializer(typeof(TPW));
                    jPW = (TPW)xmlSerializer.Deserialize(reader);
                    CartCarrierList = jPW.Response;
                    
                    warehouseCode = (jPW.Response.Order != null ? jPW.Response.Order.LocationCode : null);
                    carrierList = (jPW.Response.Quotes != null ? ((TPWResponse)CartCarrierList).Quotes.ToList() : new List<TPWResponseQuote>());

                    if (jPW.Response.Error != null) {
                        Exception ex = new Exception("JIT Shipping: " + jPW.Response.Error);
                        ZnodeLogging.LogMessage(ex, "Shipping", TraceLevel.Error);
                        ErrorCode = "-1";
                        ErrorDescription = ex.Message;
                        //throw ex;
                    }
                }
                else
                {
                    if (((TPWResponse)CartCarrierList).Quotes != null){
                        carrierList = ((TPWResponse)CartCarrierList).Quotes.ToList();
                        warehouseCode = ((TPWResponse)CartCarrierList).Order.LocationCode;
                    }
                    
                }

                TPWResponseQuote carrier = carrierList.FirstOrDefault(o => o.CarrierCode == JITServiceType);


                // Check request for freight

                // For most FedEx calls we can consider Note, Warning, and above succcess
                if (carrier != null) {
                    shippingRate = carrier.Rate;
                    ErrorCode = "0";
                }
                else
                {
                    ErrorCode = "00009";
                    ErrorDescription = "Shipping method does not exist";
                }
            }
            catch (SoapException ex)
            {
                ZnodeLogging.LogMessage("JIT - Error: " + ex, "Shipping", TraceLevel.Error);
                ErrorCode = "-1";
                ErrorDescription = ex.Detail.InnerText;
            }
            catch (Exception ex)
            {
                ZnodeLogging.LogMessage("JIT - Error: " + ex, "Shipping", TraceLevel.Error);
                ErrorCode = "-1";
                ErrorDescription = ex.Message;
            }

            return new ShippingRateModel { ShippingRate = shippingRate, ApproximateArrival = shippingETA, Custom1 = warehouseCode };
        }

        public List<ShippingModel> GetJITEstimateRate(RateRequest JITRequest = null, decimal maxWeightLimit = 0.00M)
        {
            GetShippingRate(JITRequest, maxWeightLimit, true);
            List<ShippingModel> list = new List<ShippingModel>();

            foreach (var item in RateTimeInTransit ?? new Dictionary<string, string>())
            {
                string[] value = item.Value?.Split(',');
                if(!Equals(value, null))
                    list.Add(new ShippingModel { ShippingCode = item.Key, EstimateDate = value[0], ShippingRate = Convert.ToDecimal(value[1]) });
            }
            return list ?? new List<ShippingModel>();
        }

        public bool IsFreightServiceType(string FedExServiceType)
        {
            List<string> serviceType = new List<string>() { Convert.ToString(ServiceType.FEDEX_1_DAY_FREIGHT), Convert.ToString(ServiceType.FEDEX_2_DAY_FREIGHT), Convert.ToString(ServiceType.FEDEX_3_DAY_FREIGHT), Convert.ToString(ServiceType.FEDEX_3_DAY_FREIGHT), Convert.ToString(ServiceType.FEDEX_FIRST_FREIGHT), Convert.ToString(ServiceType.FEDEX_FREIGHT_ECONOMY), Convert.ToString(ServiceType.FEDEX_FREIGHT_PRIORITY), Convert.ToString(ServiceType.FEDEX_NEXT_DAY_FREIGHT), Convert.ToString(ServiceType.INTERNATIONAL_ECONOMY_FREIGHT), Convert.ToString(ServiceType.INTERNATIONAL_PRIORITY_FREIGHT) };
            return serviceType.Contains(FedExServiceType);
        }
    }
}

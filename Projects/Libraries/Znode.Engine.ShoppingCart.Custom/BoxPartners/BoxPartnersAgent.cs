using RateAvailableServiceWebServiceClient.RateServiceWebReference;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Web.Services.Protocols;
using Znode.Engine.Api.Models;
using Znode.Engine.Shipping.Helper;
using Znode.Libraries.ECommerce.Utilities;
using Znode.Libraries.Framework.Business;
using static Znode.Engine.Shipping.FedEx.FedExEnum;

namespace Znode.Engine.Shipping.Custom
{
    public class BoxPartnersAgent : ZnodeBusinessBase
    {
        #region Constants
        private const string FedExConstantValue = "1";
        #endregion

        private string _errorDescription;

        public string CurrencyCode { get; set; } = "USD";
        public string DimensionUnit { get; set; } = "IN";
        public string DropOffType { get; set; } = "REGULAR_PICKUP";
        public string ErrorCode { get; set; } = "0";
        public string BoxPartnersCustomerNumber { get; set; }
        public string BoxPartnersPassword { get; set; }
        public string BoxPartnersServiceType { get; set; }
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
        public Object CartCarrierList {get; set;}

        public string ErrorDescription
        {
            get
            {
                // FedEx returns "Service type is missing or invalid". Replace this with a user friendly message.
                if (ErrorCode.Equals("540"))
                    _errorDescription = "Box Partners does not support the selected shipping option to this zip code. Please select another shipping option.";

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

        public ShippingRateModel GetShippingRate(RateRequest boxPartnersRequest = null, decimal maxWeightLimit = 0.00M, bool isTimeInTransit = false)
        {
            decimal shippingRate = 0;
            string shippingETA = string.Empty;
            BOXFrghtEst boxPartnersService = null;

            try
            {
                List<Carrier> carrierList = new List<Carrier>();
                if (CartCarrierList == null)
                {

                    // Instantiate the BoxPartners web service
                    boxPartnersService = new BOXFrghtEst();

                    // As per service selection check if it is freight service or not.
                    bool freightType = IsFreightServiceType(BoxPartnersServiceType);

                    // Check request for freight and Create the rate request and get the reply from FedEx

                    var carriers = carrierList.ToArray();

                    List<BOXItem> boxItems = new List<BOXItem>();
                    foreach (var item in boxPartnersRequest.RequestedShipment.RequestedPackageLineItems)
                    {
                        int qty = 0;
                        int.TryParse(item.GroupPackageCount, out qty);
                        BOXItem boxItem = new BOXItem { ItemCode = item.ItemDescription, Quantity = qty };
                        boxItems.Add(boxItem);
                    }
                    ZnodeLogging.LogMessage("Box Partners Integration - Request \n Items:" + Newtonsoft.Json.JsonConvert.SerializeObject(boxItems) + "\nZipCode: " + ShipToZipCode + "\nStateCode: " + ShipToStateCode, "Shipping", TraceLevel.Info);

                    carriers = boxPartnersService.FreightEstimate(boxItems.ToArray(), BoxPartnersCustomerNumber, BoxPartnersPassword, ShipToZipCode, ShipToStateCode, ShipToAddressIsResidential);
                    carrierList = (from data in carriers select data).ToList();
                    CartCarrierList = carrierList;
                    ZnodeLogging.LogMessage("Box Partners Integration - Response - " + carriers.ToString(), "Shipping", TraceLevel.Info);

                }
                else
                {
                    carrierList = (List<Carrier>)CartCarrierList;
                }
                
                Carrier carrier = carrierList.FirstOrDefault(o => o.CarrierID == BoxPartnersServiceType);
                
                // Check request for freight

                // For most FedEx calls we can consider Note, Warning, and above succcess
                if (carrier != null) {
                    shippingRate = carrier.FreightTotal;
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
                Exception exError = new Exception("Box Partners Shipping: " + ex.Message); 
                ZnodeLogging.LogMessage(exError, "Shipping", TraceLevel.Error);
                ErrorCode = "-1";
                ErrorDescription = exError.Message;
                // if the first response was an error, create the object anyway so that subsequent requests are skipped
                CartCarrierList = new List<Carrier>();
            }
            catch (Exception ex)
            {
                ZnodeLogging.LogMessage("Box Partners Shipping: " + ex, "Shipping", TraceLevel.Error);
                ErrorCode = "-1";
                ErrorDescription = ex.Message;
            }

            return new ShippingRateModel { ShippingRate = shippingRate, ApproximateArrival = shippingETA, Custom1 = "BOX" };
        }

        public List<ShippingModel> GetBoxPartnersEstimateRate(RateRequest boxPartnersRequest = null, decimal maxWeightLimit = 0.00M)
        {
            GetShippingRate(boxPartnersRequest, maxWeightLimit, true);
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
